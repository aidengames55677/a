-- "gamemodes\\mafiarp\\plugins\\adverts\\derma\\cl_advertlist_overview.lua"


local PANEL = {}

function PANEL:Init()
    self.PropertySheet = vgui.Create( "DPropertySheet", self )
    self.PropertySheet:Dock( FILL )

    self.NewAdverts = vgui.Create( "AdvertList.Overview.Adverts", self )
    self.NewAdverts:Dock( FILL )
    self.NewAdverts:SetVisible( true )

    self.PopularAdverts = vgui.Create( "AdvertList.Overview.Adverts", self )
    self.PopularAdverts:Dock( FILL )
    self.PopularAdverts:SetVisible( false )

    self.PropertySheet:AddSheet( "New Adverts", self.NewAdverts )
    self.PropertySheet:AddSheet( "Popular Adverts", self.PopularAdverts )
end

function PANEL:PopulateAdverts( adverts )
    local recentAdverts, popularAdverts = table.Copy( adverts ), table.Copy( adverts )

    table.sort( recentAdverts, function( a, b )
        return a._timestamp > b._timestamp
    end )

    table.sort( popularAdverts, function( a, b )
        return a._investment > b._investment
    end )

    self.NewAdverts:PopulateEntries( recentAdverts )
    self.PopularAdverts:PopulateEntries( popularAdverts )
end

function PANEL:RefreshAdverts( filter )
    if self.NewAdverts and self.NewAdverts.Adverts then
        self.NewAdverts:PopulateEntries( nil, filter )
    end

    if self.PopularAdverts and self.PopularAdverts.Adverts then
        self.PopularAdverts:PopulateEntries( nil, filter )
    end
end

function PANEL:Paint()
end

vgui.Register( "AdvertList.Overview", PANEL, "EditablePanel" )