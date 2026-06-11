-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_hats_norte2.lua"

ITEM.name = "Drunken's Hat"
ITEM.Bonemerge = {
    {
        Model = "models/tnb/techcom/brot/cowboyhatter.mdl",
        Bodygroups = { {"cowboyhat", 1} },
    },
}
ITEM.price = 30
ITEM.slot = "hats"
ITEM.gender = "male"
ITEM.usesEquipSlot = true
ITEM.VIP = true
ITEM.PlayersBuy = {["STEAM_0:0:419429676"] = true}