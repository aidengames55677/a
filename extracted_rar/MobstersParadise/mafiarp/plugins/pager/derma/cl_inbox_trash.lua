-- "gamemodes\\mafiarp\\plugins\\pager\\derma\\cl_inbox_trash.lua"


local PANEL = {}

function PANEL:Init()
    self.ScrollPanel = vgui.Create( "DScrollPanel", self )
    self.ScrollPanel:Dock( FILL )

    local headers = vgui.Create( "DPanel", self.ScrollPanel )
    headers:Dock( TOP )
    headers.Paint = function( _, w, h )
        draw.SimpleText( "Date", "DermaDefault", w * 0.09, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.SimpleText( "Subject", "DermaDefault", w * 0.33, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.SimpleText( "Sender", "DermaDefault", w * 0.59, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.SimpleText( "Recipient", "DermaDefault", w * 0.801, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    local trashAllPanel = vgui.Create( "DPanel", self )
    trashAllPanel:Dock( BOTTOM )
    trashAllPanel:SetTall( 40 )
    trashAllPanel.Paint = function() end
    trashAllPanel:DockMargin( 5, 5, 5, 5 )

    local trashAll = vgui.Create( "DButton", trashAllPanel )
    trashAll:Dock( LEFT )
    trashAll:SetText( "Empty Trash" )
    trashAll:SetWide( 85 )
    trashAll.DoClick = function()
        Derma_Query( "Are you sure you want to empty your trash?", "Empty Trash",
        "Yes", function()
            net.Start( "Pager.EmptyTrash" )
            net.SendToServer()
            nut.util.notify( "You emptied trash" )
        end,
        "No" )
    end

    self.Items = {}
end

function PANEL:SetMessages( messages, filter )
    self.Messages = messages

    for k, v in ipairs( self.Items ) do
        if IsValid( v ) then
            v:Remove()
        end
    end

    self.Items = {}

    local unsortedMessages = {}

    for k, v in pairs( messages.Sent ) do
        if v.TrashedForSender == TRASHED_STATUS.TRASHED then
            unsortedMessages[v.ID] = v
        end
    end

    for k, v in pairs( messages.Received ) do
        if v.TrashedForRecipient == TRASHED_STATUS.TRASHED then
            unsortedMessages[v.ID] = v
        end
    end

    messages = {}

    for k, v in pairs( unsortedMessages ) do
        table.insert( messages, v )
    end

    table.sort( messages, function( a, b ) return a.Timestamp > b.Timestamp end )

    for k, v in pairs( messages ) do
        if filter and filter ~= ""
        and not string.find( string.lower( v.Subject ), string.lower( filter ) )
        and not string.find( string.lower( tostring( v.Recipient ) ), string.lower( filter ) )
        and not string.find( string.lower( tostring( v.Sender ) ), string.lower( filter ) ) then
            continue
        end

        local item = vgui.Create( "Pager.Inbox.Trash.Item", self.ScrollPanel )
        item:Dock( TOP )
        item:DockMargin( 5, 3, 5, 0 )
        item:SetMessage( v )

        table.insert( self.Items, item )
    end
end

function PANEL:Paint()

end

vgui.Register( "Pager.Inbox.Trash", PANEL, "EditablePanel" )