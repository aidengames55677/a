-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_pants_suitpants21.lua"

ITEM.name = "Suit Pants (Grey)"
ITEM.model = "models/props_junk/cardboard_box001a.mdl"
ITEM.isPendretti = true
ITEM.Bonemerge = {
    {
        Model = "models/brot/diverge/civilianclothing/80s/secretarysuitpants.mdl",
		Bodygroups = {
            {"lower", 1}
        },
    },
}
ITEM.RemoveLegs = true
ITEM.CanWearShoes = false
ITEM.gender = "male"
ITEM.slot = "pants"
ITEM.price = 50