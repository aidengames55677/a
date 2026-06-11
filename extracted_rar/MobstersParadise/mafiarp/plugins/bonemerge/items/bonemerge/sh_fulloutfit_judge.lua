-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_fulloutfit_judge.lua"

ITEM.name = "Judge Robes"
ITEM.Bonemerge = {
    {
        Model = "models/brot/diverge/courtrobes.mdl",
    },
}
ITEM.price = 30
ITEM.slot = "fulloutfit"
ITEM.gender = "male"
ITEM.RemoveBody = true
ITEM.RemoveLegs = true
ITEM.FactionsBuy = {[FACTION_UCS] = true}
ITEM.FactionsEquip = {[FACTION_UCS] = true}
ITEM.VIP = true
ITEM.Hands = 16