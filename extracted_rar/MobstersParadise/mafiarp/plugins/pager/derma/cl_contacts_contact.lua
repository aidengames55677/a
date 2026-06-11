-- "gamemodes\\mafiarp\\plugins\\pager\\derma\\cl_contacts_contact.lua"


local PANEL = {}

local deleteMaterial = Material( "icon16/delete.png" )
local editMaterial = Material( "icon16/page_edit.png" )

local editContact

function PANEL:Init()
    self:SetTall( 30 )

    self.NameButton = vgui.Create( "DButton", self )
    self.NameButton:Dock( FILL )
    self.NameButton:SetText( "Unknown" )
    self.NameButton:SetTextColor( color_white )
    self.NameButton:SetWide( 275 )
    self.NameButton.DoClick = function()
        if editContact then
            editContact:Remove()
        end

        editContact = vgui.Create( "Pager.Contacts.CreateContact" )
        editContact:SetEditingInfo( self.ID, self.Name )
    end

    local editButton = vgui.Create( "DButton", self )
    editButton:Dock( RIGHT )
    editButton:SetWide( 30 )
    editButton:SetText( "" )
    editButton.PaintOver = function( _, w, h )
        surface.SetDrawColor( color_white )
        surface.SetMaterial( editMaterial )
        surface.DrawTexturedRect( w / 2 - 8, h / 2 - 8, 16, 16 )
    end
    editButton:SetTooltip( "Edit" )
    editButton.DoClick = function()
        if editContact then
            editContact:Remove()
        end

        editContact = vgui.Create( "Pager.Contacts.CreateContact" )
        editContact:SetEditingInfo( self.ID, self.Name )
    end

    local deleteButton = vgui.Create( "DButton", self )
    deleteButton:Dock( RIGHT )
    deleteButton:SetWide( 30 )
    deleteButton:SetText( "" )
    deleteButton.PaintOver = function( _, w, h )
        surface.SetDrawColor( color_white )
        surface.SetMaterial( deleteMaterial )
        surface.DrawTexturedRect( w / 2 - 8, h / 2 - 8, 16, 16 )
    end
    deleteButton:SetTooltip( "Delete" )
    deleteButton.DoClick = function()
        if not self.ID or not self.Name then return end

        Derma_Query( "Are you sure you want to delete this contact?", "Delete Contact",
        "Yes", function()
            if not self.ID then return end
            net.Start( "Pager.ContactDeleted" )
            net.WriteUInt( self.ID, 32 )
            net.SendToServer()
            nut.util.notify( "You deleted a contact" )
        end,
        "No" )
    end

    self.IDButton = vgui.Create( "DButton", self )
    self.IDButton:Dock( RIGHT )
    self.IDButton:SetText( "0" )
    self.IDButton:SetTextColor( color_white )
    self.IDButton:SetWide( 145 )
    self.IDButton.DoClick = function()
        if editContact then
            editContact:Remove()
        end

        editContact = vgui.Create( "Pager.Contacts.CreateContact" )
        editContact:SetEditingInfo( self.ID, self.Name )
    end
end

function PANEL:SetInfo( id, name )
    self.ID = id
    self.Name = name

    self.IDButton:SetText( tostring( id ) )
    self.NameButton:SetText( name )
end

function PANEL:OnRemove()
    if editContact then
        editContact:Remove()
    end
end

function PANEL:Think()
    local hovering = self.NameButton:IsHovered() or self.IDButton:IsHovered()

    self.NameButton.Hovered = hovering
    self.IDButton.Hovered = hovering
end

vgui.Register( "Pager.Contacts.Contact", PANEL, "EditablePanel" )