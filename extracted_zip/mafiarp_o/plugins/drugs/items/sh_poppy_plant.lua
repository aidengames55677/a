-- "gamemodes\\1942rp\\plugins\\drugs\\items\\sh_poppy_plant.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ITEM.name = "Poppy Plant"
ITEM.uniqueID = "drug_poppy_plant"
ITEM.model = "models/props_junk/terracotta01.mdl"
ITEM.desc = "A poppy plant."
ITEM.width = 2
ITEM.height = 2
ITEM.flag = "v"
ITEM.price = 500
ITEM.category = "Drugs"
ITEM.color = Color(50, 255, 50)
ITEM.flag = "9"

ITEM.functions.fertilize = {
	icon = "icon16/box.png",
	sound = "npc/barnacle/barnacle_tongue_pull1.wav",
	onRun = function(item)
		local client = item.player
		local char = client:getChar()
		local position = client:getItemDropPos()
		local inventory = char:getInv()
		
		if (!IsValid(item.entity)) then
			client:notify("You can't do that while this item is in your inventory")
			return false
		end
		
		local fertilized = inventory:getFirstItemOfType("fertilizer_bucket")

		if(fertilized) then
			--local container = water.container
			fertilized:remove()
			--inventory:add(container)
			item:setData("producing2", CurTime())
			timer.Simple(450,--50, --7.5 minutes 
				function()
					if (item != nil) then
						item:setData("producing2", nil)
						item:setData("growth", item:getData("growth", 0) + 5)
						client:notify("Your poppy plant has grown.")
					end
				end
			)
		else
			client:notifyLocalized("You don't have any water!") return false
		end
		return false
	end,
	onCanRun = function(item)		
		local growth = item:getData("growth", 0)
		
		if (growth == 10) then
			return false
		end
		
		if(item:getData("producing2") != nil) then
			local endTime = item:getData("producing2", 0) + 450
			if (item:getData("producing2", 0) > CurTime() or CurTime() > endTime) then
				return true
			end
			
			return false
		end
		
		return true
	end
}
ITEM.functions.take = {
	tip = "takeTip",
	icon = "icon16/box.png",
	onRun = function(item)
		local status, result = item.player:getChar():getInv():add(item.id)

		if (!status) then
			item.player:notify(result)

			return false
		else
			if (item.data) then -- I don't like it but, meh...
				for k, v in pairs(item.data) do
					item:setData(k, v)
				end
			end
		end
	end,
	onCanRun = function(item)
		return IsValid(item.entity) and item:getData("producing2", 0) == 0
	end
}

ITEM.functions.Harvest = { 
	icon = "icon16/box.png",
	sound = "npc/barnacle/barnacle_tongue_pull1.wav",
	onRun = function(item)
		local client = item.player
		local char = client:getChar()
		local position = client:getItemDropPos()
		local inventory = char:getInv()
		
		if(item:getData("growth", 0) == 10) then
			if(IsValid(item.entity) || !inventory:add("drug_poppy_seed")) then --if the inventory has space, put it in the inventory
				nut.item.spawn("drug_poppy_seed", position) --if not, drop it on the ground
			end		
		end
		
		if(IsValid(item.entity) || !inventory:add("drug_poppy_seed")) then --if the inventory has space, put it in the inventory
			nut.item.spawn("drug_poppy_seed", position) --if not, drop it on the ground
		end
		
		item:setData("growth", item:getData("growth", 0) - 5)
		
		return false
	end,
	onCanRun = function(item)
		local growth = item:getData("growth", 0)
		
		if (growth >= 5) then --want to have at least 50% growth to be able to cut plant.
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
		desc = desc .. "\nThe plant has been watered recently."
	end	
	
	if(self:getData("growth") != nil) then
		local growth = self:getData("growth", 0)
		local growthMsg = "\nThe plant is " .. growth * 10 .. " percent grown." 

		desc = desc .. growthMsg
	end
	
	return Format(desc)
end

