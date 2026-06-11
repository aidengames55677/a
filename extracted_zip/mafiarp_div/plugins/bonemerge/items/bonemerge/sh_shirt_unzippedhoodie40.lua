-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_unzippedhoodie40.lua"

ITEM.name = "Hoodie (Dark Blue)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/unzippedhoodie.mdl",
		Bodygroups = {
            {"top", 4}, {"undershirt", 0}
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 100