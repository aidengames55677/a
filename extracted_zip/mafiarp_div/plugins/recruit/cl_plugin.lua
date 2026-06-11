-- "gamemodes\\mafiarp\\plugins\\recruit\\cl_plugin.lua"


local PLUGIN = PLUGIN

net.Receive( "Recruit.ConfirmPrompt", function()
    nut.util.notifQuery( "A player has attempted to recruit you into their faction. If you agree to this and it was consensual, press yes. If it wasn't, press no and contact a staff member to report abuse.", "Accept", "Deny", true, NOT_CORRECT, function( code )
        if code == 1 then
            net.Start( "Recruit.Confirm" )
            net.SendToServer()
        elseif code == 2 then
            net.Start( "Recruit.Deny")
            net.SendToServer()
        end
    end )
end )

nut.command.add( "charallowtransfer", {
    syntax = "<string charid>",
    onRun = function() end
} )

nut.command.add( "recruit", {
    onRun = function() end
} )