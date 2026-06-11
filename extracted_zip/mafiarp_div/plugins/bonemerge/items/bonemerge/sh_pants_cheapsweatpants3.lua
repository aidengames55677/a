-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_pants_cheapsweatpants3.lua"

ITEM.name = "Sweatpants (Blue)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/cheapsweatpants.mdl",
		Bodygroups = {
            {"pants", 3}
        },
    },
}
ITEM.RemoveLegs = true
ITEM.CanWearShoes = true
ITEM.gender = "male"
ITEM.slot = "pants"
ITEM.price = 50