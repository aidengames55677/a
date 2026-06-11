-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_unzippedhoodie31.lua"

ITEM.name = "Hoodie (Blue, Gray Undershirt)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/unzippedhoodie.mdl",
		Bodygroups = {
            {"top", 3}, {"undershirt", 1}
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 100