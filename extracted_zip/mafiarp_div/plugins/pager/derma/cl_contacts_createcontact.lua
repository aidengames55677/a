-- "gamemodes\\mafiarp\\plugins\\pager\\derma\\cl_contacts_createcontact.lua"


local PANEL = {}

function PANEL:Init()
    self:SetSize( 270, 190 )
    self:MakePopup()
    self:Center()
    self:SetDraggable( false )
    self:SetBackgroundBlur( true )
    self:SetDrawOnTop( true )
    self:DoModal()
    self:SetTitle( "Create Contact" )

    self.NameLabel = vgui.Create( "DLabel", self )
    self.NameLabel:SetPos( 10, 30 )
    self.NameLabel:SetText( "Contact Name" )
    self.NameLabel:SizeToContents()

    self.NameEntry = vgui.Create( "DTextEntry", self )
    self.NameEntry:SetPos( 10, 50 )
    self.NameEntry:SetSize( 250, 25 )
    self.NameEntry:SetTextColor( Color( 200, 200, 200 ) )
    self.NameEntry:SetMaximumCharCount( 28 )

    self.IDLabel = vgui.Create( "DLabel", self )
    self.IDLabel:SetPos( 10, 95 )
    self.IDLabel:SetText( "Contact ID" )
    self.IDLabel:SizeToContents()

    self.IDEntry = vgui.Create( "DTextEntry", self )
    self.IDEntry:SetPos( 10, 115 )
    self.IDEntry:SetSize( 250, 25 )
    self.IDEntry:SetTextColor( Color( 200, 200, 200 ) )
    self.IDEntry:SetNumeric( true )
    self.IDEntry:SetMaximumCharCount( 10 )
    self.IDEntry.AllowInput = function( _, char )
        if not string.find( "0123456789", char, 1, true ) then
            return true
        end
    end

    self.Buttons = vgui.Create( "DPanel", self )
    self.Buttons:Dock( BOTTOM )
    self.Buttons:SetTall( 30 )
    self.Buttons:DockMargin( 5, 5, 5, 5 )
    self.Buttons.Paint = function() end

    self.CreateButton = vgui.Create( "DButton", self.Buttons )
    self.CreateButton:Dock( LEFT )
    self.CreateButton:SetWide( 125 )
    self.CreateButton:SetTextColor( color_white )
    self.CreateButton:SetText( "Create" )
    self.CreateButton.DoClick = function()
        local name, id = self.NameEntry:GetValue(), self.IDEntry:GetInt()

        if not isstring( name ) or string.len( name ) < 1 then return end
        if not isnumber( id ) or id < 1 or id > 999999 then return end

        if self.Editing then
            net.Start( "Pager.ContactEdited" )
            net.WriteUInt( self.Editing, 32 )
            net.WriteUInt( id, 32 )
            net.WriteString( name )
            net.SendToServer()
            nut.util.notify( "You edited a message" )
        else
            net.Start( "Pager.ContactCreated" )
            net.WriteUInt( id, 32 )
            net.WriteString( name )
            net.SendToServer()
            nut.util.notify( "You created a contact" )
        end

        self:Remove()
    end

    self.CancelButton = vgui.Create( "DButton", self.Buttons )
    self.CancelButton:Dock( RIGHT )
    self.CancelButton:SetWide( 125 )
    self.CancelButton:SetTextColor( color_white )
    self.CancelButton:SetText( "Cancel" )
    self.CancelButton.DoClick = function()
        self:Remove()
    end
end

function PANEL:SetEditingInfo( oldId, oldName )
    self.Editing = oldId

    self.NameEntry:SetText( oldName )
    self.IDEntry:SetText( tostring( oldId ) )

    self:SetTitle( "Edit Contact" )
    self.CreateButton:SetText( "Edit" )
end

vgui.Register( "Pager.Contacts.CreateContact", PANEL, "DFrame" )