-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_unzippedhoodie60.lua"

ITEM.name = "Hoodie (Brown)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/unzippedhoodie.mdl",
		Bodygroups = {
            {"top", 6}, {"undershirt", 0}
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 100