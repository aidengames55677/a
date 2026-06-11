-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_denimjacket1.lua"

ITEM.name = "Denim Jacket (Blue, White Undershirt)"
ITEM.Bonemerge = {
    {
        Model = "models/brot/diverge/civilianclothing/denimjacket.mdl",
		Bodygroups = {
            {"accs", 0}, {"body", 0}
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 70