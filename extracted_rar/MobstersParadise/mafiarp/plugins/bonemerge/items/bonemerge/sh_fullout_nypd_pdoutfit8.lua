-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_fullout_nypd_pdoutfit8.lua"

ITEM.name = "NYPD Uniform: ESU Long Sleeve - Sergeant"
ITEM.Bonemerge = {
	{
        Model = "models/brot/diverge/nypd/nypdcopshirt1_darkblue.mdl",
        Bodygroups = { {"rank", 2} },
    },
	{
        Model = "models/nypd/diverge/copcargopants_darkblue.mdl",
    },	
	{
        Model = "models/nypd/diverge/dutybelt1.mdl",
    },	
    {
        Model = "models/nypd/diverge/nypdlightvest.mdl",
    },
}
ITEM.RemoveBody = true
ITEM.RemoveLegs = true
ITEM.gender = "male"
ITEM.slot = "fulloutfit"
ITEM.price = 350
ITEM.isPD = true
ITEM.NoClothingVendor = true
ITEM.Hands = 16