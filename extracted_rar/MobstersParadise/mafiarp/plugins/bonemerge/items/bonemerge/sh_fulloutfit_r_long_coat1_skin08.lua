-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_fulloutfit_r_long_coat1_skin08.lua"

ITEM.name = "Trench Coat (Brown, Beige & White Suit)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/robbers/r_long_coat.mdl",
		Bodygroups = {
            {"coat", 1}
        },
		Skin = 8
    },
	{
        Model = "models/cultist/clothing/male/robbers/r_suit_pants.mdl",
		Skin = 8
    },
}
ITEM.RemoveBody = true
ITEM.RemoveLegs = true
ITEM.gender = "male"
ITEM.slot = "fulloutfit"
ITEM.price = 500