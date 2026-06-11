-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_denimjacket5.lua"

ITEM.name = "Denim Jacket (Navy, Grey Undershirt)"
ITEM.Bonemerge = {
    {
        Model = "models/brot/diverge/civilianclothing/denimjacket.mdl",
		Bodygroups = {
            {"accs", 1}, {"body", 1}
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 70