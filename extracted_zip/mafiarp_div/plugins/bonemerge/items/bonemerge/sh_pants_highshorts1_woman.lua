-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_pants_highshorts1_woman.lua"

ITEM.name = "High-waisted Shorts (Green)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/female/highshorts.mdl",
		Bodygroups = {
            {"pants", 1}
        },
		CalculateSkintone = true,
    },
}
ITEM.RemoveLegs = true
ITEM.CanWearShoes = true
ITEM.gender = "female"
ITEM.slot = "pants"
ITEM.price = 70