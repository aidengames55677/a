ITEM.name = "Kvas"
ITEM.desc = "A bottle of alcohol."
ITEM.price = 10
ITEM.model = "models/kvas.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.hungerAmt = 4
ITEM.thirstAmt = 26
ITEM.alcrem = 10
ITEM.stackable = true
ITEM.maxStack = 5
ITEM.permit = "permit_food"
ITEM.category = "Food and Drink"

ITEM.regenStam = {
	--amount, seconds
	15, 30
}

ITEM.useSound = "interface/inv_drink_flask.ogg"
ITEM.playsound = "npc/barnacle/barnacle_gulp1.wav"
--[[
local function onUse(item)
	 
	item.player:ScreenFade(1, Color(0, 255, 0, 100), .4, 0)
end
ITEM:hook("use", onUse)
]]