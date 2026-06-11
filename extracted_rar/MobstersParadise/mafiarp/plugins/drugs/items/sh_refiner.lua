-- "gamemodes\\mafiarp\\plugins\\drugs\\items\\sh_refiner.lua"

ITEM.name = "Drug Refiner"
ITEM.desc = "A complex machine that refines bulk drugs, increasing purity and profit."
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
	["cocaine"] = {
		name = "Refined Cocaine",
		required_item = "bulk_cocaine",
		result = "refined_cocaine",
		process_time = 300,
		canProcess = {},
	},
	["weed"] = {
		name = "Refined Marijuana",
		required_item = "bulk_weed",
		result = "refined_weed",
		process_time = 300,
		canProcess = {},
	},
	["heroin"] = {
		name = "Refined Heroin",
		required_item = "bulk_heroin",
		result = "refined_heroin",
		process_time = 300,
		canProcess = {},
	},
	["lsd"] = {
		name = "Refined LSD",
		required_item = "bulk_lsd",
		result = "refined_lsd",
		process_time = 300,
		canProcess = {},
	},
	["meth"] = {
		name = "Refined Meth",
		required_item = "bulk_meth",
		result = "refined_meth",
		process_time = 300,
		canProcess = {}
	},
	["opium"] = {
		name = "Refined Opium",
		required_item = "bulk_opium",
		result = "refined_opium",
		process_time = 300,
		canProcess = {}
	},
	["methaqualone"] = {
		name = "Refined Methaqualone",
		required_item = "bulk_methaqualone",
		result = "refined_methaqualone",
		process_time = 300,
		canProcess = {}
	},
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
			print(item)
			local client = item.player
			local inventory = client:getChar():getInv()
			local bulk = inventory:getFirstItemOfType(drug_info.required_item)

			if bulk:getData("shippedMiami") && isMiami then
				client:notify("You can't refine a UnionCity shipped drug in UnionCity!")
				return false 
			end

			if bulk:getData("shippedNewYork") && !isMiami then
				client:notify("You can't refine a SouthSide shipped drug in SouthSide!")
				return false 
			end

			if !bulk:getData("shippedNewYork") && !bulk:getData("shippedMiami") then
				client:notify("The origin of this drug cannot be authenticated, therefore it's unable to be refined.")
				return false
			end

			if !drug_info.canProcess[client:getChar():getFaction()] then
				client:notify("Your faction can't refine this drug!")
				return false
			end
			
			if (!IsValid(item.entity)) then
				client:notify("The drug refiner must be on the ground.")
				return false
			end

			if item.entity:WaterLevel() > 1 then
				client:notify("You cannot use a drug refiner while it is submerged!")
				return false
			end
			
				
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
				client:notify("You cannot be operating more than 1 drug processor/refiner at a time.")
				return false
			end
			
			table.insert(KTDrugCounter[steam64].labs, item)
			
			bulk:remove()
			
			item:setData("producing2", CurTime())
			client:notify("The drug is being refined.")
			timer.Simple(drug_info.process_time,
				function()
					if(item) then
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
	if action == "take" and item.uniqueID == "refiner" then
		if item:getData("producing2") then
			return false, "You cannot pick up a drug refiner while it's refining!"
		end

		if item:getData("finishedProduct") then
			return false, "You cannot pick up a drug refiner with a finished product!"
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
			["refined_weed"] = 1,
			["refined_cocaine"] = 1,
			["refined_opium"] = 1,
			["refined_heroin"] = 1,
			["refined_meth"] = 1,
			["refined_methaqualone"] = 1,
			["refined_lsd"] = 1,
			["refined_mdma"] = 1,
			["refined_shrooms"] = 1,
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
		client:notify("Your "..nut.item.list[ product ].name.." has finished refining and has been packaged up ready for distribution.")
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
			"refined_weed",
			"refined_cocaine",
			"refined_opium",
			"refined_heroin",
			"refined_meth",
			"refined_methaqualone",
			"refined_lsd",
			"refined_mdma",
			"refined_shrooms",
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
		desc = desc .. "\nThis drug refiner is currently refining something."
	end
	
	return Format(desc)
end