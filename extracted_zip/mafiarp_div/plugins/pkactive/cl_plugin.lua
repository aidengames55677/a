-- "gamemodes\\mafiarp\\plugins\\pkactive\\cl_plugin.lua"


local PLUGIN = PLUGIN

nut.command.add( "pkactive", {
    syntax = "<string name>",
    onRun = function() end
} )

nut.command.add( "pkactiveoffline", {
    syntax = "<string charID>",
    onRun = function() end
} )

net.Receive( "PK.ShowFactionList", function()
    local target = net.ReadUInt( 32 )

    local frame = vgui.Create( "DFrame" )
    frame:SetSize( 400, 300 )
    frame:SetTitle( "Faction Select" )
    frame:MakePopup()
    frame:Center()
    frame.Think = function()
        if input.IsKeyDown( KEY_ESCAPE ) then
            RunConsoleCommand( "cancelselect" )
            frame:Close()
        end
    end

    local label = vgui.Create( "DLabel", frame )
    label:Dock( TOP )
    label:SetText( "Please select which factions you want to enable PK for " .. target .. " on.\nIf the player kills someone in these factions, they will also get PK'd.\nIf no factions are checked, then this player will get PK'd upon next death." )
    label:SetAutoStretchVertical( true )
    label:SetWrap( true )

    local scrollPanel = vgui.Create( "DScrollPanel", frame )
    scrollPanel:Dock( FILL )
    scrollPanel:DockMargin( 0, 5, 0, 5 )

    local factionBoxes = {}

    for k, v in pairs( nut.faction.teams ) do
        local faction = vgui.Create( "DCheckBoxLabel", scrollPanel )
        faction:SetText( v.name )
        faction:Dock( TOP )
        faction.ID = v.uniqueID
        table.insert( factionBoxes, faction )
    end

    local buttons = vgui.Create( "DPanel", frame )
    buttons:Dock( BOTTOM )
    buttons.Paint = nil

    local confirmButton = vgui.Create( "DButton", buttons )
    confirmButton:Dock( LEFT )
    confirmButton:SetText( "Confirm" )
    confirmButton:SetWide( 195 )
    confirmButton.DoClick = function()
        local factions = {}

        for k, v in pairs( factionBoxes ) do
            if v:GetChecked() then
                table.insert( factions, v.ID )
            end
        end

        net.Start( "PK.ActivatePlayerPK" )
        net.WriteUInt( target, 32 )
        net.WriteBool( #factions > 0 )
        if #factions > 0 then
            net.WriteTable( factions )
        end
        net.SendToServer()
        frame:Close()
    end

    local cancelButton = vgui.Create( "DButton", buttons )
    cancelButton:Dock( RIGHT )
    cancelButton:SetText( "Cancel" )
    cancelButton:SetWide( 195 )
    cancelButton.DoClick = function()
        frame:Close()
    end
end )

net.Receive( "PK.ShowScreen", function()
    local name = net.ReadString()
    local age = net.ReadUInt( 16 ) or 0

    RunConsoleCommand( "stopsound" )

    timer.Simple( 0.1, function() -- Icky, but needs to be in a timer else nut.gui.character is invalid.
        nut.gui.character:Hide()

        surface.PlaySound( "diverge/dead.mp3" )
        hook.Add( "HUDPaint", "PK", function()
            surface.SetDrawColor( 0, 0, 0, 255 )

            LocalPlayer():ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 255 ), 5, 2 )

            if isnumber( age ) and age > 0 then
                age = tonumber( age )
                draw.DrawText( 1988 - age .. " - 1988", "nutTitleFont", ScrW() * 0.5, ScrH() * 0.25 + 75, Color( 255, 255, 255, math.Approach( 255, 0, 100 ) ), TEXT_ALIGN_CENTER )
            else
                draw.DrawText( "?" .. " - 1988", "nutTitleFont", ScrW() * 0.5, ScrH() * 0.25 + 75, Color( 255, 255, 255, math.Approach( 255, 0, 100 ) ), TEXT_ALIGN_CENTER )
            end

            draw.DrawText( name, "nutTitleFont", ScrW() * 0.5, ScrH() * 0.25, Color( 255, 255, 255, math.Approach( 255, 0, 100 ) ), TEXT_ALIGN_CENTER )
        end )

        timer.Simple( 35, function()
            hook.Remove( "HUDPaint", "PK" )
            nut.gui.character:Show()
            Derma_Query(
            string.format( [[Your character: %s, has been permanently killed. A member of staff has approved this PK for a reason he/she has deemed warranting of a PK.
If you believe this PK may be unfair, see the options below.
            
Note: PKs are a regular occurance of RP, and should not be taken too seriously, remember you can always make a new character.
Do not let this hinder on your experience on our server, sometimes it's best to accept reality, move on, and have fun.]], name ),
            "Permanently Killed",
            "I accept this PK.", function()
                RunConsoleCommand( "stopsound" )
            end,
            "I don't accept this PK.", function()
                Derma_Query( "We're sorry to hear that, below you may access our forums and file a character appeal, and a member of Upper Administration\nwill investigate the circumstances and decide whether or not it's valid.",
                "Appeal",
                "Take me to appeal", function()
                    gui.OpenURL( "https://divergenet.works/forums/forumdisplay.php?fid=37%22" )
                    RunConsoleCommand( "stopsound" )
                end,
                "Nevermind, Close", function()
                    RunConsoleCommand( "stopsound" )
                end )
            end )
        end )
    end )
end )