ITEM.name = "Vodka"
ITEM.desc = "An bottle of vodka."
ITEM.price = 50
ITEM.model = "models/vodka.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.uses = 3
ITEM.hungerAmt = 3
ITEM.thirstAmt = 23
ITEM.alcrem = 50
ITEM.stackable = true
ITEM.maxStack = 5
ITEM.permit = "permit_food"
ITEM.category = "Food and Drink"

ITEM.regenStam = {
	--amount, seconds
	40, 30
}

ITEM.useSound = "interface/inv_drink_flask.ogg"
ITEM.playsound = "npc/barnacle/barnacle_gulp1.wav"

--[[
local function onUse(item)
	 
	--item.player:EmitSound("items/medshot4.wav", 80, 110)
	item.player:ScreenFade(1, Color(0, 255, 0, 100), .4, 0)
end
ITEM:hook("use", onUse)
]]
