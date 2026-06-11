-- "gamemodes\\mafiarp\\plugins\\bank\\sh_plugin.lua"


local PLUGIN = PLUGIN

PLUGIN.name = "Banking System"
PLUGIN.author = "GlorifiedPig"
PLUGIN.desc = "Bank for Diverge Networks."

nut.util.include( "sh_permissions.lua" )
nut.util.include( "sv_plugin.lua" )
nut.util.include( "sv_sql.lua" )
nut.util.include( "sv_network.lua" )
nut.util.include( "sv_commands.lua" )
nut.util.include( "cl_plugin.lua" )
nut.util.include( "cl_network.lua" )
nut.util.include( "cl_commands.lua" )

PLUGIN.vipGroups = {
    ["founder"] = true,
    ["superadmin"] = true,
    ["communitymanager"] = true,
    ["superadministrator"] = true,
    ["senioradministrator"] = true,
    ["seasonedadministrator"] = true,
    ["administrator"] = true,
    ["moderator"] = true,
    ["eventmanager"] = true,
    ["donator"] = true,
}

function PLUGIN:IsPlayerVIP( ply )
    return self.vipGroups[ply:GetUserGroup()]
end

Bank = PLUGIN -- TODO Remove this: I often need PLUGIN in lua_run and cba to type nut.plugin.list every time.