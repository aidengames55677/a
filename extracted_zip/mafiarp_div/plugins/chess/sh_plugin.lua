-- "gamemodes\\mafiarp\\plugins\\chess\\sh_plugin.lua"

local PLUGIN = PLUGIN
PLUGIN.name = "Chess and Droughts"
PLUGIN.author = "? and rusty"
PLUGIN.desc = "Adding chess and droughts to NutScript."

nut.util.includeDir(PLUGIN.path.."/chess", true)

ALWAYS_RAISED = ALWAYS_RAISED or {}
ALWAYS_RAISED["chess_admin_tool"] = true