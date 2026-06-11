-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_pants_loosejeans2_woman.lua"

ITEM.name = "Loose Jeans (Gray)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/female/loosejeans.mdl",
		Bodygroups = {
            {"pants", 2}
        },
    },
}
ITEM.RemoveLegs = true
ITEM.CanWearShoes = true
ITEM.gender = "female"
ITEM.slot = "pants"
ITEM.price = 80