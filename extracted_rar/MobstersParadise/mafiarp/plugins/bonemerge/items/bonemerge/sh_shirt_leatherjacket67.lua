-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_leatherjacket67.lua"

ITEM.name = "Leather Jacket (Black & Red, Blue Collar Undershirt)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/leatherjacket.mdl",
		Bodygroups = {
            {"top", 6}, {"undershirt", 7}
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 120