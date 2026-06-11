-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_longcoatsuit10.lua"

ITEM.name = "Trench Coat Upper Suit (Black, Black Waistcoat, White Shirt)"
ITEM.model = "models/props_junk/cardboard_box001a.mdl"
ITEM.isPendretti = true
ITEM.Bonemerge = {
    {
        Model = "models/brot/diverge/civilianclothing/longcoatsuit.mdl",
		Bodygroups = {
            {"accs", 0}, {"body", 3}
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 300