-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_pants_yogapants4_woman.lua"

ITEM.name = "Yoga Pants (Black)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/female/yogapants.mdl",
		Bodygroups = {
            {"shoes", 4}
        },
    },
}
ITEM.RemoveLegs = true
ITEM.CanWearShoes = true
ITEM.gender = "female"
ITEM.slot = "pants"
ITEM.price = 90