-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_fulloutfit_r_long_coat0_skin14.lua"

ITEM.name = "Trench Coat (Black, Striped Blue Suit)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/robbers/r_long_coat.mdl",
		Bodygroups = {
            {"coat", 0}
        },
		Skin = 14
    },
	{
        Model = "models/cultist/clothing/male/robbers/r_suit_pants.mdl",
		Skin = 14
    },
}
ITEM.RemoveBody = true
ITEM.RemoveLegs = true
ITEM.gender = "male"
ITEM.slot = "fulloutfit"
ITEM.price = 500