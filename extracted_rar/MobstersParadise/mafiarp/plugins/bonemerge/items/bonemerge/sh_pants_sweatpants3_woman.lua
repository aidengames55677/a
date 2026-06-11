-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_pants_sweatpants3_woman.lua"

ITEM.name = "Sweatpants (White)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/female/sweatpants.mdl",
		Bodygroups = {
            {"shoes", 3}
        },
    },
}
ITEM.RemoveLegs = true
ITEM.CanWearShoes = true
ITEM.gender = "female"
ITEM.slot = "pants"
ITEM.price = 50