-- "gamemodes\\mafiarp\\plugins\\adverts\\derma\\cl_advertlist_overview_adverts_item.lua"


local PLUGIN = PLUGIN
local PANEL = {}

local trashMaterial = Material( "icon16/bin.png" )
local openTextMaterial = Material( "icon16/page.png" )
local openLinkMaterial = Material( "icon16/link_go.png" )
local noLinkMaterial = Material( "icon16/link_break.png" )

function PANEL:Init()
    self:SetTall( 30 )

    self.AuthorButton = vgui.Create( "DButton", self )
    self.AuthorButton:Dock( LEFT )
    self.AuthorButton:SetText( "Anonymous" )
    self.AuthorButton:SetTextColor( color_white )
    self.AuthorButton:SetWide( 135 )
    self.AuthorButton.DoClick = function()
        self:OpenAdvert()
    end

    self.TitleButton = vgui.Create( "DButton", self )
    self.TitleButton:Dock( FILL )
    self.TitleButton:SetText( "[no subject]" )
    self.TitleButton:SetTextColor( color_white )
    self.TitleButton:SetWide( 275 )
    self.TitleButton.DoClick = function()
        self:OpenAdvert()
    end

    self.OpenURLButton = vgui.Create( "DButton", self )
    self.OpenURLButton:Dock( RIGHT )
    self.OpenURLButton:SetWide( 30 )
    self.OpenURLButton:SetText( "" )
    self.OpenURLButton.PaintOver = function( _, w, h )
        surface.SetDrawColor( self.OpenURLButton:IsEnabled() and color_white or ColorAlpha( color_white, 35 ) )
        surface.SetMaterial( self.OpenURLButton:IsEnabled() and openLinkMaterial or noLinkMaterial )
        surface.DrawTexturedRect( w / 2 - 8, h / 2 - 8, 16, 16 )
    end
    self.OpenURLButton:SetTooltip( "Open URL" )
    self.OpenURLButton.DoClick = function()
        if not self.URL then return end
        PLUGIN:OpenURL( self.URL )
    end

    local openPageButton = vgui.Create( "DButton", self )
    openPageButton:Dock( RIGHT )
    openPageButton:SetWide( 30 )
    openPageButton:SetText( "" )
    openPageButton.PaintOver = function( _, w, h )
        surface.SetDrawColor( color_white )
        surface.SetMaterial( openTextMaterial )
        surface.DrawTexturedRect( w / 2 - 8, h / 2 - 8, 16, 16 )
    end
    openPageButton:SetTooltip( "Show Text" )
    openPageButton.DoClick = function()
        self:OpenAdvert()
    end

    if false then -- TODO: Only show trash for advert creator and admins.
        self.TrashButton = vgui.Create( "DButton", self )
        self.TrashButton:Dock( RIGHT )
        self.TrashButton:SetWide( 30 )
        self.TrashButton:SetText( "" )
        self.TrashButton.PaintOver = function( _, w, h )
            surface.SetDrawColor( color_white )
            surface.SetMaterial( trashMaterial )
            surface.DrawTexturedRect( w / 2 - 8, h / 2 - 8, 16, 16 )
        end
        self.TrashButton:SetTooltip( "Trash" )
        self.TrashButton.DoClick = function()

        end
    end
end

function PANEL:SetAdvert( advert )
    self.ID = advert._id
    self.AuthorButton:SetText( advert._author )
    self.TitleButton:SetText( advert._title )

    local validUrl = PLUGIN:IsValidURL( advert._url )
    self.OpenURLButton:SetEnabled( validUrl )
    self.OpenURLButton:SetTooltip( validUrl and "Open URL" or nil )

    if validUrl then
        self.URL = advert._url
    end
end

function PANEL:OpenAdvert()
    if not self.ID then return end

    net.Start( "Adverts.OpenAdvert" )
    net.WriteUInt( self.ID, 32 )
    net.SendToServer()

    PLUGIN.Panel:OpenAdvert()
end

function PANEL:Think()
    local hovering = self.AuthorButton:IsHovered() or self.TitleButton:IsHovered()

    self.AuthorButton.Hovered = hovering
    self.TitleButton.Hovered = hovering
end

vgui.Register( "AdvertList.Overview.Adverts.Item", PANEL, "EditablePanel" )