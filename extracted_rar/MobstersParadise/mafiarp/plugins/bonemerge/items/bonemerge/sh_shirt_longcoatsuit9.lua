-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_longcoatsuit9.lua"

ITEM.name = "Long Coat Upper Suit (Brown, Black Waistcoat, Black Shirt)"
ITEM.model = "models/props_junk/cardboard_box001a.mdl"
ITEM.isPendretti = true
ITEM.Bonemerge = {
    {
        Model = "models/brot/diverge/civilianclothing/longcoatsuit.mdl",
		Bodygroups = {
            {"accs", 2}, {"body", 2}
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 200