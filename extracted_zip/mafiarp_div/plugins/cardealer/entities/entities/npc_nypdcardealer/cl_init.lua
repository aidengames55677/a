-- "gamemodes\\mafiarp\\plugins\\cardealer\\entities\\entities\\npc_nypdcardealer\\cl_init.lua"

include( "shared.lua" )

local TEXT_OFFSET = Vector(0, 0, 20)
local toScreen = FindMetaTable("Vector").ToScreen
local colorAlpha = ColorAlpha
local drawText = nut.util.drawText
local configGet = nut.config.get
local PLUGIN = PLUGIN
    
ENT.DrawEntityInfo = true

function ENT:onDrawEntityInfo(alpha)
	local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self)) + TEXT_OFFSET)
	local x, y = position.x, position.y

	drawText("Sergeant Andrew Bullock", x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 0.65)
	drawText("Need to take out a car?", x, y + 16, colorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
end

surface.CreateFont( "Title_Font", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 30,
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

surface.CreateFont( "Price_Font", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 20,
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

surface.CreateFont( "Vehicle_Font", {
	font = "Times New Roman",
	size = 22,
	weight = 800,
	antialias = true,
} )

ENT.NPC_INFORMATION = {
	name = "Andrew Bullock",
	profession = "Sergeant ; New York Police Department",
	model = "models/portal/nycpd/nycpdmale_04.mdl",
}
ENT.NPC_CONVERSATION = {
	opening = {
		response = "Hello Officer, what can I do for you?",
		options = {
			"just_looking",
			"spawn_vehicle",
			"buy_vehicle",
			"sell_vehicle",
			"exit",
		},
	},
	just_looking = {
		dialog = "Nothing, just looking around.",
		response = "Sure, feel free to ask any questions if you have them.",
	},
	spawn_vehicle = {
		dialog = "I'd like to spawn my vehicle.",
		response = "Interact with the brown Garage Platforms outside, there you can store and retrieve your vehicle.",
		options = {
			"okay_thanks",
		}
	},
	buy_vehicle = {
		dialog = "I'd like to buy a vehicle.",
		response = "What kind of vehicle you interested in?",
		callback = function(panel, key)
			local dialogData = panel.conversations[key]
			panel:ClearDialogOptions()

			panel:SetText((isfunction(dialogData.response) and dialogData.response(panel, key)) or dialogData.response or "")

			for _,type in ipairs(PLUGIN.Vehicle_Categories) do
                if !string.find(type, "NYPD") then continue end
				panel:AddDialogOption(type, type, function()
					local self = vgui.Create("DFrame")
					self:SetTitle("NYPD Vehicles - " .. type)
					self:SetSize(ScrW()-450,ScrH()-350)
					self:Center()
					self:MakePopup()
					self:ShowCloseButton(true)

					self.scroll = vgui.Create("DScrollPanel", self)
					self.scroll:Dock(FILL)

					self.category = self.scroll:Add("DCollapsibleCategory")
					self.category:SetLabel(type)
					self.category:Dock(TOP)
					self.category:SetExpanded(1)
					self.category.Paint = function( self, w, h ) 
						self:SetBGColor(Color(0,0,0,1))
					end

					self.category.panel = vgui.Create("DPanel", self.category)
					self.category.panel:Dock(FILL)

					self.category.list = vgui.Create("DListLayout", self.category.panel)
					self.category.list:Dock(FILL)
					self.category.list:DockPadding(3, 3, 3, 3)

					self.category:SetContents(self.category.list)

					self.scroll:AddItem(self.category)

					for k, v in pairs(nut.plugin.list.cardealer.Vehicles) do
						if v.Category == type then
							self.item = self.category.list:Add("DPanel")
							self.item:SetTall(70)

							self.spawnIcon = vgui.Create("nutSpawnIcon", self.item)
							self.spawnIcon:Dock(LEFT)
							self.spawnIcon:SetSize(48, 48)
							self.spawnIcon:SetModel(v.Model)

							self.name = vgui.Create("DLabel", self.item)
							self.name:SetPos(56, 25)
							self.name:SetFont("Title_Font")
							self.name:SetText(v.Name)
							self.name:SizeToContents()

							self.buyBox = vgui.Create("DPanel", self.item)
							self.buyBox:Dock(RIGHT)
							self.buyBox:DockMargin(1, 1, 1, 1)
							self.buyBox:SetWide(90)
							self.buyBox:SetDrawBackground(false)
							
							self.price = vgui.Create("DButton", self.buyBox)
							self.price:Dock(TOP)
							self.price:SetText("$" .. (v.Price or 50))
							self.price:SetFont("Price_Font")
							self.price:SetTextColor( Color(125, 125, 125, 225) )
							self.price:DockMargin(0, 5, 5, 0)
							self.price:SetDrawBackground(false)

							self.buy = vgui.Create("DButton", self.buyBox)
							self.buy:Dock(BOTTOM)
							self.buy:DockMargin(0, 0, 5, 3)
							self.buy:SetSize(100, 35)
							self.buy:SetText("Buy")
							self.buy.DoClick = function()
								Derma_Query("Are you sure you want to buy "..v.Name.." for $"..v.Price.."?","Buy Confirmation","Yes",function()
									net.Start("buy_vehicle")
										net.WriteString(k)
									net.SendToServer()

									self:Close()
								end, "No", function() end)
							end
						end
					end

					panel:Close()
				end)
			end

			panel:AddDialogOption("Err, nevermind.", "nevermind", function(panel)
				panel:ClearDialogOptions()
				panel:BackToOpening()
			end)
		end
	},
	sell_vehicle = {
		dialog = "I'd like to sell one of my vehicles.",
		response = "Sure, let's take a look.",
		callback = function(panel, key)
			local dialogData = panel.conversations[key]
			panel:ClearDialogOptions()

			panel:SetText((isfunction(dialogData.response) and dialogData.response(panel, key)) or dialogData.response or "")

			for _,vehicle in next, PLUGIN.loaded_vehicles do
				if vehicle:getData("in_use") then continue end

				local veh_info = PLUGIN.Vehicles[vehicle:GetClass()]
				if !veh_info.NYPD then continue end

				panel:AddDialogOption(veh_info.Name .. " - "..nut.currency.symbol.. veh_info.Price/10, veh_info.Name, function()
					Derma_Query("Are you sure you want to sell "..veh_info.Name.." for $".. veh_info.Price/10 .."?","Sell Confirmation","Yes",function()
						net.Start("sell_vehicle")
							net.WriteUInt(vehicle:GetID(), 32)
						net.SendToServer()

						panel:Close()
					end, "No", function() end)
				end)
			end

			panel:AddDialogOption("Err, nevermind.", "nevermind", function(panel)
				panel:ClearDialogOptions()
				panel:BackToOpening()
			end)
		end
	},
	okay_thanks = {
		dialog = "Okay, thanks.",
		response = "My pleasure.",
	},
	exit = {
		dialog = "Exit",
		callback = function(panel, key)
			panel:Close()
		end,
	},
}

net.Receive("ui_dealership_nypd",function()
	if LocalPlayer():GetEyeTrace().Entity:GetClass() != "npc_nypdcardealer" then return false end
	
    local ent = net.ReadEntity()

    local dialog = vgui.Create("hdNPCDialog")
    dialog:SetTitle(ent.NPC_INFORMATION.name.." - "..ent.NPC_INFORMATION.profession)
    dialog:AddDialogOptions(ent.NPC_CONVERSATION)
    dialog:SetModel(ent.NPC_INFORMATION.model)
end)