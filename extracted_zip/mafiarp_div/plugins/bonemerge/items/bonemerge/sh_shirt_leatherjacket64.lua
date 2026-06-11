-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_leatherjacket64.lua"

ITEM.name = "Leather Jacket (Black & Red, Beige Undershirt)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/leatherjacket.mdl",
		Bodygroups = {
            {"top", 6}, {"undershirt", 4}
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 120