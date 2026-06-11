-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_fulloutfit_r_open_waistcoat_skin14.lua"

ITEM.name = "Open Suit & Waistcoat (Beige & Pink)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/robbers/r_open_waistcoat.mdl",
		Skin = 14
    },
	{
        Model = "models/cultist/clothing/male/robbers/r_suit_pants.mdl",
		Skin = 16
    },
}
ITEM.RemoveBody = true
ITEM.RemoveLegs = true
ITEM.gender = "male"
ITEM.slot = "fulloutfit"
ITEM.price = 400
ITEM.VIP = true
ITEM.PlayersBuy = {["STEAM_0:1:23278376"] = true, ["STEAM_0:0:126213258"] = true}