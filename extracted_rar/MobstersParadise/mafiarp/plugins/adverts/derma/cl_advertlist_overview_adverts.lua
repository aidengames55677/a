-- "gamemodes\\mafiarp\\plugins\\adverts\\derma\\cl_advertlist_overview_adverts.lua"


local PANEL = {}

function PANEL:Init()
    local headers = vgui.Create( "DPanel", self )
    headers:Dock( TOP )
    headers.Paint = function( _, w, h )
        draw.SimpleText( "Author", "DermaDefault", w * 0.12, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.SimpleText( "Title", "DermaDefault", w * 0.555, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    self.Items = {}
end

function PANEL:PopulateEntries( adverts, filter )
    if not adverts then
        if not self.Adverts then return end
        adverts = self.Adverts
    else
        self.Adverts = adverts
    end

    for k, v in ipairs( self.Items ) do
        if IsValid( v ) then
            v:Remove()
        end
    end

    self.Items = {}

    for _, v in ipairs( adverts ) do
        if filter and filter ~= ""
        and not string.find( string.lower( v._author ), string.lower( filter ) )
        and not string.find( string.lower( tostring( v._title ) ), string.lower( filter ) ) then
            continue
        end

        local item = vgui.Create( "AdvertList.Overview.Adverts.Item", self )
        item:Dock( TOP )
        item:DockMargin( 5, 3, 5, 0 )
        item:SetAdvert( v )

        table.insert( self.Items, item )
    end
end

vgui.Register( "AdvertList.Overview.Adverts", PANEL, "DScrollPanel" )