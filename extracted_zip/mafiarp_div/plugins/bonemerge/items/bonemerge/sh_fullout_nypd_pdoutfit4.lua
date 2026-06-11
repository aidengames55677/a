-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_fullout_nypd_pdoutfit4.lua"

ITEM.name = "NYPD Uniform: Long Sleeve - Sergeant"
ITEM.Bonemerge = {
	{
        Model = "models/brot/diverge/nypd/nypdcopshirt1_skyblue.mdl",
        Bodygroups = { {"rank", 2} },
    },
	{
        Model = "models/nypd/diverge/coppants_darkblue.mdl",
    },	
	{
        Model = "models/brot/diverge/nypd/nypdcopbelt.mdl",
    },	
    {
        Model = "models/nypd/diverge/copbadge.mdl",
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