-- "gamemodes\\mafiarp\\plugins\\drugs\\sh_plugin.lua"

if EventServer then return false end
PLUGIN.name = "Drugs"
PLUGIN.author = "Chancer"
PLUGIN.desc = "Simple drugs."

nut.util.include("sh_drugeffects.lua")
nut.util.include("sv_plugin.lua", "server")
