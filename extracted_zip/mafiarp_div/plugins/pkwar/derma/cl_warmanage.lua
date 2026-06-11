-- "gamemodes\\mafiarp\\plugins\\pkwar\\derma\\cl_warmanage.lua"


local PLUGIN = PLUGIN
local PANEL = {}

function PANEL:Init()
    self:SetTitle( "War Management" )
    self:SetSize( ScrW() * 0.3, ScrH() * 0.4 )
    self:Center()
    self:MakePopup()

    self.WarList = self:Add( "DListView" )
    self.WarList:Dock( FILL )
    self.WarList:SetZPos( 1 )
    self.WarList:AddColumn( "ID" )
    self.WarList:AddColumn( "Name" )
    function self.WarList.DoDoubleClick( _, lineID, line )
        local warID = line.WarID

        self:GetWarInfo( warID )
    end

    self.NewWar = self:Add( "DButton" )
    self.NewWar:SetText( "New" )
    self.NewWar:Dock( BOTTOM )
    self.NewWar:SetZPos( 2 )
    self.NewWar:DockMargin( 0, 4, 0, 0 )
    self.NewWar.DoClick = function( btn )
        self.WarList:ClearSelection()
        self:CreateWar()
    end

    self:PopulateWarList()

    PLUGIN.WarManagement = self
end

function PANEL:GetWarInfo( id )
    if not IsValid( self.WarInfo ) then
        self.WarInfo = vgui.Create( "FactionWars.WarInfo" )

        local _, posY = self:GetPos()

        self:SetPos( ScrW() / 2 - ( ( self:GetWide() + self.WarInfo:GetWide() ) / 2 ), posY )
        self.WarInfo:SetPos( ScrW() / 2 - ( ( self:GetWide() + self.WarInfo:GetWide() ) / 2 ) + self.WarInfo:GetWide() + 2, posY )
        self.WarInfo:InvalidateLayout( true )
    end

    self.WarInfo:PopulateWarInfo( id )
end

function PANEL:PopulateWarList()
    local list = self.WarList
    list:Clear()

    for k, war in pairs( PLUGIN.Wars ) do
        local line = list:AddLine( war.ID, war.Name )
        line.WarID = war.ID
    end
end

function PANEL:CreateWar()
    if not IsValid( self.WarInfo ) then
        self.WarInfo = vgui.Create( "FactionWars.WarInfo" )

        local _, posY = self:GetPos()

        self:SetPos( ScrW() / 2 - ( ( self:GetWide() + self.WarInfo:GetWide() ) / 2 ), posY )
        self.WarInfo:SetPos( ScrW() / 2 - ( ( self:GetWide() + self.WarInfo:GetWide() ) / 2 ) + self.WarInfo:GetWide() + 2, posY )
        self.WarInfo:InvalidateLayout( true )
    end

    self.WarInfo:CreateWar()
end

function PANEL:OnClose()
    if IsValid( self.WarInfo ) then
        self.WarInfo:Close()
    end
end

hook.Add( "FactionWars.WarsSynced", "FactionWars.UI.WarsSynced", function()
    if IsValid( PLUGIN.WarManagement ) then
        PLUGIN.WarManagement:PopulateWarList()
    end
end )

vgui.Register( "FactionWars.ManageWars", PANEL, "DFrame" )