-- "gamemodes\\mafiarp\\plugins\\pkwar\\cl_networking.lua"


local PLUGIN = PLUGIN

function PLUGIN:RequestSync()
    net.Start( "FactionWars.SyncRequested" )
    net.SendToServer()
end

function PLUGIN:BindCharacterToWar( char )
    net.Start( "FactionWars.BindCharacterToWar" )
    net.WriteUInt( char, 32 )
    net.SendToServer()
end

function PLUGIN:RefuseCharacterBinding( char )
    net.Start( "FactionWars.RefuseCharacterBinding" )
    net.WriteUInt( char, 32 )
    net.SendToServer()
end

net.Receive( "FactionWars.SyncWars", function()
    PLUGIN.Wars = net.ReadTableAsString()
    hook.Run( "FactionWars.WarsSynced" )
end )

hook.Add( "InitPostEntity", "FactionWars.Networking.InitPostEntity", function()
    PLUGIN:RequestSync()
end )