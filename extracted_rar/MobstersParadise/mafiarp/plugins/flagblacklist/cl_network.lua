-- "gamemodes\\mafiarp\\plugins\\flagblacklist\\cl_network.lua"


local PLUGIN = PLUGIN

net.Receive( "Flagblacklist.Reason", function()
    Derma_StringRequest(
        "Flag Blacklist Reason",
        "Enter a reason:",
        "",
        function( text )
            if #text > 128 then
                nut.util.notify( "Your blacklist reason is too long. Please simplify it." )
                return false
            else
                net.Start( "Flagblacklist.Blacklist" )
                    net.WriteString( text )
                net.SendToServer()
            end
        end
    )
end )

net.Receive( "Flagblacklist.Notify", function()
    local reason = net.ReadString()
    local admin = net.ReadEntity()
    Derma_Query(
        "Your PET flags have been blacklisted by " .. admin:Nick() .. " for '" .. reason .. "'.\n You can appeal at the link below.",
        "Blacklisted",
        "Take me to Appeal",
        function()
            gui.OpenURL( "https://divergenet.works/forums/forumdisplay.php?fid=60" )
        end,
        "Close"
    )
end )