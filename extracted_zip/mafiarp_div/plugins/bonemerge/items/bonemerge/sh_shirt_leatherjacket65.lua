-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_leatherjacket65.lua"

ITEM.name = "Leather Jacket (Black & Red, White Collar Undershirt)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/leatherjacket.mdl",
		Bodygroups = {
            {"top", 6}, {"undershirt", 5}
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 120