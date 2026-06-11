-- "gamemodes\\mafiarp\\plugins\\pager\\cl_network.lua"


local PLUGIN = PLUGIN

local function convertToMessageObject( tbl )
    return setmetatable( tbl, PagerMessage )
end

net.Receive( "Pager.OpenPager", function()
    local readOnly = net.ReadBool()
    local messages = net.ReadTable()
    local contacts
    local discordToken
    if not readOnly then
        contacts = net.ReadTable()
        discordToken = net.ReadString()
    end

    for k, v in pairs( messages.Sent ) do
        messages.Sent[k] = convertToMessageObject( v )
    end

    for k, v in pairs( messages.Received ) do
        messages.Received[k] = convertToMessageObject( v )
    end

    table.sort( messages.Sent, function( a, b ) return a.Timestamp > b.Timestamp end )
    table.sort( messages.Received, function( a, b ) return a.Timestamp > b.Timestamp end )

    PLUGIN:OpenPager( readOnly, messages, contacts, discordToken )
end )