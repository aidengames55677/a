ITEM.name = "Cocaine Baggie"
ITEM.model = "models/srcocainelab/ziplockedcocaine.mdl"
ITEM.category = "Drugs"
ITEM.desc = "A ziplock bag filled with half an ounce of Cocaine."
ITEM.noBusiness = true
ITEM.uniqueID = "drug_cocaine"
ITEM.price = 200
ITEM.duration = 60
ITEM.attribBoosts = {
    ["str"] = -7,
  ["end"] = -7,
  ["stm"] = 15
}
ITEM.functions.Snort = {
	sound = "drugs/insufflation.wav",
	onRun = function(item)
		item.player:SetHealth(math.min(item.player:Health() - 25, 100))
		item.player:SetArmor(math.min(item.player:Armor() + 50, 100))
		item.player:ScreenFade(1, Color(24, 255, 250, 250), 60, 0)
	end
}