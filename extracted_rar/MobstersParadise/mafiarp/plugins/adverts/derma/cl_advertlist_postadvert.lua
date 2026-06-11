-- "gamemodes\\mafiarp\\plugins\\adverts\\derma\\cl_advertlist_postadvert.lua"


local PLUGIN = PLUGIN
local PANEL = {}

local tierSelect

function PANEL:Init()
    self.SelectedTier = 1

    -- Author Line
    self.AuthorLine = vgui.Create( "DPanel", self )
    self.AuthorLine:Dock( TOP )
    self.AuthorLine:DockMargin( 15, 10, 15, 0 )
    self.AuthorLine:SetTall( 25 )
    self.AuthorLine.Paint = function() end

    self.AuthorLine.Label = vgui.Create( "DLabel", self.AuthorLine )
    self.AuthorLine.Label:Dock( LEFT )
    self.AuthorLine.Label:SetText( "Author" )
    self.AuthorLine.Label:DockMargin( 0, 0, 5, 0 )

    self.AuthorLine.Value = vgui.Create( "DTextEntry", self.AuthorLine )
    self.AuthorLine.Value:Dock( FILL )
    self.AuthorLine.Value:SetTextColor( Color( 200, 200, 200 ) )
    self.AuthorLine.Value:SetMaximumCharCount( 64 )
    self.AuthorLine.Value:SetEnabled( false )
    self.AuthorLine.Value:SetText( LocalPlayer():Nick() )

    -- Subject Line
    self.TitleLine = vgui.Create( "DPanel", self )
    self.TitleLine:Dock( TOP )
    self.TitleLine:DockMargin( 15, 5, 15, 0 )
    self.TitleLine:SetTall( 25 )
    self.TitleLine.Paint = function() end

    self.TitleLine.Label = vgui.Create( "DLabel", self.TitleLine )
    self.TitleLine.Label:Dock( LEFT )
    self.TitleLine.Label:SetText( "Subject" )
    self.TitleLine.Label:DockMargin( 0, 0, 5, 0 )

    self.TitleLine.Value = vgui.Create( "DTextEntry", self.TitleLine )
    self.TitleLine.Value:Dock( FILL )
    self.TitleLine.Value:SetTextColor( Color( 200, 200, 200 ) )
    self.TitleLine.Value:SetMaximumCharCount( 64 )

    -- URLEntry
    self.URLEntry = vgui.Create( "DPanel", self )
    self.URLEntry:Dock( TOP )
    self.URLEntry:DockMargin( 15, 5, 15, 0 )
    self.URLEntry:SetTall( 25 )
    self.URLEntry.Paint = function() end

    self.URLEntry.Label = vgui.Create( "DLabel", self.URLEntry )
    self.URLEntry.Label:Dock( LEFT )
    self.URLEntry.Label:SetText( "URL" )
    self.URLEntry.Label:DockMargin( 0, 0, 5, 0 )

    self.URLEntry.Value = vgui.Create( "DTextEntry", self.URLEntry )
    self.URLEntry.Value:Dock( FILL )
    self.URLEntry.Value:SetTextColor( Color( 200, 200, 200 ) )
    self.URLEntry.Value:SetNumeric( true )
    self.URLEntry.Value:SetMaximumCharCount( 128 )
    self.URLEntry.Value:SetPlaceholderText( "Optional" )
    self.URLEntry.Value.AllowInput = function( _, char )
        if not string.find( "abcdefghijklmnopqrstuvwxyz0123456789:/.?*+-,_~#!$", string.lower( char ), 1, true ) then
            return true
        end
    end

    -- Expiry
    self.Expiry = vgui.Create( "DPanel", self )
    self.Expiry:Dock( TOP )
    self.Expiry:DockMargin( 15, 5, 15, 0 )
    self.Expiry:SetTall( 27 )
    self.Expiry.Paint = function() end

    self.Expiry.Label = vgui.Create( "DLabel", self.Expiry )
    self.Expiry.Label:Dock( LEFT )
    self.Expiry.Label:SetText( "Expiry" )
    self.Expiry.Label:DockMargin( 0, 0, 5, 0 )

    self.Expiry.Value = vgui.Create( "DButton", self.Expiry )
    self.Expiry.Value:SetText( "" )
    self.Expiry.Value:Dock( FILL )
    self.Expiry.Value.PaintOver = function( _, w, h )
        local advertTier = PLUGIN.AdvertTiers[self.SelectedTier]
        draw.SimpleText( PLUGIN:GetFormattedTime( advertTier.Time ) .. " ($" .. string.Comma( advertTier.Investment ) .. ")", "DermaDefault", 6, h / 2, Color( 200, 200, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end
    self.Expiry.Value.DoClick = function()
        if tierSelect then
            tierSelect:Remove()
        end

        tierSelect = vgui.Create( "AdvertList.PostAdvert.TierSelect" )
        tierSelect.OnTierSelected = function( tier )
            self.SelectedTier = tier
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

    self.Post = vgui.Create( "DButton", self.Buttons )
    self.Post:Dock( LEFT )
    self.Post:SetText( "Post" )
    self.Post:SetWide( 100 )
    self.Post:SetTextColor( color_white )
    self.Post.DoClick = function()
        self:PostAdvert()
    end

    self.ErrorLabel = vgui.Create( "DLabel", self.Buttons )
    self.ErrorLabel:Dock( FILL )
    self.ErrorLabel:SetTextColor( Color( 255, 0, 0 ) )
    self.ErrorLabel:SetText( "" )
    self.ErrorLabel:DockMargin( 5, 0, 5, 0 )

    self.Cancel = vgui.Create( "DButton", self.Buttons )
    self.Cancel:Dock( RIGHT )
    self.Cancel:SetText( "Cancel" )
    self.Cancel:SetWide( 100 )
    self.Cancel:SetTextColor( color_white )
    self.Cancel.DoClick = function()
        PLUGIN.Panel:ReturnToOverview()
    end
end

function PANEL:PostAdvert()
    local author = self.AuthorLine.Value:GetValue()
    local title = self.TitleLine.Value:GetValue()
    local url = self.URLEntry.Value:GetValue()
    local contents = self.Contents.Text:GetValue()

    local function checkField( field, name, min, max )
        if not field then
            self.ErrorLabel:SetText( name .. " is required." )
            return false
        end

        local len = string.len( field )

        if len < min then
            self.ErrorLabel:SetText( name .. " must be at least " .. min .. " characters." )
            return false
        end

        if len > max then
            self.ErrorLabel:SetText( name .. " must be less than " .. max .. " characters." )
            return false
        end

        return true
    end

    if not checkField( author, "Author", 3, 128 ) or not checkField( title, "Title", 3, 64 ) or not checkField( contents, "Contents", 6, 1024 ) then
        return
    end

    if url and url ~= "" and not PLUGIN:IsValidURL( url ) then
        self.ErrorLabel:SetText( "Invalid URL. Only imgur links are allowed. Example: https://i.imgur.com/i9Jhe2b.png" )
        return
    end

    local advertTier = PLUGIN.AdvertTiers[self.SelectedTier]

    if not self.SelectedTier or not advertTier then
        self.ErrorLabel:SetText( "Invalid tier." )
        return
    end

    if LocalPlayer():getChar():getMoney() < advertTier.Investment then
        self.ErrorLabel:SetText( "You cannot afford that tier." )
        return
    end

    self.ErrorLabel:SetText( "" )

    net.Start( "Adverts.NewAdvert" )
    net.WriteUInt( self.SelectedTier, 16 )
    net.WriteString( title )
    net.WriteString( contents )
    net.WriteString( url or "" )
    net.SendToServer()

    PLUGIN.Panel:Close()
end

function PANEL:ClearValues()
    self.TitleLine.Value:SetText( "" )
    self.URLEntry.Value:SetText( "" )
    self.Contents.Text:SetText( "" )
    self.ErrorLabel:SetText( "" )
end

function PANEL:OnRemove()
    if tierSelect then
        tierSelect:Remove()
    end
end

vgui.Register( "AdvertList.PostAdvert", PANEL, "DPanel" )