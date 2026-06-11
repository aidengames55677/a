-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_zipup10.lua"

ITEM.name = "Zip Up Jacket (Beige, Black Collared Shirt)"
ITEM.Bonemerge = {
    {
        Model = "models/brot/diverge/civilianclothing/80s/jacketblazersuitwinter.mdl",
		Bodygroups = {
            {"body", 2},
			{"shirt", 3},
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 100