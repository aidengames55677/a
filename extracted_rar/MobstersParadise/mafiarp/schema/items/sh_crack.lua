ITEM.name = "Crack Baggie"
ITEM.model = "models/jellik/cocaine.mdl"
ITEM.category = "Drugs"
ITEM.desc = "A ziplock bag filled with a gram of Crack."
ITEM.noBusiness = true
ITEM.uniqueID = "drug_crack"
ITEM.price = 200
ITEM.duration = 100
ITEM.attribBoosts = {
  ["str"] = 10,
  ["end"] = 10,
  ["stm"] = -15
}
ITEM.functions.Smoke = {
	sound = "drugs/insufflation.wav",
	onRun = function(item)
		item.player:SetHealth(math.min(item.player:Health() - 25, 100))
		item.player:SetArmor(math.min(item.player:Armor() + 50, 100))
		item.player:ScreenFade(1, Color(24, 255, 250, 250), 100, 0)
	end
}