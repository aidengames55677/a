-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_fulloutfit_76561198404420361.lua"

ITEM.name = "Diamond Syndicate Suit"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/clothing/male/aquila/uksuitcoat.mdl",
    },
}
ITEM.price = 30
ITEM.slot = "fulloutfit"
ITEM.gender = "male"
ITEM.RemoveBody = true
ITEM.RemoveLegs = true
ITEM.PlayersBuy = {["STEAM_0:1:627390486"] = true}
ITEM.FactionsEquip = { [FACTION_SYNDICATE] = true, }
ITEM.VIP = true
ITEM.Hands = 17