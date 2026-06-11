-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_pants_yogapants1_woman.lua"

ITEM.name = "Yoga Pants (Red)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/female/yogapants.mdl",
		Bodygroups = {
            {"shoes", 1}
        },
    },
}
ITEM.RemoveLegs = true
ITEM.CanWearShoes = true
ITEM.gender = "female"
ITEM.slot = "pants"
ITEM.price = 90