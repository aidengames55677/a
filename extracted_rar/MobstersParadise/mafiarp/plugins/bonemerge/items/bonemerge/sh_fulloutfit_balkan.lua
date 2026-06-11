-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_fulloutfit_balkan.lua"

ITEM.name = "Balkan Suit"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/robbers/purple_suit.mdl",
    },
    {
        Model = "models/cultist/clothing/male/robbers/purple_pants.mdl",
    },    
    {
        Model = "models/cultist/clothing/male/aquila/blackgloves.mdl",
    },
}
ITEM.price = 30
ITEM.slot = "fulloutfit"
ITEM.RemoveBody = true
ITEM.RemoveLegs = true
ITEM.gender = "male"
ITEM.PlayersBuy = {["STEAM_0:1:57263955"] = true, ["STEAM_0:0:217293411"] = true, }
ITEM.VIP = true
ITEM.Hands = 17