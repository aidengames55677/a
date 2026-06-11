-- "gamemodes\\mafiarp\\plugins\\pager\\derma\\cl_inbox_overview_item.lua"


local PANEL = {}

local deleteMaterial = Material( "icon16/bin.png" )
local replyMaterial = Material( "icon16/page_go.png" )

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
        local replyButton = vgui.Create( "DButton", self )
        replyButton:Dock( RIGHT )
        replyButton:SetWide( 30 )
        replyButton:SetText( "" )
        replyButton.PaintOver = function( _, w, h )
            surface.SetDrawColor( color_white )
            surface.SetMaterial( replyMaterial )
            surface.DrawTexturedRect( w / 2 - 8, h / 2 - 8, 16, 16 )
        end
        replyButton:SetTooltip( "Reply" )
        replyButton.DoClick = function()
            PagerPanel:StartDraftingMessage( self.Message.Subject, self.Message.Sender )
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

function PANEL:SetRead( read )
    self.DateButton:SetTextColor( read and Color( 175, 175, 175 ) or color_white )
    self.SubjectButton:SetTextColor( read and Color( 175, 175, 175 ) or color_white )
    self.SenderButton:SetTextColor( read and Color( 175, 175, 175 ) or color_white )
end

function PANEL:SetMessage( message )
    self.Message = message
    self.DateButton:SetText( message:GetFormattedTime() )
    self.SubjectButton:SetText( message.Subject )
    self.SenderButton:SetText( message:GetSenderName( PagerPanel.ContactsTable ) )
    self:SetRead( message.Read )
end

function PANEL:Think()
    local hovering = self.DateButton:IsHovered() or self.SubjectButton:IsHovered() or self.SenderButton:IsHovered()

    self.DateButton.Hovered = hovering
    self.SubjectButton.Hovered = hovering
    self.SenderButton.Hovered = hovering
end

vgui.Register( "Pager.Inbox.Overview.Item", PANEL, "EditablePanel" )