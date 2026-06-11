PLUGIN.name = "Anti-AFK"
PLUGIN.author = "JayyKashtaCodes"
PLUGIN.desc = "kicks afk"

nut.util.include("cl_plugin.lua")
nut.util.include("sv_plugin.lua")

nut.config.add("antiafk", true, "Whether Anti AFK is active.", nil, {
    category = "AntiAFK",
})

nut.config.add("antiafk_maxPlayers", 40, "How many players before kick script activates.", nil, {
    category = "AntiAFK",
    data = {min = 10, max = 128}
})

nut.config.add("antiafk_afkTime", 60, "How long before kick.", nil, {
    category = "AntiAFK",
    data = {min = 10, max = 10000}
})
