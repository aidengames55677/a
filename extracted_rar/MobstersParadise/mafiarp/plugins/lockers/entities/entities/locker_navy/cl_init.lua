include( "shared.lua" )

	local origin = Vector(-2070.984131, -3154.441162, 4016.031250) -- location of the npc

	local TEXT_OFFSET = Vector(0, 0, -20)
	local toScreen = FindMetaTable("Vector").ToScreen
	local colorAlpha = ColorAlpha
	local drawText = nut.util.drawText
	local configGet = nut.config.get
	
		ENT.DrawEntityInfo = true

	function ENT:onDrawEntityInfo(alpha)
		local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self)) + TEXT_OFFSET)
		local x, y = position.x, position.y
		--local desc = self.getNetVar(self, "desc")

		drawText("FBI Supply Locker", x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 0.65)

		--if (desc) then
			--drawText("I need some tasks done you up for em'?", x, y + 16, colorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
		--end
	end
	
	MissionCoolDown = false

net.Receive( "locker_menu_navy", function()

surface.CreateFont( "Title_Font", {
	font = "Times New Roman", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 28,
	weight = 500,
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

surface.CreateFont( "Desc_Font", {
	font = "Times New Roman", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 16,
	weight = 500,
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

local locker_frame = vgui.Create("DFrame")
locker_frame:SetTitle("Navy Supply Locker");
locker_frame:SetSize(580, ScrH() * 0.7)
locker_frame:SetSizable(false);
locker_frame:SetDraggable(false);
locker_frame:ShowCloseButton(true);
locker_frame:Center()
locker_frame:MakePopup()

	local panel3 = vgui.Create("DScrollPanel", locker_frame)
	panel3:Dock(FILL)

	local category = panel3:Add("DCollapsibleCategory")
	category:SetLabel("Items")
	category:Dock(TOP)
	category:SetExpanded(1)
	category.Paint = function( self, w, h ) 
			 category:SetBGColor(Color(0,0,0,1))
		 end
	
		category.panel = vgui.Create("DPanel", category)
		category.panel:Dock(FILL)

		category.list = vgui.Create("DListLayout", category.panel)
		category.list:Dock(FILL)
		category.list:DockPadding(3, 3, 3, 3)

		category:SetContents(category.list)

		panel3:AddItem(category)	


for k, v in pairs( Locker_List_Navy ) do
local pistol = category.list:Add( "DPanel" )
pistol:SetPos( 95, 75 ) 
pistol:SetSize( 200, 65 )
--list_panel:AddItem( pistol )

local item_model = vgui.Create( "SpawnIcon" , pistol )
item_model:SetPos( 1, 1 )
item_model:SetSize( 60, 60 )
item_model:SetModel( v.Model ) 

local item_title = vgui.Create( "DLabel", pistol )
item_title:SetText( v.Name )
item_title:SetPos( 90, 10 )
item_title:SetDark( true )
item_title:SetFont( "Title_Font" )
item_title:SetDark(false)
item_title:SizeToContents()

local item_desc = vgui.Create( "DLabel", pistol )
item_desc:SetText( v.Description )
item_desc:SetPos( 90, 35 )
item_desc:SetDark( true )
item_desc:SetFont( "Desc_Font" )
item_desc:SetDark(false)
item_desc:SizeToContents()

local equip_button = vgui.Create( "DButton" , pistol )
equip_button:Dock(RIGHT)
equip_button:DockMargin(5, 5, 5, 5)
equip_button:SetText( "Equip" )
equip_button:SetSize( 70, 40 )
equip_button.DoClick = function()


	locker_frame:Close()
	
	net.Start( "Mission_Start_222", LocalPlayer() )
		net.WriteString( k )
	net.SendToServer()

end
end

end)

