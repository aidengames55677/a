ITEM.name = "Bread loaf"
ITEM.desc = "A loaf of bread from outside the Zone."
ITEM.price = 10
ITEM.model = "models/bread.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.hungerAmt = 25
ITEM.thirstAmt = -5
ITEM.stackable = true
ITEM.maxStack = 5
ITEM.permit = "permit_food"
ITEM.category = "Food and Drink"

ITEM.useSound = "interface/inv_eat_paperwrap.ogg"

local function onUse(item)
	--item.player:EmitSound("items/medshot4.wav", 80, 110)
	--item.player:ScreenFade(1, Color(0, 255, 0, 100), .4, 0)
end
ITEM:hook("use", onUse)
