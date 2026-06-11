-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_fullout_nypd_pdoutfit_command3.lua"

ITEM.name = "NYPD Uniform - Deputy Chief Inspector"
ITEM.Bonemerge = {
    {
        Model = "models/brot/diverge/nypd/nypd_chief.mdl ",
		Bodygroups = { {"rank", 2} },
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