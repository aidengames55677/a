-- "gamemodes\\mafiarp\\plugins\\npctrading\\derma\\cl_itemsview.lua"


local PANEL = {}

function PANEL:Init()
    self:MakePopup()
    self:SetSize( 350, 550 )
    self:SetDrawOnTop( true )
    self:DoModal()
    self:SetDraggable( false )
    self:ShowCloseButton( false )
    self:Center()
    self:SetTitle( "Items List" )

    self.ListView = vgui.Create( "DListView", self )
    self.ListView:Dock( FILL )
    self.ListView:AddColumn( "Name" )
    self.ListView:AddColumn( "ID" )

    for k, v in pairs( nut.item.list ) do
        self.ListView:AddLine( v.name, k )
    end

    self.ListView.OnRowSelected = function( _, _, row )
        if not isfunction( self.OnSelectItem ) then return end
        self:OnSelectItem( row:GetValue( 2 ) )
        self:Close()
    end

    self.ListView:SortByColumn( 1 )

    self.CancelButton = vgui.Create( "DButton", self )
    self.CancelButton:Dock( BOTTOM )
    self.CancelButton:SetText( "Cancel" )
    self.CancelButton:SetTall( 30 )
    self.CancelButton:DockMargin( 5, 5, 5, 5 )
    self.CancelButton.DoClick = function()
        self:Close()
    end
end

function PANEL:Paint( w, h )
    draw.RoundedBox( 0, 0, 0, w, h, Color( 45, 45, 45 ) )
end

vgui.Register( "NPCTrading.ItemsView", PANEL, "DFrame" )