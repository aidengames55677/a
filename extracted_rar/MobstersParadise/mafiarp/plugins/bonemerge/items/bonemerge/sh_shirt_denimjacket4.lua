-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_denimjacket4.lua"

ITEM.name = "Denim Jacket (Navy, White Undershirt)"
ITEM.Bonemerge = {
    {
        Model = "models/brot/diverge/civilianclothing/denimjacket.mdl",
		Bodygroups = {
            {"accs", 0}, {"body", 1}
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 70