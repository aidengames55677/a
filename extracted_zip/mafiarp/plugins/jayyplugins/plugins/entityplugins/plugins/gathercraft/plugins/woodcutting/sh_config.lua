-------------------------------------------------------------------------------------------
nut.config.add("AxeSWEP", "weapon_hl2axe", "Axe SWEP for cutting trees", nil, {category = "Gathering:\nWoodcutting"})
-------------------------------------------------------------------------------------------
nut.config.TreeEnts = {"beech_tree", "oak_tree", "pine_tree", "spruce_tree"}
-------------------------------------------------------------------------------------------
nut.config.add("AxeDMGPerHit", 10, "Axe SWEP damage", nil, {category = "Gathering:\nWoodcutting", data = {min = 1, max = 300}})
-------------------------------------------------------------------------------------------
nut.config.add("TreeRespawnDelay", 300, "How long it takes for trees to respawn", nil, {category = "Gathering:\nWoodcutting", data = {min = 1, max = 3600}})
-------------------------------------------------------------------------------------------
nut.config.TreeTable = {
    ["pine_tree"] = {
        name = "Pine Wood",
        hp = 150,
        chanceofdrop = 100,
        item = "pine"
    },
}
-------------------------------------------------------------------------------------------