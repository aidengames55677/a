ITEM.name = "Meth Baggie"
ITEM.model = "models/gdrugs/meth/meth.mdl"
ITEM.category = "Drugs"
ITEM.desc = "A bag filled with a quarter pound of Meth."
ITEM.noBusiness = true
ITEM.uniqueID = "drug_meth"
ITEM.price = 200
ITEM.duration = 120
ITEM.attribBoosts = {
    ["str"] = 10,
  ["end"] = -10,
  ["stm"] = -8
}
ITEM.functions.Smoke = {
	sound = "drugs/insufflation.wav",
	onRun = function(item)
		item.player:SetHealth(math.min(item.player:Health() - 50, 100))
		item.player:SetArmor(math.min(item.player:Armor() + 70, 100))
		item.player:ScreenFade(1, Color(24, 176, 224, 230), 120, 0)
	end
}