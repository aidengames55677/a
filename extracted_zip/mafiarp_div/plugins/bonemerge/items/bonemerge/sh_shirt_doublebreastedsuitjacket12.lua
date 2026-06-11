-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_doublebreastedsuitjacket12.lua"

ITEM.name = "Double Breasted Suit Jacket (Red Pinstripe, Black Shirt)"
ITEM.model = "models/props_junk/cardboard_box001a.mdl"
ITEM.isPendretti = true
ITEM.Bonemerge = {
    {
        Model = "models/brot/diverge/civilianclothing/doublebreastedsuit.mdl",
		Bodygroups = {
            {"accs", 2}, {"body", 3}
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 130