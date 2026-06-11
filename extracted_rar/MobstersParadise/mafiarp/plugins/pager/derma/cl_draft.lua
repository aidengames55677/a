-- "gamemodes\\mafiarp\\plugins\\pager\\derma\\cl_draft.lua"


local PANEL = {}

local selectContact

function PANEL:Init()
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

    self.SubjectLine.Value = vgui.Create( "DTextEntry", self.SubjectLine )
    self.SubjectLine.Value:Dock( FILL )
    self.SubjectLine.Value:SetTextColor( Color( 200, 200, 200 ) )
    self.SubjectLine.Value:SetMaximumCharCount( 64 )

    -- Recipient
    self.Recipient = vgui.Create( "DPanel", self )
    self.Recipient:Dock( TOP )
    self.Recipient:DockMargin( 15, 5, 15, 0 )
    self.Recipient:SetTall( 25 )
    self.Recipient.Paint = function() end

    self.Recipient.Label = vgui.Create( "DLabel", self.Recipient )
    self.Recipient.Label:Dock( LEFT )
    self.Recipient.Label:SetText( "Recipient" )
    self.Recipient.Label:DockMargin( 0, 0, 5, 0 )

    self.Recipient.Value = vgui.Create( "DTextEntry", self.Recipient )
    self.Recipient.Value:Dock( FILL )
    self.Recipient.Value:SetTextColor( Color( 200, 200, 200 ) )
    self.Recipient.Value:SetNumeric( true )
    self.Recipient.Value:SetMaximumCharCount( 512 )
    self.Recipient.Value.AllowInput = function( _, char )
        if not string.find( "0123456789, ", char, 1, true ) then
            return true
        end
    end

    self.Recipient.Contacts = vgui.Create( "DButton", self.Recipient )
    self.Recipient.Contacts:Dock( RIGHT )
    self.Recipient.Contacts:SetText( "Select Contact" )
    self.Recipient.Contacts:SetWide( 100 )
    self.Recipient.Contacts:DockMargin( 5, 0, 5, 0 )
    self.Recipient.Contacts.DoClick = function()
        if selectContact then
            selectContact:Remove()
        end
    
        selectContact = vgui.Create( "Pager.SelectContact" )
        selectContact.Recipient = self.Recipient
        selectContact.OnContactSelected = function( contact )
            local existingContacts = self.Recipient.Value:GetText()
            if existingContacts ~= "" then
                existingContacts = existingContacts .. ", "
            end
            self.Recipient.Value:SetText(existingContacts .. contact)
        end
    end

    -- Contents
    self.Contents = vgui.Create( "DPanel", self )
    self.Contents:Dock( FILL )
    self.Contents:DockMargin( 15, 10, 15, 5 )

    self.Contents.Text = vgui.Create( "DTextEntry", self.Contents )
    self.Contents.Text:Dock( FILL )
    self.Contents.Text:DockMargin( 5, 5, 5, 5 )
    self.Contents.Text:SetVerticalScrollbarEnabled( false )
    self.Contents.Text:SetTextColor( Color( 200, 200, 200 ) )
    self.Contents.Text:SetMultiline( true )
    self.Contents.Text:SetText( "" )
    self.Contents.Text:SetMaximumCharCount( Pager.max_content_size - 1 )
    self.Contents.Text.Paint = function( textEntry, w, h )
        textEntry:DrawTextEntryText( textEntry:GetTextColor(), textEntry:GetHighlightColor(), textEntry:GetCursorColor() )
    end

    -- Buttons
    self.Buttons = vgui.Create( "DPanel", self )
    self.Buttons:Dock( BOTTOM )
    self.Buttons:SetTall( 32 )
    self.Buttons:DockMargin( 15, 0, 15, 10 )
    self.Buttons.Paint = function() end

    self.Send = vgui.Create( "DButton", self.Buttons )
    self.Send:Dock( LEFT )
    self.Send:SetText( "Send" )
    self.Send:SetWide( 100 )
    self.Send:SetTextColor( color_white )
    self.Send.DoClick = function()
        self:SendMessage()
    end

    self.SendError = vgui.Create( "DLabel", self.Buttons )
    self.SendError:Dock( FILL )
    self.SendError:SetTextColor( Color( 255, 0, 0 ) )
    self.SendError:SetText( "" )
    self.SendError:DockMargin( 5, 0, 5, 0 )

    self.Cancel = vgui.Create( "DButton", self.Buttons )
    self.Cancel:Dock( RIGHT )
    self.Cancel:SetText( "Cancel" )
    self.Cancel:SetWide( 100 )
    self.Cancel:SetTextColor( color_white )
    self.Cancel.DoClick = function()
        if not PagerPanel then return end
        self.SendError:SetText( "" )
        PagerPanel:ReturnToInbox()
    end
end

function PANEL:SendMessage()
    local subject = self.SubjectLine.Value:GetValue()
    local recipients = self.Recipient.Value:GetValue()
    local contents = self.Contents.Text:GetValue()

    if not subject or string.len( subject ) < 1 or string.len( subject ) > 64 then
        self.SendError:SetText( "Invalid subject." )
        return
    end

    if not recipients or string.len( recipients ) < 1 then
        self.SendError:SetText( "Invalid recipient." )
        return
    end

    if recipient == LocalPlayer():getChar():getID() then
        self.SendError:SetText( "You cannot send a message to yourself." )
        return
    end

    if not contents or string.len( contents ) < 1 or string.len( contents ) > Pager.max_content_size then
        self.SendError:SetText( "Invalid message contents." )
        return
    end

    self.SendError:SetText( "" )

    net.Start( "Pager.MessageSendRequest" )
    net.WriteString( subject )
    net.WriteString( recipients )
    net.WriteString( contents )
    net.SendToServer()

    nut.util.notify( "You sent a message" )

    PagerPanel:ReturnToInbox()
end

function PANEL:ClearValues()
    self.SubjectLine.Value:SetText( "" )
    self.Recipient.Value:SetText( "" )
    self.Contents.Text:SetText( "" )
    self.SendError:SetText( "" )
end

function PANEL:OnRemove()
    if selectContact then
        selectContact:Remove()
    end
end

vgui.Register( "Pager.Draft", PANEL, "DPanel" )