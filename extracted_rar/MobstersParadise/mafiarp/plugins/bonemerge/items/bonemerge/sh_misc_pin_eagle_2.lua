-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_misc_pin_eagle_2.lua"

ITEM.name = "Hawk Pin (Waistcoat)"
ITEM.Bonemerge = {
    {
        Model = "models/void/faction_pin/faction_pin_eaglewaistcoat.mdl",
    },
}
ITEM.gender = "male"
ITEM.slot = "vest"
ITEM.usesEquipSlot = false
ITEM.price = 50
ITEM.FactionsBuy = {[FACTION_GAMBINO] = true}
ITEM.FactionsEquip = {[FACTION_GAMBINO] = true}
ITEM.VIP = true