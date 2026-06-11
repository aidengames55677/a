ITEM.name = "Weed Brick"
ITEM.model = "models/gonzo/weedb/bag/brick.mdl"
ITEM.category = "Drugs"
ITEM.desc = "A brick filled with a pound of Marijuana."
ITEM.noBusiness = true
ITEM.uniqueID = "drug_weedbrick"
ITEM.price = 200
ITEM.functions.Smoke = {
	sound = "drugs/insufflation.wav",
	onRun = function(item)
		item.player:SetHealth(math.min(item.player:Health() + 60, 100))
		item.player:ScreenFade(1, Color(24, 0, 100, 0), 300, 0)
	end
}