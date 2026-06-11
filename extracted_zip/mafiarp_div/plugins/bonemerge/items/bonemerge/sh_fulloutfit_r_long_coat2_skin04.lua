-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_fulloutfit_r_long_coat2_skin04.lua"

ITEM.name = "Trench Coat (Blue, Gray & White Suit)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/robbers/r_long_coat.mdl",
		Bodygroups = {
            {"coat", 2}
        },
		Skin = 4
    },
	{
        Model = "models/cultist/clothing/male/robbers/r_suit_pants.mdl",
		Skin = 4
    },
}
ITEM.RemoveBody = true
ITEM.RemoveLegs = true
ITEM.gender = "male"
ITEM.slot = "fulloutfit"
ITEM.price = 500