-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_denimjacket8.lua"

ITEM.name = "Denim Jacket (Turquoise, Grey Undershirt)"
ITEM.Bonemerge = {
    {
        Model = "models/brot/diverge/civilianclothing/denimjacket.mdl",
		Bodygroups = {
            {"accs", 1}, {"body", 2}
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 70