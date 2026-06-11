-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_pants_cheapsweatpants2.lua"

ITEM.name = "Sweatpants (Black)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/cheapsweatpants.mdl",
		Bodygroups = {
            {"pants", 2}
        },
    },
}
ITEM.RemoveLegs = true
ITEM.CanWearShoes = true
ITEM.gender = "male"
ITEM.slot = "pants"
ITEM.price = 50