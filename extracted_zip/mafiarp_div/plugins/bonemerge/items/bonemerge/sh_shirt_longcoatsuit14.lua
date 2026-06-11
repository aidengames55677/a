-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_longcoatsuit14.lua"

ITEM.name = "Trench Coat Upper Suit (Brown, Red Waistcoat, White Shirt)"
ITEM.model = "models/props_junk/cardboard_box001a.mdl"
ITEM.isPendretti = true
ITEM.Bonemerge = {
    {
        Model = "models/brot/diverge/civilianclothing/longcoatsuit.mdl",
		Bodygroups = {
            {"accs", 1}, {"body", 4}
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 300