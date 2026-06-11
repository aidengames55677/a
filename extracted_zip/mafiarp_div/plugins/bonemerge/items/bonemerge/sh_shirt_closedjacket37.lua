-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_closedjacket37.lua"

ITEM.name = "Closed Suit Jacket (Grey, Black Tie)"
ITEM.model = "models/props_junk/cardboard_box001a.mdl"
ITEM.isPendretti = true
ITEM.Bonemerge = {
    {
        Model = "models/brot/diverge/civilianclothing/80s/secretarysuittop.mdl",
		Bodygroups = {
            {"body", 1},
            {"shirt", 2},
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 285