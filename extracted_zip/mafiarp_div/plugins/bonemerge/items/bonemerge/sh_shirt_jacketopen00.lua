-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_jacketopen00.lua"

ITEM.name = "Jacket (White, V-neck Undershirt)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/jacketopen.mdl",
		Bodygroups = {
            {"top", 0}, {"undershirt", 0}
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 120