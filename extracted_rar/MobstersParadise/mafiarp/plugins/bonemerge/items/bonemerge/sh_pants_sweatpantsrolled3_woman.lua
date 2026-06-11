-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_pants_sweatpantsrolled3_woman.lua"

ITEM.name = "Rolled-up Sweatpants (White)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/female/sweatpantsrolled.mdl",
		Bodygroups = {
            {"shoes", 3}
        },
		CalculateSkintone = true,
    },
}
ITEM.RemoveLegs = true
ITEM.CanWearShoes = true
ITEM.gender = "female"
ITEM.slot = "pants"
ITEM.price = 50