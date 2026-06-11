-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_doublebreastedsuitjacket8.lua"

ITEM.name = "Double Breasted Suit Jacket (Brown, Grey Shirt)"
ITEM.model = "models/props_junk/cardboard_box001a.mdl"
ITEM.isPendretti = true
ITEM.Bonemerge = {
    {
        Model = "models/brot/diverge/civilianclothing/doublebreastedsuit.mdl",
		Bodygroups = {
            {"accs", 1}, {"body", 2}
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 130