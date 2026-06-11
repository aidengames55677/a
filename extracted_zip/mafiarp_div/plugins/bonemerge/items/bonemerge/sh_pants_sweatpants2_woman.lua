-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_pants_sweatpants2_woman.lua"

ITEM.name = "Sweatpants (Black)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/female/sweatpants.mdl",
		Bodygroups = {
            {"shoes", 2}
        },
    },
}
ITEM.RemoveLegs = true
ITEM.CanWearShoes = true
ITEM.gender = "female"
ITEM.slot = "pants"
ITEM.price = 50