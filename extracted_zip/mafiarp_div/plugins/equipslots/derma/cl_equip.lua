local PANEL = {}
local PLUGIN = PLUGIN
local PANEL_WIDE = ScrW() / 4
local PANEL_HEIGHT = ScrH() / 3

function PANEL:Init()
	self:SetTitle( L"equipSlot" )
	self:SetSize( ScrW() / 3.5, ScrH() / 3 )
	
	self.model = self:Add( "nutModelPanel" )
	self.model:SetWide( ScrW() * 0.25 )
	self.model:Dock( LEFT )
	self.model:SetFOV( 80 )
	self.model.enableHook = true
	self.model.copyLocalSequence = true
	self.model:SetModel( LocalPlayer():GetModel() )
	
	hook.Run( "OnCharInfoSetup", self )

	self.slots = {}
	local x, y = 4, 28
	local reachedOtherSide
	for id, data in ipairs( PLUGIN.equipSlots ) do
		if y + 68 > self:GetTall() then
			x = x + 68
			y = 28
		end
		
		if x + 68 > self:GetWide() / 2 and not reachedOtherSide then
			x = self:GetWide() - self:GetWide() / 3
			reachedOtherSide = true
		end
	
		local slot = self:Add( "NSEquipSlot" )
		slot.slotIcon = data.icon
		slot.slotType = data.slot
		slot:SetSize( data.w or 48, data.h or 48 )
		slot:SetPos( data.x or x, data.y or y )

		for _, item in next, LocalPlayer():getChar():getInv():getItems() do
			if item.usesEquipSlot and item.slot == slot.slotType and item:getData( "equip" ) then
				slot:setItem( item )
			end
		end
		
		table.insert( self.slots, slot )
		y = y + 68
	end

	local function createButton( self, text, icon, tooltip, posy, options, posx )
		local button = self:Add( "DButton" )
		button:SetText( "" )
		button:SetSize( 48, 48 )
		button:SetPos( posx or self:GetWide() - 58, posy )
		button:SetIcon( icon )
		button.nutToolTip = true
		button.itemTable = { getName = function() return text end, getDesc = function() return tooltip end }
		button.updateTooltip = function( self )
			self:SetTooltip( "<font=nutItemBoldFont>"..self.itemTable:getName().."</font>\n"..
							"<font=nutItemDescFont>"..self.itemTable:getDesc() )
		end
		button:updateTooltip()
		button.DoRightClick = function() 
			local menu = DermaMenu()
			for _, option in ipairs( options ) do
				if option.onCanRun() then
					menu:AddOption( option.name, option.onRun ):SetImage( option.icon )
				end
			end
			menu:Open()
		end
	end

	local buttons = {
		{
			name = "Navigator",
			icon = "diverge/beepericon.png",
			tooltip = "A beeper to help you get around the city",
			options = {
				{
					name = "Open Navigator", 
					onRun = function()
						vgui.Create( "Navigation.Menu" )
					end, 
					onCanRun = function()
						return true
					end
				},
			}
		},
		{
			name = "ID",
			icon = "diverge/idicon.png",
			tooltip = "A flat piece of plastic for identification.",
			options = {
				{
					name = "View", 
					onRun = function()
						local ply = LocalPlayer()
						if ply:Team() and ply:Team() == FACTION_POLICE then
							local pnl = vgui.Create( "SWCharInfoDisplayPolice" )
							pnl:setCharacter( ply, id )
						else
							local pnl = vgui.Create( "SWCharInfoDisplay" )
							pnl:setCharacter( ply, id )
						end
					end, 
					onCanRun = function()
						return true
					end
				},
				{
					name = "Show",
					icon = "icon16/user.png", 
					onRun = function( item )
						nut.util.notify( 'To show your ID, hold C whilst looking at someone, and click the "Show ID" option.' )
					end, 
					onCanRun = function()
						return true
					end
				},
			}
		},
		{
			name = "Pager",
			icon = "diverge/pagericon.png",
			tooltip = "A wireless telecommunication device that can receive and send messages.",
			options = {
				{
					name = "Use Pager", 
					icon = "icon16/phone_add.png", 
					onRun = function()
						surface.PlaySound( "tools/ifm/beep.wav" )
						RunConsoleCommand( "pager_open" )
					end, 
					onCanRun = function()
						return nut.plugin.list.pager:HasPager( LocalPlayer() )
					end
				},
				{
					name = "View Info", 
					icon = "icon16/information.png", 
					onRun = function()
						surface.PlaySound( "garrysmod/content_downloaded.wav")
						gui.OpenURL( "https://divergenet.works/forums/showthread.php?tid=5773" )
					end, 
					onCanRun = function()
						return true
					end
				},
			}
		},
		{
			name = "Newspaper",
			icon = "diverge/adverticon.png",
			tooltip = "Newspaper containing advertisements from around the city.",
			options = {
				{
					name = "View", 
					onRun = function()
						RunConsoleCommand( "adverts_open" )
					end, 
					onCanRun = function()
						return true
					end
				},
			}
		},
		{
			name = "Notepad",
			icon = "diverge/notesicon1.png",
			tooltip = "Used for storing personal notes.",
			options = {
				{
					name = "View", 
					onRun = function()
						local frame = vgui.Create( 'DFrame' )
						frame:SetSize( 385, ScrH() / 2 )
						frame:Center()
						frame:MakePopup()
						frame:SetTitle( 'My Notes' )
				
						frame.Save = frame:Add( 'DButton' )
						frame.Save:Dock( BOTTOM )
						frame.Save:SetText( 'Save Notes' )
				
						frame.Save.DoClick = function()
							if string.len( frame.TextBox:GetText() ) > 8000 then
								nut.util.notify( 'Your notes cannot be longer than 8000 characters!' )
								return
							end
				
							nut.util.notify( "Your notes have been saved." )
							net.Start( 'nutSaveNotes' )
								net.WriteString( frame.TextBox:GetText() )
							net.SendToServer()
						end
				
						frame.TextBox = frame:Add( 'DTextEntry' )
						frame.TextBox:Dock( FILL )
						frame.TextBox:SetMultiline( true )
						frame.TextBox:SetText( LocalPlayer():getChar():getData('notes', '') )
					end, 
					onCanRun = function()
						return true
					end
				},
			}
		},
	}

	for i, button in ipairs( buttons ) do
		createButton( self, button.name, button.icon, button.tooltip, 58 + (i - 1) * 48, button.options )
	end

	local medalsButton = {
		name = "Medals/Pins",
		icon = "diverge/medalicon.png",
		tooltip = "View and take off your medals or pins.",
		options = {}
	}

	for _, item in pairs( LocalPlayer():getChar():getInv():getItems() ) do
		if item.base == "base_medals" and item:getData( "equip" ) then
			table.insert( medalsButton.options, {
				name = "Take off " .. item:getName(),
				icon = "icon16/award_star_delete.png",
				onRun = function()
					local inventory = LocalPlayer():getChar():getInv()
					netstream.Start( "invAct", "unWear", item:getID(), inventory:getID() )
					if not inventory:findFreePosition( item ) then return end
					for k, option in pairs( medalsButton.options ) do
						if option.name == "Take off " .. item:getName() then
							table.remove( medalsButton.options, k )
							break
						end
					end
				end,
				onCanRun = function()
					return true
				end
			} )
		end
	end

	createButton( self, medalsButton.name, medalsButton.icon, medalsButton.tooltip, PANEL_HEIGHT / 4.5 - 80 + 10, medalsButton.options, PANEL_WIDE / 2 - 26.5 )
end

vgui.Register( "NSEquipMenu", PANEL, "DFrame" )
