-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_leatherjacket36.lua"

ITEM.name = "Leather Jacket (Beige, Gray Collar Undershirt)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/leatherjacket.mdl",
		Bodygroups = {
            {"top", 3}, {"undershirt", 6}
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 120