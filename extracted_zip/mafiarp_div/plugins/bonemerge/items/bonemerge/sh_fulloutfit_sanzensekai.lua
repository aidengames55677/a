-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_fulloutfit_sanzensekai.lua"

-- 76561198119333221
ITEM.name = "Sanzensekai Suit"
ITEM.Bonemerge = {
	{
		Model = "models/player/ernie/rho/foi/sanzensekai.mdl",
	},
}
ITEM.RemoveBody = true
ITEM.RemoveLegs = true
ITEM.slot = "fulloutfit"
ITEM.price = 30
ITEM.VIP = true
ITEM.PlayersBuy = {["STEAM_0:1:79533746"] = true,}
ITEM.FactionsEquip = {[FACTION_SANZENSEKAI] = true}