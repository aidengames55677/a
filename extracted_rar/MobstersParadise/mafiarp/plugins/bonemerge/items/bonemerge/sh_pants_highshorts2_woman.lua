-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_pants_highshorts2_woman.lua"

ITEM.name = "High-waisted Shorts (White)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/female/highshorts.mdl",
		Bodygroups = {
            {"pants", 2}
        },
		CalculateSkintone = true,
    },
}
ITEM.RemoveLegs = true
ITEM.CanWearShoes = true
ITEM.gender = "female"
ITEM.slot = "pants"
ITEM.price = 70