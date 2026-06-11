-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_leatherjacket42.lua"

ITEM.name = "Leather Jacket (Black & Blue, Black Undershirt)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/leatherjacket.mdl",
		Bodygroups = {
            {"top", 4}, {"undershirt", 2}
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 120