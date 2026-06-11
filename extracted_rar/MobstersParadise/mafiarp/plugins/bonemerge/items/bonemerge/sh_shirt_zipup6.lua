-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_zipup6.lua"

ITEM.name = "Zip Up Jacket (Beige, Blue Shirt)"
ITEM.Bonemerge = {
    {
        Model = "models/brot/diverge/civilianclothing/80s/jacketblazersuitwinter.mdl",
		Bodygroups = {
            {"body", 2},
			{"shirt", 1},
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 100