-- "gamemodes\\mafiarp\\plugins\\cardealer\\libs\\cl_cardealer.lua"

local PLUGIN = PLUGIN

/*
	Commands
*/

nut.command.add("checkplates", {
	syntax = "",
	onRun = function(client, arguments)
	end
})

/*
	Other
*/

hd = hd or {}

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

PLUGIN.NPC_INFORMATION = {
	name = "Paul McCormick",
	profession = "Car Salesman; Brooklyn Motors",
	model = "models/Humans/Group02/male_08.mdl",
}
PLUGIN.NPC_CONVERSATION = {
	opening = {
		response = "Ay pal, welcome to Brooklyn Motors, what can I do for ya?",
		options = {
			"just_looking",
			"spawn_vehicle",
			"buy_vehicle",
			"sell_vehicle",
			"test_drive",
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
				if string.find(type, "NYPD") then continue end
				panel:AddDialogOption(type, type, function()
					local self = vgui.Create("DFrame")
					self:SetTitle("Brooklyn Motors - " .. type)
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
	test_drive = {
		dialog = "I'd like to test drive a vehicle.",
		response = "No problem, just point one out and I'll get the keys.",
		callback = function(panel, key)
			local dialogData = panel.conversations[key]
			panel:ClearDialogOptions()

			panel:SetText((isfunction(dialogData.response) and dialogData.response(panel, key)) or dialogData.response or "")

			for _,type in ipairs(PLUGIN.Vehicle_Categories) do
				if string.find(type, "NYPD") then continue end
				panel:AddDialogOption(type, type, function()
					local self = vgui.Create("DFrame")
					self:SetTitle("Brooklyn Motors - " .. type)
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
							self.buy:SetText("Test Drive")
							self.buy.DoClick = function()
								net.Start("testdrive_vehicle")
									net.WriteString(k)
								net.SendToServer()

								self:Close()
							end
						end
					end

					panel:Close()
				end)
			end
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

net.Receive("ui_dealership",function(len)
	local plugin = nut.plugin.list.cardealer
	local dialog = vgui.Create("hdNPCDialog")
	dialog:SetTitle(plugin.NPC_INFORMATION.name.." - "..plugin.NPC_INFORMATION.profession)
	dialog:AddDialogOptions(plugin.NPC_CONVERSATION)
	dialog:SetModel(plugin.NPC_INFORMATION.model)
end)

net.Receive("garage_ui", function(len)

	local MaxW = ScrW() * .4
	local MaxH = ScrH() * .2
	local platform = net.ReadEntity()

	self = vgui.Create("DFrame")
	self:SetTitle("Jackson Autos")
	if player.GetCount() > nut.config.get("cars_deleteplayercount", 75) then
		self:SetSize(300,240)
	else
		self:SetSize(300,130)
	end
	self:Center()
	self:MakePopup()

	self.button = vgui.Create("DButton", self)
	self.button:SetText("Spawn or Return Vehicle")
	self.button:SetTall(50)
	self.button:Dock(TOP)
	self.button:SetTextColor(Color(255,255,255,255))
	self.button.DoClick = function()

		self:Remove()

		self = vgui.Create("DFrame")
		self:SetTitle("Purchased Vehicles")
		self:SetSize(ScrW()-450,ScrH()-350)
		self:Center()
		self:MakePopup()
		self:ShowCloseButton(true)

		self.scroll = vgui.Create("DScrollPanel", self)
		self.scroll:Dock(FILL)

		self.category = self.scroll:Add("DCollapsibleCategory")
		self.category:SetLabel("Vehicles")
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

		for id,vehicle in next, nut.plugin.list.cardealer.loaded_vehicles do
			if vehicle:getOwner() == LocalPlayer() then
				local v = nut.plugin.list.cardealer.Vehicles[vehicle:GetClass()]
				if v.NYPD then continue end

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

				if !vehicle:getData("in_use") then
					self.spawn = vgui.Create("DButton", self.buyBox)
					self.spawn:Dock(BOTTOM)
					self.spawn:DockMargin(0, 0, 5, 3)
					self.spawn:SetSize(100, 60)
					self.spawn:SetText("Spawn")
					self.spawn.DoClick = function()
						net.Start("spawn_vehicle")
							net.WriteUInt(vehicle:GetID(), 32)
						net.SendToServer()

						self:Close()
					end
				else
					self.returnVehicle = vgui.Create("DButton", self.buyBox)
					self.returnVehicle:Dock(BOTTOM)
					self.returnVehicle:DockMargin(0, 0, 5, 3)
					self.returnVehicle:SetSize(100, 60)
					self.returnVehicle:SetText("Return")
					self.returnVehicle.DoClick = function()
						net.Start("return_vehicle")
							net.WriteUInt(vehicle:GetID(), 32)
						net.SendToServer()

						self:Close()
					end
				end
			end
		end	
	end

	self.button = vgui.Create("DButton", self)
	self.button:SetText("Modify / Repair Vehicle")
	self.button:SetTall(50)
	self.button:Dock(TOP)
	self.button:SetTextColor(Color(255,255,255,255))
	self.button.DoClick = function()

		self:Remove()

		self = vgui.Create("DFrame")
		self:SetTitle("Jackson Autos - Modification Options")
		self:SetSize(300,130)

		self:Center()
		self:MakePopup()


		self.button = vgui.Create("DButton", self)
		self.button:SetText("Customise")
		self.button:SetTall(50)
		self.button:Dock(TOP)
		self.button:SetTextColor(Color(255,255,255,255))
		self.button.DoClick = function()

			self:Remove()

			self = vgui.Create("DFrame")
			self:SetTitle("Purchased Vehicles")
			self:SetSize(ScrW()-450,ScrH()-350)
			self:Center()
			self:MakePopup()
			self:ShowCloseButton(true)

			self.scroll = vgui.Create("DScrollPanel", self)
			self.scroll:Dock(FILL)

			self.category = self.scroll:Add("DCollapsibleCategory")
			self.category:SetLabel("Vehicles")
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

			for id,vehicle in next, nut.plugin.list.cardealer.loaded_vehicles do
				if vehicle:getOwner() == LocalPlayer() then
					local v = nut.plugin.list.cardealer.Vehicles[vehicle:GetClass()]
					if v.NYPD then continue end
					
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

					self.buy = vgui.Create("DButton", self.buyBox)
					self.buy:Dock(BOTTOM)
					self.buy:DockMargin(0, 0, 5, 3)
					self.buy:SetSize(100, 60)
					self.buy:SetText("Customise")
					self.buy.DoClick = function()
						// If the car is out, don't allow changing it
						if vehicle:getData("in_use") then
							nut.util.notify("You cannot modify your car when it is in use!")
							return
						end

						self:Remove()

						local data = {}
						for k, option in pairs(nut.plugin.list.carcustomisation.TypeToName) do
							data[option] = vehicle:getData(option, nut.plugin.list.carcustomisation.Defaults[option])
						end

						nut.gui.garagemenu = vgui.Create("nsvehCustomMenu")
						nut.gui.garagemenu.vehicleClass = v.Identifier
						nut.gui.garagemenu.vehicleData = data
						nut.gui.garagemenu.vehicleID = vehicle:GetID()
						nut.gui.garagemenu.vehicleModel = v.Model
						nut.gui.garagemenu:PopulateCategories()
						nut.gui.garagemenu:CreateCSModel()
					end
				end
			end
		end

		self.button = vgui.Create("DButton", self)
		self.button:SetText("Repair Vehicle ($50)")
		self.button:SetTall(50)
		self.button:Dock(TOP)
		self.button:SetTextColor(Color(255,255,255,255))
		self.button.DoClick = function()
			net.Start("repair_vehicle")
			net.SendToServer()
		end
	end

	self.button = vgui.Create("DButton", self)
	self.button:SetText("Open Trunk")
	self.button:SetTall(50)
	self.button:Dock(TOP)
	self.button:SetTextColor(Color(255,255,255,255))
	self.button.DoClick = function()

		self:Remove()

		self = vgui.Create("DFrame")
		self:SetTitle("Purchased Vehicles")
		self:SetSize(ScrW()-450,ScrH()-350)
		self:Center()
		self:MakePopup()
		self:ShowCloseButton(true)

		self.scroll = vgui.Create("DScrollPanel", self)
		self.scroll:Dock(FILL)

		self.category = self.scroll:Add("DCollapsibleCategory")
		self.category:SetLabel("Vehicles")
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

		for id,vehicle in next, nut.plugin.list.cardealer.loaded_vehicles do
			if vehicle:getOwner() == LocalPlayer() then
				local v = nut.plugin.list.cardealer.Vehicles[vehicle:GetClass()]
				if v.NYPD then continue end

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

				self.buy = vgui.Create("DButton", self.buyBox)
				self.buy:Dock(BOTTOM)
				self.buy:DockMargin(0, 0, 5, 3)
				self.buy:SetSize(100, 60)
				self.buy:SetText("Open Trunk")
				self.buy.DoClick = function()
					self:Remove()

					net.Start("vehicleTrunkView")
						net.WriteUInt(vehicle:GetID(), 32)
					net.SendToServer()
					self:Remove()
				end
			end
		end
	end
end)

net.Receive("garage_ui_nypd", function(len)

	local MaxW = ScrW() * .4
	local MaxH = ScrH() * .2
	local platform = net.ReadEntity()

	self = vgui.Create("DFrame")
	self:SetTitle("NYPD Garage")
	if player.GetCount() > nut.config.get("cars_deleteplayercount", 75) then
		self:SetSize(300,240)
	else
		self:SetSize(300,130)
	end
	self:Center()
	self:MakePopup()

	self.button = vgui.Create("DButton", self)
	self.button:SetText("Spawn or Return Vehicle")
	self.button:SetTall(50)
	self.button:Dock(TOP)
	self.button:SetTextColor(Color(255,255,255,255))
	self.button.DoClick = function()

		self:Remove()

		self = vgui.Create("DFrame")
		self:SetTitle("Purchased Vehicles")
		self:SetSize(ScrW()-450,ScrH()-350)
		self:Center()
		self:MakePopup()
		self:ShowCloseButton(true)

		self.scroll = vgui.Create("DScrollPanel", self)
		self.scroll:Dock(FILL)

		self.category = self.scroll:Add("DCollapsibleCategory")
		self.category:SetLabel("Vehicles")
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

		for id,vehicle in next, nut.plugin.list.cardealer.loaded_vehicles do
			if vehicle:getOwner() == LocalPlayer() then
				local v = nut.plugin.list.cardealer.Vehicles[vehicle:GetClass()]
				if !v.NYPD then continue end

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

				if !vehicle:getData("in_use") then
					self.spawn = vgui.Create("DButton", self.buyBox)
					self.spawn:Dock(BOTTOM)
					self.spawn:DockMargin(0, 0, 5, 3)
					self.spawn:SetSize(100, 60)
					self.spawn:SetText("Spawn")
					self.spawn.DoClick = function()
						net.Start("spawn_vehicle")
							net.WriteUInt(vehicle:GetID(), 32)
						net.SendToServer()

						self:Close()
					end
				else
					self.returnVehicle = vgui.Create("DButton", self.buyBox)
					self.returnVehicle:Dock(BOTTOM)
					self.returnVehicle:DockMargin(0, 0, 5, 3)
					self.returnVehicle:SetSize(100, 60)
					self.returnVehicle:SetText("Return")
					self.returnVehicle.DoClick = function()
						net.Start("return_vehicle")
							net.WriteUInt(vehicle:GetID(), 32)
						net.SendToServer()

						self:Close()
					end
				end
			end
		end	
	end

	self.button = vgui.Create("DButton", self)
	self.button:SetText("Modify / Repair Vehicle")
	self.button:SetTall(50)
	self.button:Dock(TOP)
	self.button:SetTextColor(Color(255,255,255,255))
	self.button.DoClick = function()

		self:Remove()

		self = vgui.Create("DFrame")
		self:SetTitle("Jackson Autos - Modification Options")
		self:SetSize(300,130)

		self:Center()
		self:MakePopup()


		self.button = vgui.Create("DButton", self)
		self.button:SetText("Customise")
		self.button:SetTall(50)
		self.button:Dock(TOP)
		self.button:SetTextColor(Color(255,255,255,255))
		self.button.DoClick = function()

			self:Remove()

			self = vgui.Create("DFrame")
			self:SetTitle("Purchased Vehicles")
			self:SetSize(ScrW()-450,ScrH()-350)
			self:Center()
			self:MakePopup()
			self:ShowCloseButton(true)

			self.scroll = vgui.Create("DScrollPanel", self)
			self.scroll:Dock(FILL)

			self.category = self.scroll:Add("DCollapsibleCategory")
			self.category:SetLabel("Vehicles")
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

			for id,vehicle in next, nut.plugin.list.cardealer.loaded_vehicles do
				if vehicle:getOwner() == LocalPlayer() then
					local v = nut.plugin.list.cardealer.Vehicles[vehicle:GetClass()]
					if !v.NYPD then continue end
					
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

					self.buy = vgui.Create("DButton", self.buyBox)
					self.buy:Dock(BOTTOM)
					self.buy:DockMargin(0, 0, 5, 3)
					self.buy:SetSize(100, 60)
					self.buy:SetText("Customise")
					self.buy.DoClick = function()
						// If the car is out, don't allow changing it
						if vehicle:getData("in_use") then
							nut.util.notify("You cannot modify your car when it is in use!")
							return
						end

						self:Remove()

						local data = {}
						for k, option in pairs(nut.plugin.list.carcustomisation.TypeToName) do
							data[option] = vehicle:getData(option, nut.plugin.list.carcustomisation.Defaults[option])
						end

						nut.gui.garagemenu = vgui.Create("nsvehCustomMenu")
						nut.gui.garagemenu.vehicleClass = v.Identifier
						nut.gui.garagemenu.vehicleData = data
						nut.gui.garagemenu.vehicleID = vehicle:GetID()
						nut.gui.garagemenu.vehicleModel = v.Model
						nut.gui.garagemenu:PopulateCategories()
						nut.gui.garagemenu:CreateCSModel()
					end
				end
			end
		end

		self.button = vgui.Create("DButton", self)
		self.button:SetText("Repair Vehicle ($50)")
		self.button:SetTall(50)
		self.button:Dock(TOP)
		self.button:SetTextColor(Color(255,255,255,255))
		self.button.DoClick = function()
			net.Start("repair_vehicle")
			net.SendToServer()
		end
	end

	self.button = vgui.Create("DButton", self)
	self.button:SetText("Open Trunk")
	self.button:SetTall(50)
	self.button:Dock(TOP)
	self.button:SetTextColor(Color(255,255,255,255))
	self.button.DoClick = function()

		self:Remove()

		self = vgui.Create("DFrame")
		self:SetTitle("Purchased Vehicles")
		self:SetSize(ScrW()-450,ScrH()-350)
		self:Center()
		self:MakePopup()
		self:ShowCloseButton(true)

		self.scroll = vgui.Create("DScrollPanel", self)
		self.scroll:Dock(FILL)

		self.category = self.scroll:Add("DCollapsibleCategory")
		self.category:SetLabel("Vehicles")
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

		for id,vehicle in next, nut.plugin.list.cardealer.loaded_vehicles do
			if vehicle:getOwner() == LocalPlayer() then
				local v = nut.plugin.list.cardealer.Vehicles[vehicle:GetClass()]
				if !v.NYPD then continue end

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

				self.buy = vgui.Create("DButton", self.buyBox)
				self.buy:Dock(BOTTOM)
				self.buy:DockMargin(0, 0, 5, 3)
				self.buy:SetSize(100, 60)
				self.buy:SetText("Open Trunk")
				self.buy.DoClick = function()
					self:Remove()

					net.Start("vehicleTrunkView")
						net.WriteUInt(vehicle:GetID(), 32)
					net.SendToServer()
					self:Remove()
				end
			end
		end
	end
end)

function PLUGIN:OnEntityCreated(ent)
	if ent:GetClass() == "gmod_sent_vehicle_fphysics_base" then
		ent.hasMenu = true
	end
end

function PLUGIN:ItemShowEntityMenu(ent)
	if ent.IsSimfphyscar then
		for k, v in ipairs(nut.menu.list) do
			if (v.entity == ent) then
				table.remove(nut.menu.list, k)
			end
		end

		if LocalPlayer():InVehicle() then return false end

		local options = {}

		if ent:GetNW2Int("VehicleID") > 0 then
			if !input.IsShiftDown() then
				net.Start("vehicleAction")
					net.WriteString("getIn")
					net.WriteUInt(ent:GetNW2Int("VehicleID"), 32)
				net.SendToServer()
			else
				options["Get In"] = function()
					net.Start("vehicleAction")
						net.WriteString("getIn")
						net.WriteUInt(ent:GetNW2Int("VehicleID"), 32)
					net.SendToServer()
				end

				options["Open Trunk"] = function()
					net.Start("vehicleAction")
						net.WriteString("openInv")
						net.WriteUInt(ent:GetNW2Int("VehicleID"), 32)
					net.SendToServer()
				end
			end
		else
			net.Start("vehicleEntityGetIn")
				net.WriteEntity(ent)
			net.SendToServer()
		end


		if (table.Count(options) > 0) then
			ent.nutMenuIndex = nut.menu.add(options, ent)
		end

		return false -- override default behavior
	end
end

PLUGIN.vehicleActions = {
	openInv = function(ply, veh, ent)
		local veh_info = nut.plugin.list.cardealer.Vehicles[veh:GetClass()]
		local inventory = nut.inventory.instances[veh:GetInvID()]

		if (!inventory) then
			net.Start("vehicleAction")
				net.WriteString("closeInv")
				net.WriteUInt(veh:GetID(), 32)
			net.SendToServer()
		end

		local local_inv = nut.inventory.show(LocalPlayer():getChar():getInv())
		local remote_inv = nut.inventory.show(inventory)

		remote_inv:ShowCloseButton(true)
		remote_inv:SetTitle(veh_info.Name)
		remote_inv:MoveLeftOf(local_inv, 4)
		remote_inv.OnClose = function(this)
			if (IsValid(local_inv) and !IsValid(nut.gui.menu)) then
				local_inv:Remove()
			end

			net.Start("vehicleAction")
				net.WriteString("closeInv")
				net.WriteUInt(veh:GetID(), 32)
			net.SendToServer()
		end

		local oldClose = local_inv.OnClose
		local_inv.OnClose = function()
			if (IsValid(panel) and !IsValid(nut.gui.menu)) then
				panel:Remove()
			end

			net.Start("vehicleAction")
				net.WriteString("closeInv")
				net.WriteUInt(veh:GetID(), 32)
			net.SendToServer()
			local_inv.OnClose = oldClose
		end
	end	
}

net.Receive("vehicleAction", function(len)
	local plugin = nut.plugin.list.cardealer

	local actionID = net.ReadString()
	local action = plugin.vehicleActions[actionID]
	if !action then return end

	local vehID = net.ReadUInt(32)
	local vehicle = plugin.loaded_vehicles[vehID]
	if !vehicle then return end

	action(LocalPlayer(), vehicle, vehicle:getData("entity"))
end)