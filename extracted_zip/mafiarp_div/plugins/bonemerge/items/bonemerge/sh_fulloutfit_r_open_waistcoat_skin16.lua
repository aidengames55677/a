-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_fulloutfit_r_open_waistcoat_skin16.lua"

ITEM.name = "Open Suit & Waistcoat (Orange & Red)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/robbers/r_open_waistcoat.mdl",
		Skin = 16
    },
	{
        Model = "models/cultist/clothing/male/robbers/r_suit_pants.mdl",
		Skin = 18
    },
}
ITEM.RemoveBody = true
ITEM.RemoveLegs = true
ITEM.gender = "male"
ITEM.slot = "fulloutfit"
ITEM.price = 400
ITEM.VIP = true
ITEM.PlayersBuy = {["STEAM_0:1:23278376"] = true, ["STEAM_0:0:126213258"] = true}