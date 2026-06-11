-- "gamemodes\\mafiarp\\plugins\\drugs\\items\\sh_drug_lab.lua"

ITEM.name = "Drug Processor"
ITEM.desc = "A complex machine that turns bulk drugs into individual products."
ITEM.model = "models/props_wasteland/laundry_basket001.mdl"
--[[ITEM.iconCam = {
	pos = Vector(198.82220458984, 164.32398986816, 125.13986968994),
	ang = Angle(25, 220, 0),
	fov = 4.7614206458922
}--]]
ITEM.iconCam = {
	pos = Vector(512.7646484375, 430.02493286133, 312.71917724609),
	ang = Angle(25, 220, 0),
	fov = 5.9695053222677,
}
ITEM.width = 2
ITEM.height = 2
ITEM.price = 2000
ITEM.category = "Drugs"
ITEM.color = Color(50, 255, 50)
ITEM.drugs = {
	["weed"] = {
		name = "Process Marijuana",
		required_item = "bulk_weed",
		result = "weed_imported",
		process_time = 300,
	},
	["opium"] = {
		name = "Process Opium",
		required_item = "bulk_opium",
		result = "opium",
		process_time = 300,
	},
	["heroin"] = {
		name = "Process Heroin",
		required_item = "bulk_heroin",
		result = "heroin",
		process_time = 300,
	},
	["meth"] = {
		name = "Process Meth",
		required_item = "bulk_meth",
		result = "meth",
		process_time = 300,
	},
	["methaqualone"] = {
		name = "Process Methaqualone",
		required_item = "bulk_methaqualone",
		result = "methaqualone",
		process_time = 300,
	},
	["lsd"] = {
		name = "Process LSD",
		required_item = "bulk_lsd",
		result = "lsd",
		process_time = 300,
	},
	["cocaine"] = {
		name = "Process Cocaine",
		required_item = "bulk_cocaine",
		result = "cocaine",
		process_time = 300,
	}
}

function ITEM:onRemoved()
	local item = self
	if (item.lastUser && KTDrugCounter[item.lastUser] && KTDrugCounter[item.lastUser].labs) then
		for k,v in pairs(KTDrugCounter[item.lastUser].labs) do
			if (v == self) then
				KTDrugCounter[item.lastUser].labs[k] = nil
				break
			end
		end

		KTDrugCounter[item.lastUser].labs = table.ClearKeys(KTDrugCounter[item.lastUser].labs)
	end
end

for class,drug_info in next, ITEM.drugs do
	ITEM.functions[class] = {
		name = drug_info.name,
		icon = "icon16/cog.png",
		sound = "buttons/lightswitch2.wav",
		onRun = function(item)
			local client = item.player
			local inventory = client:getChar():getInv()
			
			if (!IsValid(item.entity)) then
				client:notify("The drug processor must be on the ground.")
				return false
			end

			if item.entity:WaterLevel() > 1 then
				client:notify("You cannot use a drug processor while it is submerged!")
				return false
			end
			
			local bulk = inventory:getFirstItemOfType(drug_info.required_item)
				
			if (!bulk) then
				client:notifyLocalized("You need a "..drug_info.required_item) return false
			end
			
			local steam64 = client:SteamID64()
			item.lastUser = steam64
			KTDrugCounter[steam64] = KTDrugCounter[steam64] or {}
			KTDrugCounter[steam64].labs = KTDrugCounter[steam64].labs or {}
			local count = 0
			for k,v in pairs(KTDrugCounter[steam64].labs) do
				if (!v || !nut.item.instances[v.id] || nut.item.instances[v.id] != v) then
					KTDrugCounter[steam64].labs[k] = nil
					continue
				end
				
				count = count + 1
			end
			
			KTDrugCounter[steam64].labs = table.ClearKeys(KTDrugCounter[steam64].labs)
			if (count >= 1) then
				client:notify("You cannot be operating more than 1 drug processor at a time.")
				return false
			end
			
			table.insert(KTDrugCounter[steam64].labs, item)
			
			bulk:remove()
			
			item:setData("producing2", CurTime())
			client:notify("The drug is being processed.")
			timer.Simple(drug_info.process_time,
				function()
					if(item) then
						if item.entity:WaterLevel() > 1 then
							client:notify("Your drug processor failed because it is submerged in water!")
							return false
						end

						for k,v in pairs(KTDrugCounter[item.lastUser].labs) do
							if (v == item) then
								KTDrugCounter[item.lastUser].labs[k] = nil
								break
							end
						end

						KTDrugCounter[item.lastUser].labs = table.ClearKeys(KTDrugCounter[item.lastUser].labs)
						item.lastUser = nil
						
						item:setData("producing2", nil)
						
						item:setData("finishedProduct", drug_info.result)
						if IsValid(client) and client:getChar() then
							client:notify("The "..class.." is ready.")
						end
					end
				end
			)
			return false
		end,
		onCanRun = function(item) --only one farm action should be happening at once with one item.
			if (!IsValid(item.entity)) then
				return false
			end

			if item.entity:WaterLevel() > 1 then
				return false
			end

			local hasBulk = item.player:getChar():getInv():hasItem(drug_info.required_item)
			if !hasBulk then return false end
			
			if (item:getData("finishedProduct")) then
				return false
			end
			
			if(item:getData("producing2") != nil) then
				local endTime = item:getData("producing2", 0) + 300
				if (item:getData("producing2", 0) > CurTime() or CurTime() > endTime) then
					return true
				end
				
				return false
			end

			return true
		end
	}
