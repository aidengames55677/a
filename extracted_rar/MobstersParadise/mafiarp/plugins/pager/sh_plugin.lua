-- "gamemodes\\mafiarp\\plugins\\pager\\sh_plugin.lua"


local PLUGIN = PLUGIN

PLUGIN.name = "Pager"
PLUGIN.author = "GlorifiedPig"
PLUGIN.desc = "System for sending messages between players"

PLUGIN.max_content_size = 2048

nut.util.include( "sv_plugin.lua" )
nut.util.include( "cl_plugin.lua" )
nut.util.include( "cl_network.lua" )

function PLUGIN:HasPager( ply )
    local char = ply:getChar()
    if not char then return false end
    if not ply:Alive() then return false end
    if ply:getNetVar( "restricted" ) then return false end

    return true
end

Pager = PLUGIN