-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_unzippedhoodie51.lua"

ITEM.name = "Hoodie (Red, Gray Undershirt)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/unzippedhoodie.mdl",
		Bodygroups = {
            {"top", 5}, {"undershirt", 1}
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 100