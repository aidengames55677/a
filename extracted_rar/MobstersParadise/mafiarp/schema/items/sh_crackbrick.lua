ITEM.name = "Crack Brick"
ITEM.model = "models/srcocainelab/cocainebrick.mdl"
ITEM.category = "Drugs"
ITEM.desc = "A brick filled with a pound of Crack Cocaine paste."
ITEM.noBusiness = true
ITEM.uniqueID = "drug_crackbrick"
ITEM.price = 200
ITEM.functions.Smoke = {
	sound = "drugs/insufflation.wav",
	onRun = function(item)
		item.player:SetHealth(math.min(item.player:Health() - 100, 100))
		item.player:SetArmor(math.min(item.player:Armor() + 120, 100))
		item.player:ScreenFade(1, Color(24, 255, 250, 250), 500, 0)
	end
}