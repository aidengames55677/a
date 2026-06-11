-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_pants_suitpants5.lua"

ITEM.name = "Suit Pants (Grey 2)"
ITEM.model = "models/props_junk/cardboard_box001a.mdl"
ITEM.isPendretti = true
ITEM.Bonemerge = {
    {
        Model = "models/brot/diverge/civilianclothing/80s/businessvestsuitnotiepants.mdl",
		Bodygroups = {
            {"lower", 0}
        },
    },
}
ITEM.RemoveLegs = true
ITEM.CanWearShoes = false
ITEM.gender = "male"
ITEM.slot = "pants"
ITEM.price = 50