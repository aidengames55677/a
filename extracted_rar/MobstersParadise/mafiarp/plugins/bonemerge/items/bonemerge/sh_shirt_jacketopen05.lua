-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_shirt_jacketopen05.lua"

ITEM.name = "Jacket (White, Black Undershirt)"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/jacketopen.mdl",
		Bodygroups = {
            {"top", 0}, {"undershirt", 5}
        },
    },
}
ITEM.RemoveBody = true
ITEM.gender = "male"
ITEM.slot = "shirt"
ITEM.price = 120