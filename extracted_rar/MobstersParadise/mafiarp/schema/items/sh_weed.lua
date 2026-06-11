ITEM.name = "Weed Baggie"
ITEM.model = "models/gdrugs/weed/weed.mdl"
ITEM.category = "Drugs"
ITEM.desc = "A bag filled with a quarter pound of Marijuana."
ITEM.noBusiness = true
ITEM.uniqueID = "drug_weed"
ITEM.price = 200
ITEM.duration = 60
ITEM.attribBoosts = {
  ["stm"] = -5
}
ITEM.functions.Smoke = {
	sound = "drugs/insufflation.wav",
	onRun = function(item)
		item.player:SetHealth(math.min(item.player:Health() + 10, 100))
		item.player:ScreenFade(1, Color(24, 0, 100, 0), 60, 0)
	end
}