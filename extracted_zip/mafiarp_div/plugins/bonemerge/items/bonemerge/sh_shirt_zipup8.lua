-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_zipup8.lua"

ITEM.name = "Zip Up Jacket (Grey, White Collared Shirt)"
ITEM.Bonemerge = {
    {
        Model = "models/brot/diverge/civilianclothing/80s/jacketblazersuitwinter.mdl",
		Bodygroups = {
            {"body", 1},
			{"shirt", 2},
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 100