-- "gamemodes\\mafiarp\\plugins\\pager\\derma\\cl_inbox_sent_item.lua"


local PANEL = {}

local deleteMaterial = Material( "icon16/bin.png" )
local followUpMaterial = Material( "icon16/page_go.png" )

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
        local followUpButton = vgui.Create( "DButton", self )
        followUpButton:Dock( RIGHT )
        followUpButton:SetWide( 30 )
        followUpButton:SetText( "" )
        followUpButton.PaintOver = function( _, w, h )
            surface.SetDrawColor( color_white )
            surface.SetMaterial( followUpMaterial )
            surface.DrawTexturedRect( w / 2 - 8, h / 2 - 8, 16, 16 )
        end
        followUpButton:SetTooltip( "Follow Up" )
        followUpButton.DoClick = function()
            PagerPanel:StartDraftingMessage( self.Message.Subject, self.Message.Recipient )
        end

        local trashButton = vgui.Create( "DButton", self )
        trashButton:Dock( RIGHT )
        trashButton:SetWide( 30 )
        trashButton:SetText( "" )
        trashButton.PaintOver = function( _, w, h )
            surface.SetDrawColor( color_white )
            surface.SetMaterial( deleteMaterial )
            surface.DrawTexturedRect( w / 2 - 8, h / 2 - 8, 16, 16 )
        end
        trashButton:SetTooltip( "Trash" )
        trashButton.DoClick = function()
            Derma_Query( "Are you sure you want to trash this message? You can restore it from the trash.", "Trash Message",
            "Yes", function()
                if not self.Message then return end
                net.Start( "Pager.UpdateTrashedStatus" )
                net.WriteUInt( self.Message.ID, 32 )
                net.WriteUInt( TRASHED_STATUS.TRASHED, 4 )
                net.SendToServer()
                nut.util.notify( "You trashed a message" )
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
end

function PANEL:OpenMessage()
    if not self.Message or not PagerPanel then return end
    PagerPanel:OpenItem( self.Message )
end

function PANEL:SetMessage( message )
    self.Message = message
    self.DateButton:SetText( message:GetFormattedTime() )
    self.SubjectButton:SetText( message.Subject )
    self.RecipientButton:SetText( message:GetRecipientName( PagerPanel.ContactsTable ) )
end

function PANEL:Think()
    local hovering = self.DateButton:IsHovered() or self.SubjectButton:IsHovered() or self.RecipientButton:IsHovered()

    self.DateButton.Hovered = hovering
    self.SubjectButton.Hovered = hovering
    self.RecipientButton.Hovered = hovering
end

vgui.Register( "Pager.Inbox.Sent.Item", PANEL, "EditablePanel" )