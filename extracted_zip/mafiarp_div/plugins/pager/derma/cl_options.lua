-- "gamemodes\\mafiarp\\plugins\\pager\\derma\\cl_options.lua"


local PANEL = {}

function PANEL:Init()
    self:SetSize( 270, 190 )
    self:MakePopup()
    self:Center()
    self:SetDraggable( false )
    self:SetBackgroundBlur( true )
    self:SetDrawOnTop( true )
    self:DoModal()
    self:SetTitle( "Options" )

    self.DiscordHelpInfo = vgui.Create( "DButton", self )
    self.DiscordHelpInfo:Dock( FILL )
    self.DiscordHelpInfo:SetText( "" )
    self.DiscordHelpInfo.Paint = function( _, w, h )
        if not PagerPanel.DiscordToken then return end
        draw.DrawText( "Use the code below to link your\nDiscord account to the pager system.", "DermaDefault", w / 2, h * 0.1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.DrawText( PagerPanel.DiscordToken, "Trebuchet24", w / 2, h * 0.4, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.DrawText( "Left click to copy.\nDM the code to Diverge#4768 in !discord.", "DermaDefault", w / 2, h * 0.7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    self.DiscordHelpInfo.DoClick = function()
        if not PagerPanel.DiscordToken then return end
        SetClipboardText( PagerPanel.DiscordToken )
    end

    self.CloseButton = vgui.Create( "DButton", self )
    self.CloseButton:Dock( BOTTOM )
    self.CloseButton:DockMargin( 5, 5, 5, 5 )
    self.CloseButton:SetTall( 30 )
    self.CloseButton:SetTextColor( color_white )
    self.CloseButton:SetText( "Close" )
    self.CloseButton.DoClick = function()
        self:Remove()
    end
end

vgui.Register( "Pager.Options", PANEL, "DFrame" )