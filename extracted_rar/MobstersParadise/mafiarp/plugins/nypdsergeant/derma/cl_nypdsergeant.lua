-- "gamemodes\\mafiarp\\plugins\\nypdsergeant\\derma\\cl_nypdsergeant.lua"


local PLUGIN = PLUGIN

function PLUGIN:OpenSergeantMenu()
    local char = LocalPlayer():getChar()

    local options = {
        opening = {
            response = "How may we help?",
            options = {
                "communicate",
                "report",
                "recruitmentinfo",
                "recruitmentexam",
                "exit"
            }
        },
        communicate = {
            dialog = "Communicate with the NYPD",
            callback = function()
                gui.OpenURL( "https://discord.gg/4QB9a4gnzb" )
            end
        },
        report = {
            dialog = "Report an Officer",
            callback = function()
                gui.OpenURL( "https://forms.gle/YbathcJ33eFAmrxu6" )
            end
        },
        recruitmentinfo = {
            dialog = "Recruitment Information",
            callback = function()
                gui.OpenURL( "https://docs.google.com/presentation/d/1piZJNa-Un2rBbYjKtu6_H5siVPBCBagbb5yXHdPNREg/edit?usp=sharing" )
            end
        },
        recruitmentexam = {
            dialog = "Pre-Recruitment Exam",
            callback = function( panel )
                panel:Close()

                if not self:CharPassedTest( char ) and not self:IsCharBlacklisted( char ) then
                    vgui.Create( "RecruitmentExam" )
                else
                    nut.util.notify( "You cannot do the test at this time." )
                end
            end
        },
        exit = {
            dialog = "Exit",
            callback = function( panel, key )
                panel:Close()
            end,
        },
    }

    local dialog = vgui.Create( "hdNPCDialog" )
    dialog:SetTitle( "NYPD Sergeant" )
    dialog:AddDialogOptions( options )
    dialog:SetModel( "models/portal/nypd/nypdmale_03.mdl" )
    dialog.Think = function()
        if input.IsKeyDown( KEY_ESCAPE ) then
            RunConsoleCommand( "cancelselect" )
            dialog:Close()
        end
    end
end

net.Receive( "NYPD.OpenMenu", function()
    PLUGIN:OpenSergeantMenu()
end )