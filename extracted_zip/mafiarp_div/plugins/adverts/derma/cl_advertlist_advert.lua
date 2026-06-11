-- "gamemodes\\mafiarp\\plugins\\adverts\\derma\\cl_advertlist_advert.lua"


local PLUGIN = PLUGIN
local PANEL = {}

local openLinkMaterial = Material( "icon16/link_go.png" )

function PANEL:Init()
    -- Buttons
    self.Buttons = vgui.Create( "DPanel", self )
    self.Buttons:Dock( BOTTOM )
    self.Buttons:SetTall( 32 )
    self.Buttons:DockMargin( 15, 0, 15, 10 )
    self.Buttons.Paint = function() end

    self.CopyText = vgui.Create( "DButton", self.Buttons )
    self.CopyText:Dock( LEFT )
    self.CopyText:SetText( "Copy Text" )
    self.CopyText:SetWide( 100 )
    self.CopyText:SetTextColor( color_white )
    self.CopyText.DoClick = function()
        if self.Content and self.Content.Text then
            SetClipboardText( self.Content.Text:GetValue() )
        end
    end

    self.GoBack = vgui.Create( "DButton", self.Buttons )
    self.GoBack:Dock( RIGHT )
    self.GoBack:SetText( "Go Back" )
    self.GoBack:SetWide( 100 )
    self.GoBack:SetTextColor( color_white )
    self.GoBack.DoClick = function()
        PLUGIN.Panel:ReturnToOverview()
    end
end

function PANEL:SetAdvertInfo( advertInfo )
    self:ClearAdvertInfo()

    -- Title Line
    self.TitleLine = vgui.Create( "DPanel", self )
    self.TitleLine:Dock( TOP )
    self.TitleLine:DockMargin( 15, 10, 15, 0 )
    self.TitleLine:SetTall( 25 )
    self.TitleLine.Paint = function() end

    self.TitleLine.Label = vgui.Create( "DLabel", self.TitleLine )
    self.TitleLine.Label:Dock( LEFT )
    self.TitleLine.Label:SetText( "Title" )
    self.TitleLine.Label:DockMargin( 0, 0, 5, 0 )

    self.TitleLine.Value = vgui.Create( "DPanel", self.TitleLine )
    self.TitleLine.Value:Dock( FILL )
    self.TitleLine.Value.Paint = function( _, w, h )
        surface.SetDrawColor( 45, 45, 45, 240 )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( 0, 0, 0, 180 )
        surface.DrawOutlinedRect( 0, 0, w, h )

        surface.SetDrawColor( 100, 100, 100, 25 )
        surface.DrawOutlinedRect( 1,  1, w - 2, h - 2 )

        draw.SimpleText( advertInfo._title, "DermaDefault", 5, h / 2, Color( 200, 200, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end

    -- Author
    self.Author = vgui.Create( "DPanel", self )
    self.Author:Dock( TOP )
    self.Author:DockMargin( 15, 5, 15, 0 )
    self.Author:SetTall( 25 )
    self.Author.Paint = function() end

    self.Author.Label = vgui.Create( "DLabel", self.Author )
    self.Author.Label:Dock( LEFT )
    self.Author.Label:SetText( "Author" )
    self.Author.Label:DockMargin( 0, 0, 5, 0 )

    self.Author.Value = vgui.Create( "DPanel", self.Author )
    self.Author.Value:Dock( FILL )
    self.Author.Value.Paint = function( _, w, h )
        surface.SetDrawColor( 45, 45, 45, 240 )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( 0, 0, 0, 180 )
        surface.DrawOutlinedRect( 0, 0, w, h )

        surface.SetDrawColor( 100, 100, 100, 25 )
        surface.DrawOutlinedRect( 1,  1, w - 2, h - 2 )

        draw.SimpleText( advertInfo._author, "DermaDefault", 5, h / 2, Color( 200, 200, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end

    -- URL
    if PLUGIN:IsValidURL( advertInfo._url ) then
        self.URLPanel = vgui.Create( "DPanel", self )
        self.URLPanel:Dock( TOP )
        self.URLPanel:DockMargin( 15, 5, 15, 0 )
        self.URLPanel:SetTall( 25 )
        self.URLPanel.Paint = function() end

        self.URLPanel.Label = vgui.Create( "DLabel", self.URLPanel )
        self.URLPanel.Label:Dock( LEFT )
        self.URLPanel.Label:SetText( "URL" )
        self.URLPanel.Label:DockMargin( 0, 0, 5, 0 )

        self.URLPanel.Value = vgui.Create( "DPanel", self.URLPanel )
        self.URLPanel.Value:SetText( "" )
        self.URLPanel.Value:Dock( FILL )
        self.URLPanel.Value.Paint = function( _, w, h )
            surface.SetDrawColor( 45, 45, 45, 240 )
            surface.DrawRect( 0, 0, w, h )

            surface.SetDrawColor( 0, 0, 0, 180 )
            surface.DrawOutlinedRect( 0, 0, w, h )

            surface.SetDrawColor( 100, 100, 100, 25 )
            surface.DrawOutlinedRect( 1,  1, w - 2, h - 2 )

            draw.SimpleText( advertInfo._url, "DermaDefault", 5, h / 2, Color( 200, 200, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        end

        self.URLPanel.Button = vgui.Create( "DButton", self.URLPanel )
        self.URLPanel.Button:Dock( RIGHT )
        self.URLPanel.Button:SetWide( 25 )
        self.URLPanel.Button:SetText( "" )
        self.URLPanel.Button.PaintOver = function( _, w, h )
            surface.SetDrawColor( color_white )
            surface.SetMaterial( openLinkMaterial )
            surface.DrawTexturedRect( w / 2 - 8, h / 2 - 8, 16, 16 )
        end
        self.URLPanel.Button:SetTooltip( "Open URL" )
        self.URLPanel.Button.DoClick = function()
            if not advertInfo._url then return end
            PLUGIN:OpenURL( advertInfo._url )
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
    self.Content.Text:SetText( advertInfo._contents )
    self.Content.Text.PerformLayout = function()
        self.Content.Text:SetFontInternal( "DermaDefault" )
    end
end

function PANEL:ClearAdvertInfo()
    if self.TitleLine then
        self.TitleLine:Remove()
    end

    if self.Author then
        self.Author:Remove()
    end

    if self.URLPanel then
        self.URLPanel:Remove()
    end

    if self.Content then
        self.Content:Remove()
    end
end

vgui.Register( "AdvertList.Advert", PANEL, "DPanel" )