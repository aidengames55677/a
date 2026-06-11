-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_pants_yogapants2_woman.lua"

ITEM.name = "Yoga Pants (Gray 1)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/female/yogapants.mdl",
		Bodygroups = {
            {"shoes", 2}
        },
    },
}
ITEM.RemoveLegs = true
ITEM.CanWearShoes = true
ITEM.gender = "female"
ITEM.slot = "pants"
ITEM.price = 90