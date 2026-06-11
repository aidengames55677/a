-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_fulloutfit_r_closed_suit_skin18.lua"

ITEM.name = "Closed Suit (Orange & Red)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/robbers/r_closed_suit.mdl",
		Skin = 18
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
ITEM.price = 350
ITEM.VIP = true
ITEM.PlayersBuy = {["STEAM_0:1:23278376"] = true, ["STEAM_0:0:126213258"] = true}