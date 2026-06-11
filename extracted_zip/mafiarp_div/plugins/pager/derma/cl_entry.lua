-- "gamemodes\\mafiarp\\plugins\\pager\\derma\\cl_entry.lua"


local PANEL = {}

function PANEL:Init()
    self.IsSender = false -- Set to true if we want to show the recipient instead of the sender.

    -- Subject Line
    self.SubjectLine = vgui.Create( "DPanel", self )
    self.SubjectLine:Dock( TOP )
    self.SubjectLine:DockMargin( 15, 10, 15, 0 )
    self.SubjectLine:SetTall( 25 )
    self.SubjectLine.Paint = function() end

    self.SubjectLine.Label = vgui.Create( "DLabel", self.SubjectLine )
    self.SubjectLine.Label:Dock( LEFT )
    self.SubjectLine.Label:SetText( "Subject" )
    self.SubjectLine.Label:DockMargin( 0, 0, 5, 0 )

    self.SubjectLine.Value = vgui.Create( "DPanel", self.SubjectLine )
    self.SubjectLine.Value:Dock( FILL )
    self.SubjectLine.Value.Paint = function( _, w, h )
        surface.SetDrawColor( 45, 45, 45, 240 )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( 0, 0, 0, 180 )
        surface.DrawOutlinedRect( 0, 0, w, h )

        surface.SetDrawColor( 100, 100, 100, 25 )
        surface.DrawOutlinedRect( 1,  1, w - 2, h - 2 )

        if self.Message then
            draw.SimpleText( self.Message.Subject, "DermaDefault", 5, h / 2, Color( 200, 200, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        end
    end

    -- Date
    self.Date = vgui.Create( "DPanel", self )
    self.Date:Dock( TOP )
    self.Date:DockMargin( 15, 5, 15, 0 )
    self.Date:SetTall( 25 )
    self.Date.Paint = function() end

    self.Date.Label = vgui.Create( "DLabel", self.Date )
    self.Date.Label:Dock( LEFT )
    self.Date.Label:SetText( "Date" )
    self.Date.Label:DockMargin( 0, 0, 5, 0 )

    self.Date.Value = vgui.Create( "DPanel", self.Date )
    self.Date.Value:Dock( FILL )
    self.Date.Value.Paint = function( _, w, h )
        surface.SetDrawColor( 45, 45, 45, 240 )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( 0, 0, 0, 180 )
        surface.DrawOutlinedRect( 0, 0, w, h )

        surface.SetDrawColor( 100, 100, 100, 25 )
        surface.DrawOutlinedRect( 1,  1, w - 2, h - 2 )

        if self.Message then
            draw.SimpleText( self.Message:GetFormattedTime(), "DermaDefault", 5, h / 2, Color( 200, 200, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        end
    end

    -- Sender
    self.Sender = vgui.Create( "DPanel", self )
    self.Sender:Dock( TOP )
    self.Sender:DockMargin( 15, 5, 15, 0 )
    self.Sender:SetTall( 25 )
    self.Sender.Paint = function() end

    self.Sender.Label = vgui.Create( "DLabel", self.Sender )
    self.Sender.Label:Dock( LEFT )
    self.Sender.Label:SetText( "Sender" )
    self.Sender.Label:DockMargin( 0, 0, 5, 0 )
    self.Sender.Label.Think = function()
        self.Sender.Label:SetText( self.IsSender and "Recipient" or "Sender" )
    end

    self.Sender.Value = vgui.Create( "DPanel", self.Sender )
    self.Sender.Value:Dock( FILL )
    self.Sender.Value.Paint = function( _, w, h )
        surface.SetDrawColor( 45, 45, 45, 240 )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( 0, 0, 0, 180 )
        surface.DrawOutlinedRect( 0, 0, w, h )

        surface.SetDrawColor( 100, 100, 100, 25 )
        surface.DrawOutlinedRect( 1,  1, w - 2, h - 2 )

        if self.Message then
            draw.SimpleText( self.IsSender and self.Message:GetRecipientName( PagerPanel.ContactsTable ) or self.Message:GetSenderName( PagerPanel.ContactsTable ), "DermaDefault", 5, h / 2, Color( 200, 200, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        end
    end

    -- Content
    self.Content = vgui.Create( "DPanel", self )
    self.Content:Dock( FILL )
    self.Content:DockMargin( 15, 15, 15, 5 )

    self.Content.Text = vgui.Create( "RichText", self.Content )
    self.Content.Text:Dock( FILL )
    self.Content.Text:DockMargin( 5, 5, 5, 5 )
    self.Content.Text:SetVerticalScrollbarEnabled( false )
    self.Content.Text:SetText( "" )
    self.Content.Text.PerformLayout = function()
        self.Content.Text:SetFontInternal( "DermaDefault" )
    end

    -- Buttons
    self.Buttons = vgui.Create( "DPanel", self )
    self.Buttons:Dock( BOTTOM )
    self.Buttons:SetTall( 32 )
    self.Buttons:DockMargin( 15, 0, 15, 10 )
    self.Buttons.Paint = function() end

    if not PagerPanel.ReadOnly then
        self.Reply = vgui.Create( "DButton", self.Buttons )
        self.Reply:Dock( LEFT )
        self.Reply:SetText( "Reply" )
        self.Reply:SetWide( 100 )
        self.Reply:SetTextColor( color_white )
        self.Reply.Think = function()
            self.Reply:SetText( self.IsSender and "Follow Up" or "Reply" )
        end
        self.Reply.DoClick = function()
            PagerPanel:StartDraftingMessage( self.Message.Subject, self.IsSender and self.Message.Recipient or self.Message.Sender )
        end
    end

    self.CopyText = vgui.Create( "DButton", self.Buttons )
    self.CopyText:Dock( LEFT )
    self.CopyText:SetText( "Copy Text" )
    self.CopyText:SetWide( 100 )
    self.CopyText:SetTextColor( color_white )
    self.CopyText.DoClick = function()
        if not self.Message then return end
        SetClipboardText( self.Message.Content )
    end

    if not PagerPanel.ReadOnly then
        self.DeleteButton = vgui.Create( "DButton", self.Buttons )
        self.DeleteButton:Dock( LEFT )
        self.DeleteButton:SetText( "Delete" )
        self.DeleteButton:SetWide( 100 )
        self.DeleteButton:SetTextColor( color_white )
        self.DeleteButton.Think = function()
            if ( self.IsSender and self.Message.TrashedForSender == TRASHED_STATUS.TRASHED ) or ( not self.IsSender and self.Message.TrashedForRecipient == TRASHED_STATUS.TRASHED ) then
                self.DeleteButton:SetText( "Delete" )
            else
                self.DeleteButton:SetText( "Trash" )
            end
        end
        self.DeleteButton.DoClick = function()
            if ( self.IsSender and self.Message.TrashedForSender == TRASHED_STATUS.TRASHED ) or ( not self.IsSender and self.Message.TrashedForRecipient == TRASHED_STATUS.TRASHED ) then
                Derma_Query( "Are you sure you want to permanently delete this message?", "Delete Message",
                "Yes", function()
                    if not self.Message then return end
                    net.Start( "Pager.UpdateTrashedStatus" )
                    net.WriteUInt( self.Message.ID, 32 )
                    net.WriteUInt( TRASHED_STATUS.DELETED, 4 )
                    net.SendToServer()
                    PagerPanel:ReturnToInbox()
                    nut.util.notify( "You deleted a message" )
                end,
                "No" )
            else
                Derma_Query( "Are you sure you want to trash this message?", "Delete Message",
                "Yes", function()
                    if not self.Message then return end
                    net.Start( "Pager.UpdateTrashedStatus" )
                    net.WriteUInt( self.Message.ID, 32 )
                    net.WriteUInt( TRASHED_STATUS.TRASHED, 4 )
                    net.SendToServer()
                    PagerPanel:ReturnToInbox()
                    nut.util.notify( "You deleted a message" )
                end,
                "No" )
            end
        end
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

function PANEL:SetMessage( message )
    self.Message = message

    self.IsSender = LocalPlayer():getChar():getID() == message.Sender
    self.Content.Text:SetText( message.Content )
end

vgui.Register( "Pager.Entry", PANEL, "DPanel" )