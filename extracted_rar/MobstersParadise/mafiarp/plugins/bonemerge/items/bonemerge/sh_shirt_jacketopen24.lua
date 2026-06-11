-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_jacketopen24.lua"

ITEM.name = "Jacket (Black, Dark Blue Undershirt)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/jacketopen.mdl",
		Bodygroups = {
            {"top", 2}, {"undershirt", 4}
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 120