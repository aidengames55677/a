-- "gamemodes\\mafiarp\\plugins\\drugs\\items\\sh_weed_plant.lua"

ITEM.name = "Marijuana Plant"
ITEM.model = "models/props_junk/terracotta01.mdl"
ITEM.desc = "A marijuana plant."
ITEM.width = 2
ITEM.height = 2
ITEM.flag = "v"
ITEM.price = 500
ITEM.category = "Drugs"
ITEM.color = Color(50, 255, 50)
ITEM.flag = "9"

function MafiaRPDrugs_setWeedModel(item)
	local growth = math.floor(math.Clamp(item:getData("growth", 0), 0, 10))
	local growthModels = {
		[0] = "models/props_junk/terracotta01.mdl",
		[1] = "models/nater/weedplant_pot_growing1.mdl",
		[2] = "models/nater/weedplant_pot_growing1.mdl",
		[3] = "models/nater/weedplant_pot_growing2.mdl",
		[4] = "models/nater/weedplant_pot_growing2.mdl",
		[5] = "models/nater/weedplant_pot_growing3.mdl",
		[6] = "models/nater/weedplant_pot_growing4.mdl",
		[7] = "models/nater/weedplant_pot_growing5.mdl",
		[8] = "models/nater/weedplant_pot_growing6.mdl",
		[9] = "models/nater/weedplant_pot_growing6.mdl",
		[10] = "models/nater/weedplant_pot_growing7.mdl",
	}
	local chosen = growthModels[growth]
	local ent = item:getEntity()
	if (IsValid(ent)) then
		ent:SetModel(chosen)
	end
end


KTDrugCounter = KTDrugCounter or {}

function ITEM:onRemoved()
	local item = self
	if (item.lastUser && KTDrugCounter[item.lastUser] && KTDrugCounter[item.lastUser].weed) then
		for k,v in pairs(KTDrugCounter[item.lastUser].weed) do
			if (v == self) then
				KTDrugCounter[item.lastUser].weed[k] = nil
				break
			end
		end

		KTDrugCounter[item.lastUser].weed = table.ClearKeys(KTDrugCounter[item.lastUser].weed)
	end

end

ITEM.functions.Water = {
	icon = "icon16/box.png",
	sound = "npc/barnacle/barnacle_tongue_pull1.wav",
	onRun = function(item)
		local client = item.player
		local char = client:getChar()
		local position = client:getItemDropPos()
		local inventory = char:getInv()
		
		local water = inventory:getFirstItemOfType("water_jug")

		if (!IsValid(item.entity)) then
			client:notify("You can't do that while this item is in your inventory.")
			return false
		end
		
		if(water) then
			local steam64 = client:SteamID64()
			item.lastUser = steam64
			KTDrugCounter[steam64] = KTDrugCounter[steam64] or {}
			KTDrugCounter[steam64].weed = KTDrugCounter[steam64].weed or {}
			local count = 0
			for k,v in pairs(KTDrugCounter[steam64].weed) do
				if (!v || !nut.item.instances[v.id] || nut.item.instances[v.id] != v) then
					KTDrugCounter[steam64].weed[k] = nil
					continue
				end
				
				count = count + 1
			end
			
			KTDrugCounter[steam64].weed = table.ClearKeys(KTDrugCounter[steam64].weed)
			if (count >= 5) then
				client:notify("You cannot be growing more than 5 marijuana plants at the same time.")
				return false
			end
			
			table.insert(KTDrugCounter[steam64].weed, item)
			
			--local container = water.container
			water:remove()
			--inventory:add(container)
			item:setData("producing2", CurTime())
			timer.Simple(300, --300, --5 minutes IF YOU CHANGE THIS NUMBER CHANGE THE IDENTICAL ONE BELOW AS WELL (CTRL-F) local endTime = item:getData("producing2", 0) + 300 <--- this one (down below)
				function()
					if (item != nil) then
						for k,v in pairs(KTDrugCounter[item.lastUser].weed) do
							if (v == item) then
								KTDrugCounter[item.lastUser].weed[k] = nil
								break
							end
						end

						if item.entity:WaterLevel() > 1 then
							client:notify("Your plant died while submerged underwater!")
							item.entity:Remove()
							return false
						end

						KTDrugCounter[item.lastUser].weed = table.ClearKeys(KTDrugCounter[item.lastUser].weed)
						item.lastUser = nil
						
						item:setData("producing2", 0)
						item:setData("growth", item:getData("growth", 0) + 2)
						local growth = item:getData("growth", 0)

						if growth > 3 then
							item.canBeHarvested = true
							item:setData("canBeHarvested", true, nil, true)
						end

						client:notify("Your weed plant has grown.")
						MafiaRPDrugs_setWeedModel(item)
					end
				end
			)
		else
			client:notifyLocalized("You don't have any water jugs!") return false
		end
		return false
	end,
	onCanRun = function(item)		
		local growth = item:getData("growth", 0)
		if (growth == 10) then
			return false
		end
		
		if(item:getData("producing2", 0) != 0) then
			local endTime = item:getData("producing2", 0) + 300
			if (item:getData("producing2", 0) > CurTime() or CurTime() > endTime) then
				return true
			end
			
			return false
		end
		
		return true
	end
}

