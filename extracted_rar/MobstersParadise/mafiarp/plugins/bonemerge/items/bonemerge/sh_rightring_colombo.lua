-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_rightring_colombo.lua"

ITEM.name = "Colombo Ring"
ITEM.Bonemerge = {
    {
        Model = "models/cultist/arm_set/ring_arms.mdl",
    },
}
ITEM.price = 30
ITEM.slot = "rightring"
ITEM.gender = "male"
ITEM.PlayersBuy = {["STEAM_0:1:40519011"] = true, ["STEAM_0:1:562177687"] = true, ["STEAM_0:0:175606500"] = true, ["STEAM_0:0:79563902"] = true}
ITEM.FactionsEquip = {[FACTION_4KT] = true}
ITEM.VIP = true