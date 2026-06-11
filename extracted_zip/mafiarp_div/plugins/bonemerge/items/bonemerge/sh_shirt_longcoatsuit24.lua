-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_longcoatsuit24.lua"

ITEM.name = "Long Coat Upper Suit (White, Black Waistcoat, Black Shirt)"
ITEM.model = "models/props_junk/cardboard_box001a.mdl"
ITEM.isPendretti = true
ITEM.Bonemerge = {
    {
        Model = "models/brot/diverge/civilianclothing/longcoatsuit.mdl",
		Bodygroups = {
            {"accs", 2}, {"body", 7}
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 300