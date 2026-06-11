ITEM.name = "Heroin Bottle"
ITEM.model = "models/props_lab/jar01a.mdl"
ITEM.category = "Drugs"
ITEM.desc = "A container filled with a pound of heroin."
ITEM.noBusiness = true
ITEM.uniqueID = "drug_heroinbrick"
ITEM.price = 200
ITEM.functions.Inject = {
	sound = "items/medshot4.wav",
	onRun = function(item)
		item.player:SetHealth(math.min(item.player:Health() - 100, 100))
		item.player:SetArmor(math.min(item.player:Armor() + 150, 100))
		item.player:ScreenFade(1, Color(24, 139, 69, 19), 300, 0)
	end
}