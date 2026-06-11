-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_pants_jeansbelt2.lua"

ITEM.name = "Jeans (Blue 2)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/jeansbelt.mdl",
		Bodygroups = {
            {"legs", 2}
        },
    },
}
ITEM.RemoveLegs = true
ITEM.CanWearShoes = true
ITEM.gender = "male"
ITEM.slot = "pants"
ITEM.price = 80