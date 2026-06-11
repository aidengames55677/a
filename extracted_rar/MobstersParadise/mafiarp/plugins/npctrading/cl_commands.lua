-- "gamemodes\\mafiarp\\plugins\\npctrading\\cl_commands.lua"


nut.command.add( "edittrader", {
    onCheckAccess = function( client )
        return client:IsAdmin()
    end,
    onRun = function() end
} )

nut.command.add( "editrecipes", {
    onCheckAccess = function( client )
        return client:IsAdmin()
    end,
    onRun = function() end
} )