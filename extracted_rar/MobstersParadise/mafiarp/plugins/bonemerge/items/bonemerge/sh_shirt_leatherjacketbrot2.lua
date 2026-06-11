-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_leatherjacketbrot2.lua"

ITEM.name = "Leather Jacket (Black, Grey Undershirt)"
ITEM.Bonemerge = {
    {
        Model = "models/brot/diverge/civilianclothing/greaserzipperdouble.mdl",
		Bodygroups = {
            {"accs", 1}, {"body", 0}
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 120