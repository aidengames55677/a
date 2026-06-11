-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_opensuit3.lua"

ITEM.name = "Open Suit Jacket (Grey, Black Shirt)"
ITEM.model = "models/props_junk/cardboard_box001a.mdl"
ITEM.isPendretti = true
ITEM.Bonemerge = {
    {
        Model = "models/brot/diverge/civilianclothing/openbuttonedsuit.mdl",
		Bodygroups = {
            {"accs", 2}, {"body", 0}
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 150