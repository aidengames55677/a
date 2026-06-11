-- "gamemodes\\mafiarp\\plugins\\drugs\\items\\sh_pot_empty.lua"

ITEM.name = "Empty Pot"
ITEM.model = "models/props_junk/terracotta01.mdl"
ITEM.desc = "An empty pot."
ITEM.width = 2
ITEM.height = 2
ITEM.price = 10
--ITEM.permit = "permit_fake"
ITEM.category = "Drugs"
ITEM.data = { producing2 = 0, growth = 0 }
ITEM.color = Color(50, 255, 50)

ITEM.functions.Plant = {
	name = "Plant Weed",
	icon = "icon16/cog.png",
	sound = "buttons/lightswitch2.wav",
	onRun = function(item)
		local client = item.player
		local position = client:getItemDropPos()
		local inventory = client:getChar():getInv()
		
		local seed = inventory:getFirstItemOfType("drug_weed_seed")	
		local soil = inventory:getFirstItemOfType("soil")	
			
		if (!seed or !soil) then
			client:notifyLocalized("You need soil and seeds!") return false
		end
			
		seed:remove()
		soil:remove()
			
		if(!inventory:add("drug_weed_plant")) then --if the inventory has space, put it in the inventory
			nut.item.spawn("drug_weed_plant", position) --if not, drop it on the ground
		end

		return true
	end
}

ITEM.functions.Plant2 = {
	name = "Plant Poppy",
	icon = "icon16/cog.png",
	sound = "buttons/lightswitch2.wav",
	onRun = function(item)
		local client = item.player
		local position = client:getItemDropPos()
		local inventory = client:getChar():getInv()
		
		local seed = inventory:getFirstItemOfType("drug_poppy_seed")	
		local soil = inventory:getFirstItemOfType("soil")	
			
		if (!seed or !soil) then
			client:notifyLocalized("You need soil and seeds!") return false
		end
			
		seed:remove()
		soil:remove()
			
		if(!inventory:add("drug_poppy_plant")) then --if the inventory has space, put it in the inventory
			nut.item.spawn("drug_poppy_plant", position) --if not, drop it on the ground
		end

		return true
	end
}