-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_pants_sweatpants0_woman.lua"

ITEM.name = "Sweatpants (Brown)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/female/sweatpants.mdl",
		Bodygroups = {
            {"shoes", 0}
        },
    },
}
ITEM.RemoveLegs = true
ITEM.CanWearShoes = true
ITEM.gender = "female"
ITEM.slot = "pants"
ITEM.price = 50