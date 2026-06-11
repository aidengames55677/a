-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_pants_cheapsweatpants1.lua"

ITEM.name = "Sweatpants (Gray)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/cheapsweatpants.mdl",
		Bodygroups = {
            {"pants", 1}
        },
    },
}
ITEM.RemoveLegs = true
ITEM.CanWearShoes = true
ITEM.gender = "male"
ITEM.slot = "pants"
ITEM.price = 50