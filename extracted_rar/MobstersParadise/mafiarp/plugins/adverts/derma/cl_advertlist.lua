-- "gamemodes\\mafiarp\\plugins\\adverts\\derma\\cl_advertlist.lua"


local PLUGIN = PLUGIN
local PANEL = {}

function PANEL:Init()
    self:SetSize( 620, 450 )
    self:MakePopup()
    self:Center()
    self:SetTitle( "Advert Board" )
end

function PANEL:InitializeInfo( adverts, canPost )
    self.CanPost = canPost

    self.Overview = vgui.Create( "AdvertList.Overview", self )
    self.Overview:Dock( FILL )
    self.Overview:SetVisible( true )
    self.Overview:PopulateAdverts( adverts )

    self.PostAdvert = vgui.Create( "AdvertList.PostAdvert", self )
    self.PostAdvert:Dock( FILL )
    self.PostAdvert:SetVisible( false )

    self.Advert = vgui.Create( "AdvertList.Advert", self )
    self.Advert:Dock( FILL )
    self.Advert:SetVisible( false )

    self.Buttons = vgui.Create( "DPanel", self )
    self.Buttons:Dock( BOTTOM )
    self.Buttons:SetTall( 40 )
    self.Buttons:DockMargin( 0, 5, 0, 0 )
    self.Buttons.Paint = function() end

    if self.CanPost then
        self.PostAdvertButton = vgui.Create( "DButton", self.Buttons )
        self.PostAdvertButton:Dock( LEFT )
        self.PostAdvertButton:SetText( "Post Advert" )
        self.PostAdvertButton:SetWide( 100 )
        self.PostAdvertButton:SetTextColor( color_white )
        self.PostAdvertButton.DoClick = function()
            if os.time() > LocalPlayer():getChar():getData( "canPostAdvertAgain", 0 ) then
                self:OpenPostAdvert()
            else
                nut.util.notify( "You cannot post an advert for another: " .. string.ToMinutesSeconds( LocalPlayer():getChar():getData( "canPostAdvertAgain", 0 ) - os.time() ) .. "!" )
            end
        end
    end

    self.CloseButton = vgui.Create( "DButton", self.Buttons )
    self.CloseButton:Dock( RIGHT )
    self.CloseButton:SetText( "Close" )
    self.CloseButton:SetWide( 100 )
    self.CloseButton:SetTextColor( color_white )
    self.CloseButton.DoClick = function()
        self:Close()
    end

    self.Search = vgui.Create( "DTextEntry", self.Buttons )
    self.Search:Dock( FILL )
    self.Search:DockMargin( 10, 5, 10, 5 )
    self.Search.OnChange = function()
        self.Overview:RefreshAdverts( self.Search:GetValue() )
    end
end

function PANEL:ReturnToOverview()
    self.Overview:SetVisible( true )
    self.PostAdvert:SetVisible( false )
    self.Advert:SetVisible( false )
    self.Advert:ClearAdvertInfo()
end

function PANEL:OpenPostAdvert()
    self.Overview:SetVisible( false )
    self.PostAdvert:SetVisible( true )
    self.Advert:SetVisible( false )
    self.Advert:ClearAdvertInfo()
end

function PANEL:OpenAdvert()
    self.Overview:SetVisible( false )
    self.PostAdvert:SetVisible( false )
    self.Advert:SetVisible( true )
end

function PANEL:Think()
    if input.IsKeyDown( KEY_ESCAPE ) then
        self:Close()
        RunConsoleCommand( "cancelselect" )
    end
end

function PANEL:OnRemove()
    PLUGIN.Panel = nil
end

vgui.Register( "AdvertList", PANEL, "DFrame" )