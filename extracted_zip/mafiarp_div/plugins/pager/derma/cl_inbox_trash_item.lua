-- "gamemodes\\mafiarp\\plugins\\pager\\derma\\cl_inbox_trash_item.lua"


if not CLIENT then return end -- For some reason this gets included on the server?? Nutscript moment

local PANEL = {}

local deleteMaterial = Material( "icon16/delete.png" )
local restoreMaterial = Material( "icon16/page_refresh.png" )

function PANEL:Init()
    self:SetTall( 30 )

    self.DateButton = vgui.Create( "DButton", self )
    self.DateButton:Dock( LEFT )
    self.DateButton:SetText( "0 seconds ago" )
    self.DateButton:SetTextColor( color_white )
    self.DateButton:SetWide( 115 )
    self.DateButton.DoClick = function()
        self:OpenMessage()
    end

    self.SubjectButton = vgui.Create( "DButton", self )
    self.SubjectButton:Dock( FILL )
    self.SubjectButton:SetText( "[no subject]" )
    self.SubjectButton:SetTextColor( color_white )
    self.SubjectButton:SetWide( 275 )
    self.SubjectButton.DoClick = function()
        self:OpenMessage()
    end

    if not PagerPanel.ReadOnly then
        local restoreButton = vgui.Create( "DButton", self )
        restoreButton:Dock( RIGHT )
        restoreButton:SetWide( 30 )
        restoreButton:SetText( "" )
        restoreButton.PaintOver = function( _, w, h )
            surface.SetDrawColor( color_white )
            surface.SetMaterial( restoreMaterial )
            surface.DrawTexturedRect( w / 2 - 8, h / 2 - 8, 16, 16 )
        end
        restoreButton:SetTooltip( "Restore" )
        restoreButton.DoClick = function()
            Derma_Query( "Are you sure you want to take this message out of the trash?", "Restore Message",
            "Yes", function()
                if not self.Message then return end
                net.Start( "Pager.UpdateTrashedStatus" )
                net.WriteUInt( self.Message.ID, 32 )
                net.WriteUInt( TRASHED_STATUS.NOT_TRASHED, 4 )
                net.SendToServer()
                nut.util.notify( "You restored a message" )
            end,
            "No" )
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
        deleteButton:SetTooltip( "Delete Permanently" )
        deleteButton.DoClick = function()
            Derma_Query( "Are you sure you want to delete this message permanently? You cannot restore it.", "Delete Message",
            "Yes", function()
                if not self.Message then return end
                net.Start( "Pager.UpdateTrashedStatus" )
                net.WriteUInt( self.Message.ID, 32 )
                net.WriteUInt( TRASHED_STATUS.DELETED, 4 )
                net.SendToServer()
                nut.util.notify( "You deleted a message" )
            end,
            "No" )
        end
    end

    self.RecipientButton = vgui.Create( "DButton", self )
    self.RecipientButton:Dock( RIGHT )
    self.RecipientButton:SetText( "Unknown (0)" )
    self.RecipientButton:SetTextColor( color_white )
    self.RecipientButton:SetWide( 145 )
    self.RecipientButton.DoClick = function()
        self:OpenMessage()
    end

    self.SenderButton = vgui.Create( "DButton", self )
    self.SenderButton:Dock( RIGHT )
    self.SenderButton:SetText( "Unknown (0)" )
    self.SenderButton:SetTextColor( color_white )
    self.SenderButton:SetWide( 145 )
    self.SenderButton.DoClick = function()
        self:OpenMessage()
    end
end

function PANEL:OpenMessage()
    if not self.Message or not PagerPanel then return end
    PagerPanel:OpenItem( self.Message )
end

function PANEL:SetMessage( message )
    self.Message = message
    self.DateButton:SetText( message:GetFormattedTime() )
    self.SubjectButton:SetText( message.Subject )
    self.SenderButton:SetText( message:GetSenderName( PagerPanel.ContactsTable ) )
    self.RecipientButton:SetText( message:GetRecipientName( PagerPanel.ContactsTable ) )
end

function PANEL:Think()
    local hovering = self.DateButton:IsHovered() or self.SubjectButton:IsHovered() or self.SenderButton:IsHovered() or self.RecipientButton:IsHovered()

    self.DateButton.Hovered = hovering
    self.SubjectButton.Hovered = hovering
    self.SenderButton.Hovered = hovering
    self.RecipientButton.Hovered = hovering
end

vgui.Register( "Pager.Inbox.Trash.Item", PANEL, "EditablePanel" )