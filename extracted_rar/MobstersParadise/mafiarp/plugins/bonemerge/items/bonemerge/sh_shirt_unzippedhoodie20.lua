-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_unzippedhoodie20.lua"

ITEM.name = "Hoodie (Black)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/unzippedhoodie.mdl",
		Bodygroups = {
            {"top", 2}, {"undershirt", 0}
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 100