-- "gamemodes\\mafiarp\\plugins\\pager\\derma\\cl_pager.lua"


-- UI
local PLUGIN = PLUGIN
local PANEL = {}

local optionsMenu

function PANEL:Init()
    self:SetSize( 700, 480 )
    self:MakePopup()
    self:Center()
    self:SetTitle( "Pager" )
end

function PANEL:InitializeInfo( readOnly )
    self.ReadOnly = tobool( readOnly )

    self.Inbox = vgui.Create( "Pager.Inbox", self )
    self.Inbox:Dock( FILL )
    self.Inbox:SetVisible( true )

    self.Entry = vgui.Create( "Pager.Entry", self )
    self.Entry:Dock( FILL )
    self.Entry:SetVisible( false )

    self.Draft = vgui.Create( "Pager.Draft", self )
    self.Draft:Dock( FILL )
    self.Draft:SetVisible( false )

    self.Contacts = vgui.Create( "Pager.Contacts", self )
    self.Contacts:Dock( FILL )
    self.Contacts:SetVisible( false )

    self.Buttons = vgui.Create( "DPanel", self )
    self.Buttons:Dock( BOTTOM )
    self.Buttons:SetTall( 40 )
    self.Buttons:DockMargin( 0, 5, 0, 0 )
    self.Buttons.Paint = function() end

    if not readOnly then
        self.SendButton = vgui.Create( "DButton", self.Buttons )
        self.SendButton:Dock( LEFT )
        self.SendButton:SetText( "Send Message" )
        self.SendButton:SetWide( 100 )
        self.SendButton:SetTextColor( color_white )
        self.SendButton.DoClick = function()
            self:StartDraftingMessage()
        end

        self.ContactsButton = vgui.Create( "DButton", self.Buttons )
        self.ContactsButton:Dock( LEFT )
        self.ContactsButton:SetText( "Contacts" )
        self.ContactsButton:SetWide( 100 )
        self.ContactsButton:SetTextColor( color_white )
        self.ContactsButton.DoClick = function()
            self:OpenContacts()
        end

        self.OptionsButton = vgui.Create( "DButton", self.Buttons )
        self.OptionsButton:Dock( LEFT )
        self.OptionsButton:SetText( "Options" )
        self.OptionsButton:SetWide( 100 )
        self.OptionsButton:SetTextColor( color_white )
        self.OptionsButton.DoClick = function()
            if optionsMenu then
                optionsMenu:Remove()
            end

            optionsMenu = vgui.Create( "Pager.Options" )
        end
    end

    self.CloseButton = vgui.Create( "DButton", self.Buttons )
    self.CloseButton:Dock( RIGHT )
    self.CloseButton:SetText( "Close" )
    self.CloseButton:SetWide( 100 )
    self.CloseButton:SetTextColor( color_white )
    self.CloseButton.DoClick = function()
        PLUGIN:ClosePager()
    end

    self.Search = vgui.Create( "DTextEntry", self.Buttons )
    self.Search:Dock( FILL )
    self.Search:DockMargin( 10, 5, 10, 5 )
    self.Search.OnChange = function()
        self.Inbox:RefreshMessages( self.Search:GetValue() )
        if self.Contacts.ContactsTable then
            self.Contacts:SetContacts( self.Contacts.ContactsTable, self.Search:GetValue() )
        end
    end
end

function PANEL:OpenItem( message )
    if not message then return end

    self.Entry:SetVisible( true )
    self.Entry:SetMessage( message )

    self.Inbox:SetVisible( false )
    self.Draft:SetVisible( false )
    self.Contacts:SetVisible( false )
end

function PANEL:ReturnToInbox()
    self.Inbox:SetVisible( true )
    self.Entry:SetVisible( false )
    self.Draft:SetVisible( false )
    self.Contacts:SetVisible( false )

    self.Draft:ClearValues()
    self.Search:SetValue( "" )
    self.Search:OnChange()
end

function PANEL:StartDraftingMessage( subject, recipient )
    self.Inbox:SetVisible( false )
    self.Entry:SetVisible( false )
    self.Draft:SetVisible( true )
    self.Contacts:SetVisible( false )

    if subject and recipient then
        self.Draft.SubjectLine.Value:SetText( "re: " .. tostring( subject ) )
        self.Draft.Recipient.Value:SetText( tostring( recipient ) )
        self.Draft.Contents.Text:SetText( "" )
    end
end

function PANEL:OpenContacts()
    self.Inbox:SetVisible( false )
    self.Entry:SetVisible( false )
    self.Draft:SetVisible( false )
    self.Contacts:SetVisible( true )
    self.Search:SetValue( "" )
    self.Search:OnChange()
end

function PANEL:InitializeMessages( messages )
    self.Messages = messages
    self.Inbox.Overview:SetMessages( messages.Received )
    self.Inbox.Sent:SetMessages( messages.Sent )
    self.Inbox.Trash:SetMessages( messages )
end

function PANEL:InitializeContacts( contacts )
    self.ContactsTable = contacts
    self.Contacts:SetContacts( contacts )
end

function PANEL:Think()
    if input.IsKeyDown( KEY_ESCAPE ) then
        PLUGIN:ClosePager()
        RunConsoleCommand( "cancelselect" )
    end
end

function PANEL:OnRemove()
    if optionsMenu then
        optionsMenu:Remove()
    end
    PagerPanel = nil
end

vgui.Register( "Pager", PANEL, "DFrame" )