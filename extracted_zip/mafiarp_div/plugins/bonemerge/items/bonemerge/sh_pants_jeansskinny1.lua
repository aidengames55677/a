-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_pants_jeansskinny1.lua"

ITEM.name = "Skinny Jeans (Dark Blue)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/jeansskinny.mdl",
		Bodygroups = {
            {"legs", 1}
        },
    },
}
ITEM.RemoveLegs = true
ITEM.CanWearShoes = true
ITEM.gender = "male"
ITEM.slot = "pants"
ITEM.price = 80