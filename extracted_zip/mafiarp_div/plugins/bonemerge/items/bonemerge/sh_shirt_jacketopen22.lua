-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_jacketopen22.lua"

ITEM.name = "Jacket (Black, White Undershirt)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/jacketopen.mdl",
		Bodygroups = {
            {"top", 2}, {"undershirt", 2}
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 120