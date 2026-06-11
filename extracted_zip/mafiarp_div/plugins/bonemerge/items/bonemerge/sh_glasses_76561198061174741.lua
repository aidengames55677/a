-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_glasses_76561198061174741.lua"

-- Owner: 76561198061174741
ITEM.name  = "Gambino Glasses"
ITEM.Bonemerge = {
    {
        Model = "models/diverge/clothing/male/anzati/soulthedwarf_glasses.mdl",
    },
}
ITEM.price = 30
ITEM.slot = "glasses"
ITEM.gender = "male"
ITEM.FactionsBuy = {
    [FACTION_GAMBINO] = true,
}
ITEM.FactionsEquip = {
    [FACTION_GAMBINO] = true,
}
ITEM.VIP = true
