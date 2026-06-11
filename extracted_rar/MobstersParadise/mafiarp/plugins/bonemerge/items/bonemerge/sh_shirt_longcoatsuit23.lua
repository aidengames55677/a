-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_longcoatsuit23.lua"

ITEM.name = "Long Coat Upper Suit (White, Red Waistcoat, White Shirt)"
ITEM.model = "models/props_junk/cardboard_box001a.mdl"
ITEM.isPendretti = true
ITEM.Bonemerge = {
    {
        Model = "models/brot/diverge/civilianclothing/longcoatsuit.mdl",
		Bodygroups = {
            {"accs", 1}, {"body", 7}
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 300