end

ITEM.functions.take.onCanRun = function(item)
	if (item:getData("finishedProduct")) then
		return false
	end
	
	return IsValid(item.entity) and !item:getData("producing2")
end

hook.Add("CanPlayerInteractItem", "PreventDrugProcessorPickup", function(client, action, item, data)
	if action == "take" and item.uniqueID == "drug_lab" then
		if item:getData("producing2") then
			return false, "You cannot pick up a drug processor while it's processing!"
		end

		if item:getData("finishedProduct") then
			return false, "You cannot pick up a drug processor with a finished product!"
		end	
	end
end)

ITEM.functions.Collect = {
	tip = "Collect Product",
	icon = "icon16/box.png",
	onRun = function(item)
		local product = item:getData("finishedProduct")
		local client = item.player
		local allowed = {
			["weed"] = 10,
			["weed_imported"] = 10,
			["crack"] = 10,
			["cocaine"] = 10,
			["opium"] = 10,
			["heroin"] = 10,
			["meth"] = 10,
			["morphine"] = 10,
			["methaqualone"] = 10,
			["lsd"] = 10,
			["mdma"] = 10,
			["shrooms"] = 10,
		}
		
		if (!product) then
			client:notify("You should not be able to run this.")
			return false
		end
		
		--[[if (!table.HasValue(allowed, product)) then
			client:notify("finishedProduct variable invalid!")
			return false
		end]]--
				
		item:setData("finishedProduct")
		client:notify("Your "..nut.item.list[ product ].name.." has finished processing and has been packaged up ready for distribution.")
			local char = client:getChar()
			local entity = ents.Create("nut_shipment")
			entity:SetPos(client:getItemDropPos())
			entity:Spawn()
			local itemTable = {}
			itemTable[ product ] = allowed[ product ]
			entity:setItems(itemTable)
			entity:setNetVar("owner", char:getID())
			local shipments = char:getVar("charEnts") or {}
			table.insert(shipments, entity)
			char:setVar("charEnts", shipments, true)
		return false
	end,
	onCanRun = function(item)
		if (!IsValid(item.entity)) then
			return false
		end
		
		local product = item:getData("finishedProduct")
		local allowed = {
			"weed",
			"weed_imported",
			"crack",
			"cocaine",
			"opium",
			"heroin",
			"meth",
			"morphine",
			"methaqualone",
			"lsd",
			"mdma",
			"shrooms",
		}
		if (item:getData("finishedProduct") && table.HasValue(allowed, item:getData("finishedProduct"))) then
			return true
		end
		
		return false
	end
}

function ITEM:getDesc()
	local desc = self.desc

	if(self:getData("producing2") != nil) then
		desc = desc .. "\nThis drug processor is currently producing something."
	end
	
	return Format(desc)
end