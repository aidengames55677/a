-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_jacketopen23.lua"

ITEM.name = "Jacket (Black, Gray Undershirt)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/jacketopen.mdl",
		Bodygroups = {
            {"top", 2}, {"undershirt", 3}
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 120