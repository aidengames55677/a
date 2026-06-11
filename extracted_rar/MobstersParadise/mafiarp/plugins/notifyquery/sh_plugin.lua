-- "gamemodes\\mafiarp\\plugins\\notifyquery\\sh_plugin.lua"

local PLUGIN = PLUGIN
PLUGIN.name = "Notify Query"
PLUGIN.author = "Robert Bearson"
PLUGIN.desc = "Alternative to Derma Query that doesn't lock up your screen."

nut.util.include("sv_plugin.lua")
nut.util.include("cl_plugin.lua")