ITEM.functions.drop = {
	tip = "dropTip",
	icon = "icon16/world.png",
	onRun = function(item)
		local client = item.player
		item:removeFromInventory(true)
			:next(function() item:spawn(client) end)
		nut.log.add(item.player, "itemDrop", item.name, 1)
		
		MafiaRPDrugs_setWeedModel(item)
		return false
	end,
	onCanRun = function(item)
		return (!IsValid(item.entity) and !item.noDrop)
	end
}

local gridinv_meta = FindMetaTable("GridInv")

function gridinv_meta:findMultipleEmptySlots(w, h)
	local results = {}
	
	w = w or 1
	h = h or 1

	if (w > self.w or h > self.h) then
		return results
	end

	for y = 1, self.h - (h - 1) do
		for x = 1, self.w - (w - 1) do
			if (self:canItemFit(x, y, w, h)) then
				table.insert(results, {x, y})
			end
		end
	end
	
	return results
end

ITEM.functions.Harvest = {
	icon = "icon16/box.png",
	sound = "npc/barnacle/barnacle_tongue_pull1.wav",
	onRun = function(item)
		local client = item.player
		local char = client:getChar()
		local position = client:getItemDropPos()
		local inventory = char:getInv()

		local growth = item:getData("growth", 0)
		if growth <= 3 then return false end
		if growth - 4 < 0 then return false end
		
		if (!inventory:findFreePosition("weed")) then --if the inventory has space, put it in the inventory
			client:notify("You have no space in your inventory.")
			return false
		end

		inventory:add("weed")
		
		item:setData("growth", growth - 4)
		if growth - 4 <= 3 then
			item.canBeHarvested = false
			item:setData("canBeHarvested", false, nil, true)
		end
		MafiaRPDrugs_setWeedModel(item)
		return false
	end,
	onCanRun = function(item)
		local growth = item:getData("growth", 0)
		
		if growth > 3 and ((SERVER and item.canBeHarvested) or item:getData("canBeHarvested")) then --want to have at least 40% growth to be able to cut plant.
			return true
		else
			return false
		end
	end
}

ITEM.functions.Name = {
	tip = "Name this item",
	icon = "icon16/add.png",
	onRun = function(item)
		local client = item.player
		client:requestString("Change Name", "What do you want to name your plant? (This is final)", function(text)
			item:setData("customName", text)
		end, item.name)
		
		return false
	end,
	onCanRun = function(item)
		if (item:getData("customName") != nil) then
			return false
		else
			return true
		end
	end
}

function ITEM:getName()
	local name = self.name
	
	if(self:getData("customName") != nil) then
		name = self:getData("customName")
	end
	
	return Format(name)
end

function ITEM:getDesc()
	local desc = self.desc
	
	if(self:getData("producing2") != nil) then
		desc = desc .. "\nThis plant has been watered recently."
	end	
	
	if(self:getData("growth") != nil) then
		local growth = self:getData("growth", 0)
		local growthMsg = "\nThis plant is " .. growth * 10 .. " percent grown." 

		desc = desc .. growthMsg
	end
	
	return Format(desc)
end

ITEM.functions.take.onCanRun = function(item)
	if (item:getData("growth", 0) > 0) then
		return false
	end
	
	return IsValid(item.entity) and item:getData("producing2", 0) == 0
end

hook.Add("CanPlayerInteractItem", "PreventWeedPlantPickup", function(client, action, item, data)
	if action == "take" and item.uniqueID == "weed_plant" then
		if item:getData("producing2", 0) > 0 then
			return false, "You cannot pick up a weed plant while it's growing!"
		end

		if item:getData("growth", 0) > 0 then
			return false, "You cannot pick up a weed plant with unharvested growth!"
		end
	end
end)