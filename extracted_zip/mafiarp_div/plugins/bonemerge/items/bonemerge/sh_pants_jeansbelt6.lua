-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_pants_jeansbelt6.lua"

ITEM.name = "Jeans (Blue 3)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/jeansbelt.mdl",
		Bodygroups = {
            {"legs", 6}
        },
    },
}
ITEM.RemoveLegs = true
ITEM.CanWearShoes = true
ITEM.gender = "male"
ITEM.slot = "pants"
ITEM.price = 80