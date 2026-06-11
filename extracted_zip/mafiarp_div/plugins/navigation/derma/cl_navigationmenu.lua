-- "gamemodes\\mafiarp\\plugins\\navigation\\derma\\cl_navigationmenu.lua"

surface.CreateFont( "Navigation.Font", {
	font = "Open 24 Display St",
	extended = false,
	size = 64,
	weight = 0,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

local locations = {
    ["Police Station"] = Vector( 7358.828125, 7906.062988, 249.890900 ),
    ["Clothing Store"] = Vector( -2080.275635, 10885.531250, 192.031250 ),
    ["Bank"] = Vector( -1510.959106, 2057.274902, -39.968750 ),
    ["Gun Store"] = Vector( -1541.531250, 10432.136719, 200.031250 ),
    ["Hospital"] = Vector( 7414.340332, 4641.147461, 0.031250 ),
    ["Car Dealership"] = Vector( -7172.570313, 1261.010742, 24.031250 ),
    ["Docks"] = Vector( 5209.477051, -5109.213379, -255.968750 ),
}

local PANEL = {}

function PANEL:AdjustLocation( direction )
    self.active_index = self.active_index + direction

    if self.active_index > table.Count( self.locations ) then
        self.active_index = 1
    end

    if self.active_index == 0 then
        self.active_index = table.Count( self.locations )
    end

	local location_name = self.location_keys[ self.active_index ]
    local location_vector = self.locations[ location_name ]

    self.display:SetText( location_name )
    self.active_loc = location_vector
end

function PANEL:Init()
    self:SetTitle( "" )
    self:SetSize( 1535 * 0.5, 1054 * 0.5 )
    self:Center()
    self:ShowCloseButton( false )
    self:MakePopup()
    self.Paint = function( self, w, h )
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial( Material( "diverge/beeper.png" ) )
        surface.DrawTexturedRect( 0, 0, w, h )
    end

    self.locations = locations
    self.location_keys = {}
    self.active_index = 1
    self.active_loc = ""

    for key in pairs( self.locations ) do
        table.insert( self.location_keys, key )
    end

    self.start = self:Add( "DButton" )
    self.start:SetSize( 150, 35 )
    self.start:SetPos( 65, 280 )
    self.start:SetText( "" )
    self.start.Paint = function() end
    self.start.DoClick = function( this )
        local location_name = self.location_keys[ self.active_index ]
        local location_vector = self.locations[ location_name ]
        LocalPlayer():SetWeighPoint( location_name, location_vector )
		nut.util.notify( location_name .. " has been marked on your screen." )
        surface.PlaySound( "diverge/nav_start.mp3" )
        self:Close()
    end

    
    self.close = self:Add( "DButton" )
    self.close:SetSize( 150, 35 )
    self.close:SetPos( 65 + 150 + 5, 280 )
    self.close:SetText( "" )
    self.close.Paint = function() end
    self.close.DoClick = function( this )
        for k, v in pairs( hook.GetTable()["HUDPaint"] ) do
            if isstring( k ) and string.find( k, "WeighPoint" ) then
                hook.Remove( "HUDPaint", k )
            end
        end
        surface.PlaySound( "diverge/gen_pocket.mp3" )
        self:Close()
    end

    self.display = self:Add( "DLabel" )
    self.display:SetSize( 400, 200 )
    self.display:SetPos( 160, 55 )
    self.display:SetContentAlignment( 5 )
    self.display:SetFont( "Navigation.Font" )
    self.display:SetText( "Gun Store" )
    self.display:SetColor( Color( 0, 0, 0 ) )

    self.rightButton = self:Add( "DButton" )
    self.rightButton:SetSize( 75, 150 )
    self.rightButton:SetPos( 650, 310 )
    self.rightButton:SetText( "" )
    self.rightButton.Paint = function() end
    self.rightButton.DoClick = function( this )
        surface.PlaySound( "diverge/gen_click.mp3" )
        self:AdjustLocation( 1 )
    end

    self.leftButton = self:Add( "DButton" )
    self.leftButton:SetSize( 75, 150 )
    self.leftButton:SetPos( 415, 310 )
    self.leftButton:SetText( "" )
    self.leftButton.Paint = function() end
    self.leftButton.DoClick = function( this )
        surface.PlaySound( "diverge/gen_click.mp3" )
        self:AdjustLocation( -1 )
    end

    self.arrowRight = self:Add( "DButton" )
    self.arrowRight:SetSize( 25, 25 )
    self.arrowRight:SetPos( 607, 147 )
    self.arrowRight:SetText( "" )
    self.arrowRight.Paint = function() end
    self.arrowRight.DoClick = function( this )
        surface.PlaySound( "diverge/gen_click.mp3" )
        self:AdjustLocation( 1 )
    end

    self.arrowLeft = self:Add( "DButton" )
    self.arrowLeft:SetSize( 25, 25 )
    self.arrowLeft:SetPos( 80, 147 )
    self.arrowLeft:SetText( "" )
    self.arrowLeft.Paint = function() end
    self.arrowLeft.DoClick = function( this )
        surface.PlaySound( "diverge/gen_click.mp3" )
        self:AdjustLocation( -1 )
    end
end

vgui.Register( "Navigation.Menu", PANEL, "DFrame" )