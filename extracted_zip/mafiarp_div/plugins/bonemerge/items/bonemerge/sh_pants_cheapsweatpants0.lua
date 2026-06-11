-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_pants_cheapsweatpants0.lua"

ITEM.name = "Sweatpants (White)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/cheapsweatpants.mdl",
		Bodygroups = {
            {"pants", 0}
        },
    },
}
ITEM.RemoveLegs = true
ITEM.CanWearShoes = true
ITEM.gender = "male"
ITEM.slot = "pants"
ITEM.price = 50