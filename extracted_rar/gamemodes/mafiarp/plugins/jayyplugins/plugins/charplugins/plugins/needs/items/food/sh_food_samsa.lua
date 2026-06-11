ITEM.name = "Samsa"
ITEM.desc = "Samsa."
ITEM.price = 50
ITEM.model = "models/samsa.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.hungerAmt = 35
ITEM.stackable = true
ITEM.maxStack = 5
ITEM.permit = "permit_food"
ITEM.category = "Food and Drink"

ITEM.regenStam = {
	--amount, seconds
	35, 60
}

ITEM.useSound = "interface/inv_eat_mutant_food.ogg"

local function onUse(item)
	--item.player:EmitSound("items/medshot4.wav", 80, 110)
	--item.player:ScreenFade(1, Color(0, 255, 0, 100), .4, 0)
end
ITEM:hook("use", onUse)
