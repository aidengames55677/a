-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_pants_sweatpants4_woman.lua"

ITEM.name = "Sweatpants (Gray)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/female/sweatpants.mdl",
		Bodygroups = {
            {"shoes", 4}
        },
    },
}
ITEM.RemoveLegs = true
ITEM.CanWearShoes = true
ITEM.gender = "female"
ITEM.slot = "pants"
ITEM.price = 50