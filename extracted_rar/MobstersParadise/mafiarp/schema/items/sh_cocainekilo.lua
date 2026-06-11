ITEM.name = "Kilo of Cocaine"
ITEM.model = "models/gdrugs/cocaine/cocaine.mdl"
ITEM.category = "Drugs"
ITEM.desc = "A large plastic string-tied bag filled with a kilo of Cocaine."
ITEM.noBusiness = true
ITEM.uniqueID = "drug_cokekilo"
ITEM.price = 200
ITEM.functions.Snort = {
	sound = "drugs/insufflation.wav",
	onRun = function(item)
		item.player:SetHealth(math.min(item.player:Health() - 100, 100))
		item.player:SetArmor(math.min(item.player:Armor() + 120, 100))
		item.player:ScreenFade(1, Color(24, 255, 250, 250), 300, 0)
	end
}