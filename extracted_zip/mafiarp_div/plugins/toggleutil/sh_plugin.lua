-- "gamemodes\\mafiarp\\plugins\\toggleutil\\sh_plugin.lua"

local PLUGIN = PLUGIN
PLUGIN.name = "Toggle Util"
PLUGIN.author = "Pendred, Tyl"
PLUGIN.desc = "Adds functionality to toggle off SWEPs."

nut.util.include("sv_plugin.lua")

if (CLIENT) then
    nut.command.add("togglepet", {
        onRun = function(ply, arguments)
        end
    })

    nut.command.add("togglecig", {
        onRun = function(client, arguments)
        end
    })
end