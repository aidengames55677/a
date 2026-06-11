-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_pants_sweatpants1_woman.lua"

ITEM.name = "Sweatpants (Camo)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/female/sweatpants.mdl",
		Bodygroups = {
            {"shoes", 1}
        },
    },
}
ITEM.RemoveLegs = true
ITEM.CanWearShoes = true
ITEM.gender = "female"
ITEM.slot = "pants"
ITEM.price = 50