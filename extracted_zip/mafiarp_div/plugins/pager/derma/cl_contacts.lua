-- "gamemodes\\mafiarp\\plugins\\pager\\derma\\cl_contacts.lua"


local PANEL = {}

local createContact

function PANEL:Init()
    local headers = vgui.Create( "DPanel", self )
    headers:Dock( TOP )
    headers.Paint = function( _, w, h )
        draw.SimpleText( "Name", "DermaDefault", w * 0.35, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.SimpleText( "ID", "DermaDefault", w * 0.798, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    self.Contacts = vgui.Create( "DScrollPanel", self )
    self.Contacts:Dock( FILL )

    -- Buttons
    self.Buttons = vgui.Create( "DPanel", self )
    self.Buttons:Dock( BOTTOM )
    self.Buttons:SetTall( 32 )
    self.Buttons:DockMargin( 15, 0, 15, 10 )
    self.Buttons.Paint = function() end

    self.NewContact = vgui.Create( "DButton", self.Buttons )
    self.NewContact:Dock( LEFT )
    self.NewContact:SetText( "New Contact" )
    self.NewContact:SetWide( 100 )
    self.NewContact:SetTextColor( color_white )
    self.NewContact.DoClick = function()
        if createContact then
            createContact:Remove()
        end

        createContact = vgui.Create( "Pager.Contacts.CreateContact" )
    end

    self.DeleteAll = vgui.Create( "DButton", self.Buttons )
    self.DeleteAll:Dock( LEFT )
    self.DeleteAll:SetText( "Delete All" )
    self.DeleteAll:SetWide( 100 )
    self.DeleteAll:SetTextColor( color_white )
    self.DeleteAll.DoClick = function()
        Derma_Query( "Are you sure you want to clear your contact list?", "Delete Contacts",
        "Yes", function()
            net.Start( "Pager.ContactsDeleted" )
            net.SendToServer()
            nut.util.notify( "You cleared your contacts" )
        end,
        "No" )
    end

    self.GoBack = vgui.Create( "DButton", self.Buttons )
    self.GoBack:Dock( RIGHT )
    self.GoBack:SetText( "Go Back" )
    self.GoBack:SetWide( 100 )
    self.GoBack:SetTextColor( color_white )
    self.GoBack.DoClick = function()
        if not PagerPanel then return end
        PagerPanel:ReturnToInbox()
    end
end

function PANEL:SetContacts( contacts, filter )
    self.ContactsTable = contacts

    if self.ContactPanels then
        for _, v in ipairs( self.ContactPanels ) do
            v:Remove()
        end
    end

    self.ContactPanels = {}

    for k, v in pairs( contacts ) do
        if filter and filter ~= ""
        and not string.find( string.lower( k ), string.lower( filter ) )
        and not string.find( string.lower( tostring( v ) ), string.lower( filter ) ) then
            continue
        end

        local contact = vgui.Create( "Pager.Contacts.Contact", self.Contacts )
        contact:Dock( TOP )
        contact:DockMargin( 5, 3, 5, 0 )
        contact:SetInfo( k, v )
        table.insert( self.ContactPanels, contact )
    end
end

function PANEL:OnRemove()
    if createContact then
        createContact:Remove()
    end
end

vgui.Register( "Pager.Contacts", PANEL, "DPanel" )