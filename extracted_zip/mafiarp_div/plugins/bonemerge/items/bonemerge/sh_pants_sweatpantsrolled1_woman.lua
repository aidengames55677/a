-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_pants_sweatpantsrolled1_woman.lua"

ITEM.name = "Rolled-up Sweatpants (Camo)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/female/sweatpantsrolled.mdl",
		Bodygroups = {
            {"shoes", 1}
        },
		CalculateSkintone = true,
    },
}
ITEM.RemoveLegs = true
ITEM.CanWearShoes = true
ITEM.gender = "female"
ITEM.slot = "pants"
ITEM.price = 50