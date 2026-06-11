-- "gamemodes\\mafiarp\\plugins\\medals\\cl_network.lua"


local PLUGIN = PLUGIN

net.Receive( "Medals.Update", function( len )
    local decompressed_data = util.Decompress( net.ReadData( len ) )
    local medals = util.JSONToTable( decompressed_data )

    PLUGIN.PlayerMedals = medals
end )

net.Receive( "Medals.ManageMenu", function()
    local medals = net.ReadTable()
    local charId = net.ReadUInt( 32 )

    PLUGIN:ManageMenu( medals, charId )
end )

net.Receive( "Medals.MedalsMenu", function()
    PLUGIN:MedalsMenu()
end )