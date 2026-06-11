-- "gamemodes\\mafiarp\\plugins\\adverts\\derma\\cl_advertlist_postadvert_tierselect.lua"


local PLUGIN = PLUGIN
local PANEL = {}

function PANEL:Init()
    self:SetSize( 270, 170 )
    self:MakePopup()
    self:Center()
    self:SetDraggable( false )
    self:SetBackgroundBlur( true )
    self:SetDrawOnTop( true )
    self:DoModal()
    self:SetTitle( "Select Expiry Date" )

    self.Tiers = vgui.Create( "DScrollPanel", self )
    self.Tiers:Dock( FILL )

    self:UpdateTiers()
end

function PANEL:UpdateTiers()
    if not PLUGIN.Panel then return end

    if self.TierPanels then
        for _, v in ipairs( self.TierPanels ) do
            v:Remove()
        end
    end

    self.TierPanels = {}

    for k, v in pairs( PLUGIN.AdvertTiers ) do
        local tier = vgui.Create( "DButton", self.Tiers )
        tier:Dock( TOP )
        tier:DockMargin( 5, 3, 5, 0 )
        tier:SetText( PLUGIN:GetFormattedTime( v.Time ) .. " ($" .. string.Comma( v.Investment ) .. ")" )
        tier:SetTall( 30 )
        tier.DoClick = function()
            if self.OnTierSelected then
                self.OnTierSelected( k )
                self:Remove()
            end
        end

        table.insert( self.TierPanels, tier )
    end
end

vgui.Register( "AdvertList.PostAdvert.TierSelect", PANEL, "DFrame" )