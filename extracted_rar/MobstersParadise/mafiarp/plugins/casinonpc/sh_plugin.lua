-- "gamemodes\\mafiarp\\plugins\\casinonpc\\sh_plugin.lua"


local PLUGIN = PLUGIN

PLUGIN.name = "Casino NPC"
PLUGIN.author = "GlorifiedPig"
PLUGIN.desc = "NPC to manage casinos."

nut.util.include( "sv_plugin.lua" )
nut.util.include( "sv_commands.lua" )
nut.util.include( "sv_sql.lua" )
nut.util.include( "sv_network.lua" )
nut.util.include( "sh_permissions.lua" )
nut.util.include( "cl_commands.lua" )
nut.util.include( "cl_network.lua" )

function PLUGIN:PlayerHasAdminPerms( ply ) -- Player will be able to access all casino NPCs and use all commands.
    return SCHEMA.RanksSuper[ply:GetUserGroup()]
end

CasinoNPC = PLUGIN