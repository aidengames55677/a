-------------------------------------------------------------------------------------------
nut.config.add("PickAxeSWEP", "weapon_hl2pickaxe", "Pickaxe SWEP.", nil, {category = "Mining"})
-------------------------------------------------------------------------------------------
nut.config.add("PickDMGPerHit", 10, "Pickaxe Damage.", nil, {category = "Mining", data = {min = 1, max = 200}})
-------------------------------------------------------------------------------------------
nut.config.add("RockRespawnDelay", 300, "Rock Spawning Delay", nil, {category = "Mining", data = {min = 1, max = 3600}})
-------------------------------------------------------------------------------------------
nut.config.rockEnts = {"rock_big", "rock_medium", "rock_small"}

nut.config.rockTable = {
    ["rock_big"] = {
        hp = 500,
        chanceofdrop = 50,
    },
    ["rock_medium"] = {
        hp = 300,
        chanceofdrop = 60,
    },
    ["rock_small"] = {
        hp = 150,
        chanceofdrop = 70,
    },
}

nut.config.oreTable = {
    ["diamond"] = {
            chance = 1,
            notificaton = "You have collected a Diamond!",
    },
    ["gold_ore"] = {
            chance = 3,
            notificaton = "You have collected some Gold Ore!",
    },
    ["copper_ore"] = {
            chance = 45,
            notificaton = "You have collected some Copper Ore!",
    },
    ["iron_ore"] = {
            chance = 45,
            notificaton = "You have collected some Iron Ore!",
    },
    ["coal_raw"] = {
            chance = 45,
            notificaton = "You have collected some Raw Coal!",
    },
}