ITEM.name = "USSR 10 Ruble Coin"
ITEM.uniqueID = "coin_10"
ITEM.model = "models/money/moneta10.mdl"
ITEM.desc = "A Ten Ruble Coin."
ITEM.width = 1
ITEM.height = 1
ITEM.flag = "v"
ITEM.price = 10
ITEM.category = "Currency"
ITEM.color = Color(70, 120, 70)

ITEM.value = 10

ITEM.functions.Collect = {
	name = "Collect",
	icon = "icon16/coins.png",
	sound = "ambient/materials/cupdrop.wav",
	onRun = function(item)
		local client = item.player
		local char = client:getChar()

		client:notify("You have received "..item.value.." scrap coins.")
		char:giveMoney(item.value)
	end
}

if (CLIENT) then
	function ITEM:paintOver(item, w, h)
		draw.SimpleText(item.value, "DermaDefault", w - 12, h - 14, Color(125,125,125), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black)
	end
end