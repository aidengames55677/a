-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_zipup12.lua"

ITEM.name = "Zip Up Jacket (Black, Black Collared Shirt)"
ITEM.Bonemerge = {
    {
        Model = "models/brot/diverge/civilianclothing/80s/jacketblazersuitwinter.mdl",
		Bodygroups = {
            {"body", 0},
			{"shirt", 3},
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 100