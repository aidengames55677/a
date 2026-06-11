-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_doublebreastedsuitjacket1.lua"

ITEM.name = "Double Breasted Suit Jacket (Navy, White Shirt)"
ITEM.model = "models/props_junk/cardboard_box001a.mdl"
ITEM.isPendretti = true
ITEM.Bonemerge = {
    {
        Model = "models/brot/diverge/civilianclothing/doublebreastedsuit.mdl",
		Bodygroups = {
            {"accs", 0}, {"body", 0}
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 130