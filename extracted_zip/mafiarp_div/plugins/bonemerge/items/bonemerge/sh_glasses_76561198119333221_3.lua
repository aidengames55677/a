-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_glasses_76561198119333221_3.lua"

ITEM.name = "Square Frames"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/aquila/cartierglasses.mdl",
		Bodygroups = { {"gloves2", 2} },
    },
}
ITEM.price = 100
ITEM.slot = "glasses"
ITEM.gender = "male"
ITEM.RemoveBody = false
ITEM.RemoveLegs = false
ITEM.PlayersBuy = {["STEAM_0:1:79533746"] = true}
ITEM.VIP = true