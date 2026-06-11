-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_pants_jeansbelt4.lua"

ITEM.name = "Jeans (Dark Blue)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/jeansbelt.mdl",
		Bodygroups = {
            {"legs", 4}
        },
    },
}
ITEM.RemoveLegs = true
ITEM.CanWearShoes = true
ITEM.gender = "male"
ITEM.slot = "pants"
ITEM.price = 80