-- "gamemodes\\mafiarp\\plugins\\police\\entities\\entities\\armory_police2\\cl_init.lua"

include( "shared.lua" )

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

	drawText("Special Police Armory", x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 0.65)

	--if (desc) then
		--drawText("I need some tasks done you up for em'?", x, y + 16, colorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
	--end
end

net.Receive( "armory_menu_police2", function()
	local locker_frame = vgui.Create("DFrame")
	locker_frame:SetTitle("Special Police Armory");
	locker_frame:SetSize(580, ScrH() * 0.7)
	locker_frame:SetSizable(false);
	locker_frame:SetDraggable(false);
	locker_frame:ShowCloseButton(true);
	locker_frame:Center()
	locker_frame:MakePopup()

	local panel3 = vgui.Create("DScrollPanel", locker_frame)
	panel3:Dock(FILL)

	local category = panel3:Add("DCollapsibleCategory")
	category:SetLabel("Items:")
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


for k, v in pairs( nut.plugin.list.police.Lockers.Police2.Selections ) do
local pistol = category.list:Add( "DPanel" )
pistol:SetPos( 95, 75 ) 
pistol:SetSize( 200, 65 )

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

local equip_button = vgui.Create( "DButton" , pistol )
equip_button:Dock(RIGHT)
equip_button:DockMargin(5, 5, 5, 5)
equip_button:SetText( "Equip" )
if v.Price then
	equip_button:SetText("Take ($"..v.Price..")")
end
equip_button:SetSize( 70, 40 )
equip_button.DoClick = function()

	
			net.Start("Armory_Take")
				net.WriteString("Police2")
				net.WriteString(k)
			net.SendToServer()

end
end

end)
