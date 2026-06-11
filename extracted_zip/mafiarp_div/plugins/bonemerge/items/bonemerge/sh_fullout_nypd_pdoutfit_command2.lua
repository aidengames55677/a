-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_fullout_nypd_pdoutfit_command2.lua"

ITEM.name = "NYPD Uniform - Captain"
ITEM.Bonemerge = {
    {
        Model = "models/brot/diverge/nypd/nypd_chief.mdl ",
		Bodygroups = { {"rank", 1} },
    },
}
ITEM.RemoveBody = true
ITEM.RemoveLegs = true
ITEM.gender = "male"
ITEM.slot = "fulloutfit"
ITEM.price = 350
ITEM.isPD = true
ITEM.NoClothingVendor = true
ITEM.Hands = 2