ITEM.name = "Heroin Needle"
ITEM.model = "models/katharsmodels/syringe_out/syringe_out.mdl"
ITEM.category = "Drugs"
ITEM.desc = "A Needle Vial Filled With an Millimeter of Heroin"
ITEM.noBusiness = true
ITEM.uniqueID = "drug_heroin"
ITEM.price = 200
ITEM.duration = 60
ITEM.attribBoosts = {
    ["str"] = -15,
  ["end"] = 10,
  ["stm"] = -12
}
ITEM.functions.Inject = {
	sound = "items/medshot4.wav",
	onRun = function(item)
		item.player:SetHealth(math.min(item.player:Health() - 30, 100))
		item.player:SetArmor(math.min(item.player:Armor() + 70, 100))
		item.player:ScreenFade(1, Color(24, 139, 69, 19), 60, 0)
	end
}