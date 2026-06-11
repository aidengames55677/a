-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_fullout_nypd_pdoutfit_command4.lua"

ITEM.name = "NYPD Uniform - Chief Inspector"
ITEM.Bonemerge = {
    {
        Model = "models/brot/diverge/nypd/nypd_chief.mdl ",
		Bodygroups = { {"rank", 3} },
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