-- "gamemodes\\mafiarp\\plugins\\cardealer\\sh_plugin.lua"

PLUGIN.name = "Car Dealer"
PLUGIN.author = "rusty"
PLUGIN.desc = "I recoded this whole thing."

nut.util.includeDir("libs")
nut.util.includeDir("derma")

nut.config.add("vehicleRepairCost", 50, "The amount it costs to rent a car repair tool.", nil, {
	data = {min = 1, max = 100},
	category = "vehicles"
})

nut.config.add("vehicleRepairTime", 30, "The time allotted to you when you rent a car repair tool.", nil, {
	data = {min = 1, max = 120},
	category = "vehicles"
})

nut.config.add("vehicleRepairEnabled", false, "Whether or not paint jobs/car repair tool rentals are enabled.", nil, {
	category = "vehicles"
})

nut.config.add("vehiclePaintCost", 250, "The amount it costs to paint a vehicle.", nil, {
	data = {min = 1, max = 1000},
	category = "vehicles"
})

PLUGIN.loaded_vehicles = PLUGIN.loaded_vehicles or {}

ALWAYS_RAISED = ALWAYS_RAISED or {}
ALWAYS_RAISED["weapon_simrepair"] = true

/*
	Metaobject
*/

PLUGIN.meta_vehicle = {}
AccessorFunc(PLUGIN.meta_vehicle, "owner", "OwnerID", FORCE_NUMBER)
AccessorFunc(PLUGIN.meta_vehicle, "id", "ID", FORCE_NUMBER)
AccessorFunc(PLUGIN.meta_vehicle, "invID", "InvID", FORCE_NUMBER)
AccessorFunc(PLUGIN.meta_vehicle, "class", "Class", FORCE_STRING)
AccessorFunc(PLUGIN.meta_vehicle, "data", "FullData")
PLUGIN.meta_vehicle.__index = PLUGIN.meta_vehicle

function PLUGIN.meta_vehicle:getData(key, default)
	if !self:GetFullData() then
		self:SetFullData({})
	end

	return self:GetFullData()[key] or default
end

function PLUGIN.meta_vehicle:getOwner()
	local character = nut.char.loaded[self:GetOwnerID()]
	if !character then return end
	if !IsValid(character:getPlayer()) then return end
	if !character:getPlayer():getChar() then return end

	return (character:getPlayer():getChar():getID() == self:GetOwnerID() and character:getPlayer()) or false -- hack
end

function PLUGIN.meta_vehicle:getInv()
	return nut.inventory.instances[self:GetInvID()]
end

