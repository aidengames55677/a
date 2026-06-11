-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_pants_jeansskinny0.lua"

ITEM.name = "Skinny Jeans (Black)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/jeansskinny.mdl",
		Bodygroups = {
            {"legs", 0}
        },
    },
}
ITEM.RemoveLegs = true
ITEM.CanWearShoes = true
ITEM.gender = "male"
ITEM.slot = "pants"
ITEM.price = 80