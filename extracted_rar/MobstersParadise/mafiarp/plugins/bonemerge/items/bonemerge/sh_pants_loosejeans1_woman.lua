-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_pants_loosejeans1_woman.lua"

ITEM.name = "Loose Jeans (Ripped)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/female/loosejeans.mdl",
		Bodygroups = {
            {"pants", 1}
        },
    },
}
ITEM.RemoveLegs = true
ITEM.CanWearShoes = true
ITEM.gender = "female"
ITEM.slot = "pants"
ITEM.price = 80