if SERVER then
	function PLUGIN.meta_vehicle:setData(key, value, noSave, noNetwork)
		if !self:GetFullData() then
			self:SetFullData({})
		end

		self:GetFullData()[key] = value

		if SERVER then
			if !noSave then
				nut.db.preparedCall("vehicleUpdateData", function()
					-- log smth
				end, util.TableToJSON(self:GetFullData()), self:GetID())
			end

			if !noNetwork and IsValid(self:getOwner()) then
				net.Start("vehicleData")
					net.WriteUInt(self:GetID(), 32)
					net.WriteString(key)
					net.WriteType(value)
				net.Send(self:getOwner())
			end
		end
	end

	function PLUGIN.meta_vehicle:save(callback)
		if !self:GetID() then
			nut.db.preparedCall("vehicleCreate", function(data, lastInsert)
				self:SetID(lastInsert)

				if callback then
					callback(self)
				end
			end, self:GetOwnerID(), self:GetClass(), self:GetInvID(), util.TableToJSON(self:GetFullData()))
		end
	end

	function PLUGIN.meta_vehicle:delete()
		nut.db.preparedCall("vehicleDelete", function()
			nut.inventory.deleteByID(self:GetInvID())
			net.Start("vehicleDelete")
				net.WriteUInt(self:GetID(), 32)
			net.Broadcast()

			nut.plugin.list.cardealer.loaded_vehicles[self:GetID()] = nil
		end, self:GetID())
	end

	function PLUGIN.meta_vehicle:spawn(pos, ang)
		if self:getData("entity") then return end

		local ply = self:getOwner() 

		local veh_info = nut.plugin.list.cardealer.Vehicles[self:GetClass()]
		local class = veh_info.Identifier
		local name = veh_info.Name

		local ent = simfphys.SpawnVehicleSimple(class, pos, ang)
		ent:SetNWInt("Owner", ply:EntIndex())
		ent:SetNW2Int("VehicleID", self:GetID()) -- better than nw1
		ent:GetDriverSeat()
		ent:Lock()
		ent.CPPIGetOwner = function()
			return ply
		end
		ply.vehicleEnt = ent
		
		self:setData("in_use", true, true)
		self:setData("entity", ent, true)
		hook.Run("PostVehicleSpawn", self, ent, ply)

		return ent
	end

	function PLUGIN.meta_vehicle:sync(receiver)
		net.Start("vehicleFullUpdate")
			net.WriteUInt(self:GetID(), 32)
			net.WriteUInt(self:GetOwnerID(), 32)
			net.WriteString(self:GetClass())
			net.WriteUInt(self:GetInvID(), 32)

			local data = self:GetFullData() or {}
			local count = table.Count(data)
			net.WriteUInt(count, 32)
			if count > 0 then
				for key,value in next, data do
					net.WriteString(key)
					net.WriteType(value)
				end
			end
		if receiver then
			net.Send(receiver)
		else
			net.Broadcast()
		end
	end
end

/*
	Constructor
*/

function PLUGIN:CreateVehicle(class)
	local vehicle = {}
	setmetatable(vehicle, self.meta_vehicle)

	vehicle:SetClass(class)
	
	return vehicle
end

/*
	Functions
*/

function PLUGIN:GiveVehicle(ply, class)
	local veh_data = self.Vehicles[class]
	if !veh_data then return end

	nut.inventory.instance("grid", {w = veh_data.w or 10, h = veh_data.h or 4}):next(function(inv)
		local vehicle = self:CreateVehicle(class)
		vehicle:SetOwnerID(ply:getChar():getID())
		vehicle:SetInvID(inv:getID())
		vehicle:SetFullData({})
		vehicle:save(function(veh)
			veh:sync(ply)
			self.loaded_vehicles[veh:GetID()] = veh
		end)
	end)
end

function PLUGIN:hasVehicle(ply, class)
	for id,vehicle in next, self.loaded_vehicles do
		if veh:GetClass() == class then return vehicle end
	end
end

/*
	Networking
*/

if CLIENT then
	net.Receive("vehicleFullUpdate", function(len)
		local plugin = nut.plugin.list.cardealer
		local id = net.ReadUInt(32)
		local owner = net.ReadUInt(32)
		local class = net.ReadString()
		local invID = net.ReadUInt(32)

		local data = {}
		local dataCount = net.ReadUInt(32)
		for i = 1, dataCount do
			data[net.ReadString()] = net.ReadType()
		end

		local veh = plugin:CreateVehicle(class)
		veh:SetID(id)
		veh:SetOwnerID(owner)
		veh:SetInvID(invID)
		veh:SetFullData(data)

		plugin.loaded_vehicles[id] = veh
	end)

	net.Receive("vehicleData", function(len)
		local plugin = nut.plugin.list.cardealer
		local id = net.ReadUInt(32)
		local key = net.ReadString()
		local value = net.ReadType()

		local vehicle = plugin.loaded_vehicles[id]
		if vehicle then
			if !vehicle:GetFullData() then
				vehicle:SetFullData({})
			end

			vehicle:GetFullData()[key] = value
		end
	end)

	net.Receive("vehicleDelete", function(len)
		local id = net.ReadUInt(32)
		local veh = nut.plugin.list.cardealer.loaded_vehicles[id]

		if veh then
			nut.plugin.list.cardealer.loaded_vehicles[id] = nil
		end
	end)
end