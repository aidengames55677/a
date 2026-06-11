-- "gamemodes\\mafiarp\\plugins\\pager\\derma\\cl_inbox_overview.lua"


local PANEL = {}

function PANEL:Init()
    local headers = vgui.Create( "DPanel", self )
    headers:Dock( TOP )
    headers.Paint = function( _, w, h )
        draw.SimpleText( "Date", "DermaDefault", w * 0.09, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.SimpleText( "Subject", "DermaDefault", w * 0.435, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.SimpleText( "Sender", "DermaDefault", w * 0.801, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
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

    for k, v in pairs( messages ) do
        if v.TrashedForRecipient ~= TRASHED_STATUS.NOT_TRASHED then continue end

        if filter and filter ~= ""
        and not string.find( string.lower( v.Subject ), string.lower( filter ) )
        and not string.find( string.lower( tostring( v.Recipient ) ), string.lower( filter ) )
        and not string.find( string.lower( tostring( v.Sender ) ), string.lower( filter ) ) then
            continue
        end

        local item = vgui.Create( "Pager.Inbox.Overview.Item", self )
        item:Dock( TOP )
        item:DockMargin( 5, 3, 5, 0 )
        item:SetMessage( v )

        table.insert( self.Items, item )
    end
end

vgui.Register( "Pager.Inbox.Overview", PANEL, "DScrollPanel" )