-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_pants_highshorts0_woman.lua"

ITEM.name = "High-waisted Shorts (Gray)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/female/highshorts.mdl",
		Bodygroups = {
            {"pants", 0}
        },
		CalculateSkintone = true,
    },
}
ITEM.RemoveLegs = true
ITEM.CanWearShoes = true
ITEM.gender = "female"
ITEM.slot = "pants"
ITEM.price = 70