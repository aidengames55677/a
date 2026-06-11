-- "gamemodes\\mafiarp\\plugins\\carcustomisation\\derma\\cl_carmechanics.lua"


local PLUGIN = PLUGIN

SOUND_CHAR_HOVER = {"buttons/button15.wav", 35, 250}
SOUND_CHAR_CLICK = {"buttons/button14.wav", 35, 255}
SOUND_CHAR_WARNING = {"friends/friend_join.wav", 40, 255}

local function GetAngleFromSpawnlist( model )
	if not model then print("invalid model") return Angle(0,0,0) end
	
	model = string.lower( model )
	
	local v_list = list.Get( "simfphys_vehicles" )
	for listname, _ in pairs( v_list ) do
		if v_list[listname].Members.CustomWheels then
			local FrontWheel = v_list[listname].Members.CustomWheelModel
			local RearWheel = v_list[listname].Members.CustomWheelModel_R
			
			if FrontWheel then 
				FrontWheel = string.lower( FrontWheel )
			end
			
			if RearWheel then 
				RearWheel = string.lower( RearWheel )
			end
			
			if model == FrontWheel or model == RearWheel then
				local Angleoffset = v_list[listname].Members.CustomWheelAngleOffset
				if Angleoffset then
					return Angleoffset
				end
			end
		end
	end
	
	local list = list.Get( "simfphys_Wheels" )[model]
	local output = list and list.Angle or Angle(0,0,0)
	
	return output
end

// Garage button with hover sounds
local PANEL = {}
function PANEL:OnCursorEntered()
	LocalPlayer():EmitSound(unpack(SOUND_CHAR_HOVER))
end
vgui.Register("nutMechanicButton", PANEL, "DButton")


local PANEL = {}

local GARAGE_MAT = CreateMaterial("garage_ui", "UnlitGeneric", {
  	["$basetexture"] = "diverge/southsidecustoms",
})

function PANEL:Init()
	self:SetSize(ScrW(), ScrH())
	self:MakePopup()

	self.menu = vgui.Create("DFrame", self)
	self.menu:SetSize(ScrW() * 0.25, ScrH() * 0.8)
	self.menu:SetPos(ScrW() * 0.05, ScrH() * 0.05)
	self.menu:SetTitle("")
	self.menu:SetSkin("CarMechanic")
	self.menu:ShowCloseButton(false)
	self.menu:SetDraggable(false)
	self.menu:DockPadding(0, self.menu:GetTall() / 4, 0, 0)
	function self.menu:Paint(w, h)
		derma.SkinHook("Paint", "Frame", self, w, h)

		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(GARAGE_MAT)
		surface.DrawTexturedRect(0, 0, w, h / 4)
	end

	self.menu.container = self.menu:Add("DScrollPanel")
	self.menu.container:Dock(FILL)
	self.menu.container:SetZPos(1)
	function self.menu.container:Paint() end

	self.currentCat = ""
	self.currentCatSub = ""

end

function PANEL:CreateCSModel()
    self.showcaseModel = ClientsideModel(self.vehicleModel)
	local offset = PLUGIN.CustomizationOptions[self.vehicleClass].offset or Vector(0, 0, 0)
	self.showcaseModel:SetPos(PLUGIN.Showcase.pos + offset)
	self.showcaseModel:SetAngles(PLUGIN.Showcase.ang)
	local car = list.Get( "simfphys_vehicles" )[self.vehicleClass].Members
	if self.vehicleData["paintJob"] then
		self.showcaseModel:SetColor(self.vehicleData["paintJob"])
	elseif car.ModelInfo and car.ModelInfo.Color then
		self.showcaseModel:SetColor(car.ModelInfo.Color)
	end
	self.showcaseModel:Spawn()
	for k = 1, self.showcaseModel:GetNumBodyGroups() do
		if self.vehicleData["bodygroups"][k] then
			self.showcaseModel:SetBodygroup(k, self.vehicleData["bodygroups"][k])
		else
			self.vehicleData["bodygroups"][k] = 0
		end
	end

	// If the car doesn't come with wheels, spawn them
	if car.CustomWheels then
		local positions = {
			car.CustomWheelPosFL,
			car.CustomWheelPosFR,
			car.CustomWheelPosRL,
			car.CustomWheelPosRR
		}
		local fallback = car.CustomWheelModel or "models/props_vehicles/tire001c_car.mdl"
		local wheelModel = self.vehicleData["wheels"] or fallback
		self.wheels = {}

		for k, v in pairs(positions) do
			local Wheel = ClientsideModel(wheelModel)
			Wheel:SetPos(self.showcaseModel:LocalToWorld(v))
			Wheel:Spawn()
			Wheel:SetParent(self.showcaseModel)
			table.insert(self.wheels, Wheel)
		end
		self:SetWheels(wheelModel)
	end
end

function PANEL:SetWheels(model)
	local car = list.Get( "simfphys_vehicles" )[self.vehicleClass].Members
	local positions = {
		car.CustomWheelPosFL,
		car.CustomWheelPosFR,
		car.CustomWheelPosRL,
		car.CustomWheelPosRR
	}
	if car.CustomWheels then
		for k, Wheel in pairs(self.wheels) do
			local isfrontwheel = (k == 1 or k == 2)
			local swap_y = (k == 2 or k == 4 or k == 6)

			local angleoffset = GetAngleFromSpawnlist(model)

			local pFL = self.showcaseModel:LocalToWorld( car.CustomWheelPosFL )
			local pFR = self.showcaseModel:LocalToWorld( car.CustomWheelPosFR )
			local pRL = self.showcaseModel:LocalToWorld( car.CustomWheelPosRL )
			local pRR = self.showcaseModel:LocalToWorld( car.CustomWheelPosRR )
			local pAngL = self.showcaseModel:WorldToLocalAngles( ((pFL + pFR) / 2 - (pRL + pRR) / 2):Angle() )
			pAngL.r = 0
			pAngL.p = 0

			local yAngL = pAngL - Angle(0,90,0)
			yAngL:Normalize()

			local fAng = self.showcaseModel:LocalToWorldAngles( pAngL )
			local rAng = self.showcaseModel:LocalToWorldAngles( yAngL )

			local Forward = fAng:Forward() 
			local Right = swap_y and -rAng:Forward() or rAng:Forward()
			local Up = self.showcaseModel:GetUp()

			local ghostAng = Right:Angle()
			local mirAng = swap_y and 1 or -1
			ghostAng:RotateAroundAxis(Forward,angleoffset.p * mirAng)
			ghostAng:RotateAroundAxis(Right,angleoffset.r * mirAng)
			ghostAng:RotateAroundAxis(Up,-angleoffset.y)

			ghostAng:RotateAroundAxis(Forward, mirAng)

			Wheel:SetModelScale( 1 )
			Wheel:SetModel(model)
			Wheel:SetAngles( ghostAng )

			timer.Simple( 0.05, function()
				if not IsValid( Wheel ) then return end
				local wheelsize = Wheel:OBBMaxs() - Wheel:OBBMins()
				if self.radius == nil then
					self.radius = isfrontwheel and car.FrontWheelRadius or car.RearWheelRadius
					if self.radius == nil then
						self.radius = math.max( wheelsize.x, wheelsize.y, wheelsize.z ) * 0.5
					end
				end
				local size = (self.radius * 2) / math.max(wheelsize.x,wheelsize.y,wheelsize.z)

				Wheel:SetModelScale( size )
			end)
		end
	end
end

function PANEL:PopulateCategories()
    local panel = self
    local container = self.menu.container
	container:Clear()

    // Remove the back button
    if self.back then
        self.back:Remove()
    end

	local vehTable = PLUGIN.CustomizationOptions[self.vehicleClass]
	vehTable = table.Merge(vehTable, PLUGIN.GlobalCustomizationOptions)

    if vehTable then

		for name, v in SortedPairsByMemberValue(vehTable, "order") do
			if name == "offset" then continue end

			local categoryBtn = container:Add("nutMechanicButton")
			categoryBtn:Dock(TOP)
			categoryBtn:DockMargin(5, 5, 5, 0)
			categoryBtn:SetTall(36)
			categoryBtn:SetContentAlignment(5)
			categoryBtn:SetText(name)
			categoryBtn:SetFont("nutBigFont")
			categoryBtn.DoClick = function(self)
				LocalPlayer():EmitSound(unpack(SOUND_CHAR_CLICK))
				container:Clear()

				if (v.type != nil) then
					if (v.type == COLOR || v.type == TIRESMOKE) then
						LocalPlayer():EmitSound(unpack(SOUND_CHAR_CLICK))
						panel:OpenPaintMenu("", false, v.type, true, "")
						return
					end
				end

				panel.currentCat = name
				panel:SelectCategory(name, false)
			end

		end

    end

    // Remove the exit button if it still exists
    if self.close then
        self.close:Remove()
    end

    self.close = self.menu:Add("nutMechanicButton")
    self.close:SetText("Exit")
    self.close:SetFont("nutBigFont")
    self.close:DockMargin(5,0,5,5)
    self.close:Dock(BOTTOM)
    self.close:SetTall(36)
    self.close:SetZPos(999)
    self.close.DoClick = function(self)
		LocalPlayer():EmitSound(unpack(SOUND_CHAR_CLICK))
        panel:Remove()
    end
end

function PANEL:OpenPaintMenu(category, sub, type, difReturn, prevCat)
    local panel = self
    local csMdl = panel.showcaseModel
    local container = self.menu.container
    // Clear the categories
	container:Clear()

    // Remove the close button
    if self.close then
        self.close:Remove()
    end

    // Remove the back button
    if self.back then
        self.back:Remove()
    end

	local MixerCurrentColor = Color(255, 255, 255, 255)

    self.mixer = self.menu:Add("DColorMixer")
	self.mixer:Dock( TOP )
	self.mixer:SetPalette( true )
	self.mixer:SetAlphaBar( false )
	self.mixer:SetWangs( false )
	self.mixer:SetColor( self.showcaseModel:GetColor() )
	self.mixer.ValueChanged = function( pnl, col )
		MixerCurrentColor = Color(col.r, col.g, col.b, 255)
		if type == COLOR then
			self.showcaseModel:SetColor(MixerCurrentColor)
		end
	end

    self.paint = self.menu:Add("nutMechanicButton")
    self.paint:SetText("Paint")
    self.paint:SetFont("nutBigFont")
    self.paint:DockMargin(5,12,5,5)
    self.paint:Dock(TOP)
    self.paint:SetContentAlignment(4)
    self.paint:SetTall(36)
    self.paint:SetZPos(999)
    self.paint.DoClick = function(self)
		// Check if our characters money is enough or more than the price
		local name
		if type == TIRESMOKE then
			name = "tiresmoke"
		else
			name = "car"
		end
		if LocalPlayer():getChar():getMoney() >= (PLUGIN.ColorPrice or 0) then
			LocalPlayer():EmitSound(unpack(SOUND_CHAR_CLICK))
			Derma_Query(
				"Are you sure you want to repaint your "..name.."?",
				"Purchase", 
				"Yes", 
				function()
					panel.vehicleData["paintJob"] = MixerCurrentColor
					net.Start("nutVehMechanicPaint")
						net.WriteColor(MixerCurrentColor)
						net.WriteInt(panel.vehicleID, 32)
						net.WriteInt(type, 32)
					net.SendToServer()
				end,
				"No"
			)
		else
			LocalPlayer():EmitSound(unpack(SOUND_CHAR_WARNING))
			Derma_Query(
				"You don't have to money to repaint your "..name.."!",
				"Not enough money", 
				"Okay"
			)
		end
    end
	self.paint.price = self.paint:Add("DLabel")
	self.paint.price:SetText(nut.currency.symbol..PLUGIN.ColorPrice)
	self.paint.price:SetTextColor(Color(255,255,255))
	self.paint.price:SetFont("nutBigFont")
	self.paint.price:SizeToContents()
	self.paint.price:SetTall(36)
	self.paint.price:SetPos(self.paint:GetWide() - self.paint.price:GetWide(), 0)

    self.back = self.menu:Add("nutMechanicButton")
    self.back:SetText("Back")
    self.back:SetFont("nutBigFont")
    self.back:DockMargin(5,0,5,5)
    self.back:Dock(BOTTOM)
    self.back:SetTall(36)
    self.back:SetZPos(999)
    self.back.DoClick = function(self)
		LocalPlayer():EmitSound(unpack(SOUND_CHAR_CLICK))

		// Reset paint
		if type == COLOR then
			local car = list.Get( "simfphys_vehicles" )[panel.vehicleClass].Members
			if panel.vehicleData["paintJob"] then
				panel.showcaseModel:SetColor(panel.vehicleData["paintJob"])
			elseif car.ModelInfo and car.ModelInfo.Color then
				panel.showcaseModel:SetColor(car.ModelInfo.Color)
			else
				panel.showcaseModel:SetColor(255, 255, 255)
			end
		end

		panel.mixer:Remove()
		panel.paint:Remove()
		panel.paint.price:Remove()
		self:Remove()

		if difReturn then
			panel:PopulateCategories()
			return
		end

        if sub then
            panel:SelectCategory(category, true, prevCat)
        else
            panel:SelectCategory(category, false)
        end
    end
end

local function isToggleOption(type)
	if (type == EXPLOSIVE ||
		type == BULLETPROOFTIRES ||
		type == TRACKER ||
		type == ALARM ||
		type == TURBO) then
		return true
	end
	return false
end

function PANEL:HasEquipped(type, value, id)
	local vehicleData = self.vehicleData
    if type == BODYGROUP && vehicleData["bodygroups"][id] == value then
        return true
    elseif type == HEALTH && vehicleData["maxhealth"] == value then
        return true
    elseif type == SUSPENSION && math.Round(vehicleData["suspension"], 2) == value then
        return true
    elseif type == BRAKES && math.Round(vehicleData["brakes"], 2) == value then
        return true
    elseif type == ENGINE && math.Round(vehicleData["engine"], 2) == value then
        return true
    elseif type == TURBO && vehicleData["turbo"] == true then
        return true
    elseif type == TRANSMISSION && math.Round(vehicleData["transmission"], 2) == value then
        return true
    elseif type == WHEELS && vehicleData["wheels"] == value then
		return true
    elseif type == HORN && vehicleData["horn"] == value then
        return true
	elseif type == BULLETPROOFTIRES && vehicleData["bulletprooftires"] == true then
		return true
	elseif type == SKIN && vehicleData["skin"] == value then
		return true
	elseif type == TRACKER && vehicleData["tracker"] == true then
		return true
	elseif type == ALARM && vehicleData["alarm"] == true then
		return true
	elseif type == EXPLOSIVE && vehicleData["explosive"] == true then
		return true
    end

    return false
end

function PANEL:CanBuy(type, value, id)
	local vehicleData = self.vehicleData
    if type == BODYGROUP && vehicleData["bodygroups"][id] == value then
        return false
    elseif type == HEALTH && vehicleData["maxhealth"] == value then
        return false
    elseif type == SUSPENSION && math.Round(vehicleData["suspension"], 2) == value then
        return false
    elseif type == BRAKES && math.Round(vehicleData["brakes"], 2) == value then
        return false
    elseif type == ENGINE && math.Round(vehicleData["engine"], 2) == value then
        return false
    elseif type == TRANSMISSION && math.Round(vehicleData["transmission"], 2) == value then
        return false
    elseif type == WHEELS && vehicleData["wheels"] == value then
		return false
    elseif type == HORN && vehicleData["horn"] == value then
        return false
    elseif type == SKIN && vehicleData["skin"] == value then
        return false
    end

    return true
end

function PANEL:RefreshPrices(ignoreToggleOptions)
	if self.prices == nil then return end

	for _, panel in pairs(self.prices) do
		local data = panel.data
        if self:HasEquipped(data.type, data.value, data.id or 0) then
		    panel:SetText("Installed")
        else
		    panel:SetText(nut.currency.symbol..data.price)
        end
		panel:SizeToContents()
		panel:SetPos(panel:GetParent():GetWide() - panel:GetWide(), 0)
	end
end

function PANEL:SelectCategory(category, sub, prevCat)
    // Check whether the category we selected is valid
    local catTable = {}
    if sub then
        catTable = PLUGIN.CustomizationOptions[self.vehicleClass][prevCat][category]
    else
        catTable = PLUGIN.CustomizationOptions[self.vehicleClass][category]
    end
    if !catTable then return end

    local panel = self
    local csMdl = panel.showcaseModel
    local container = self.menu.container
    // Clear the categories
	container:Clear()

    // Remove the close button
    if self.close then
        self.close:Remove()
    end

	self.currentCat = category
	self.currentCatSub = prevCat or ""

    // Loop through category table, and list options
	local newData = {}
	for name, data in SortedPairs(catTable) do
		if !istable(data) then continue end
		newData[name] = data
	end
	self.prices = {}
	local car = list.Get( "simfphys_vehicles" )[self.vehicleClass].Members
    for name, data in SortedPairsByMemberValue(newData, "order") do

		if (data.sub && data.type == WHEELS && !car.CustomWheels) then continue end

        local optionBtn = container:Add("nutMechanicButton")
        optionBtn:Dock(TOP)
        optionBtn:DockMargin(5, 5, 5, 0)
        optionBtn:SetTall(36)
        optionBtn:SetContentAlignment(4)
        optionBtn:SetText(name)
        optionBtn:SetFont("nutBigFont")
        optionBtn.Think = function(self)
            if !self:IsHovered() then return end
            if data.type == BODYGROUP then
                if csMdl:GetBodygroup(data.id) != data.value then
                    csMdl:SetBodygroup(data.id, data.value)
                end
            elseif data.type == SKIN then
                if csMdl:GetSkin() != data.value then
                    csMdl:SetSkin(data.value)
                end
			elseif data.type == WHEELS && data.value != nil then
                if panel.wheels != nil && panel.wheels[1] != nil && panel.wheels[1]:GetModel() != data.value then
					panel:SetWheels(data.value)
				end
            elseif data.type == HORN then
                if (panel.lastHorn or "") != data.value then
					if timer.Exists("StopHorn"..LocalPlayer():EntIndex()) then
						LocalPlayer():StopSound(panel.lastHorn)
						timer.Remove("StopHorn"..LocalPlayer():EntIndex())
					end
                    panel.lastHorn = data.value
					LocalPlayer():EmitSound(data.value, 35)
					timer.Create("StopHorn"..LocalPlayer():EntIndex(), 1, 1, function()
						LocalPlayer():StopSound(data.value)
					end)
                end
            end
        end
        optionBtn.DoClick = function(self)
            if data.sub then
				LocalPlayer():EmitSound(unpack(SOUND_CHAR_CLICK))
                panel.back:Remove()
                panel:SelectCategory(name, true, category)
                return
            end

			if (data.type == COLOR || data.type == TIRESMOKE) then
				LocalPlayer():EmitSound(unpack(SOUND_CHAR_CLICK))
				local live = TIRESMOKE and true or false
				if type == (TIRESMOKE) then
					panel:OpenPaintMenu(category, sub, data.type, false, prevCat)
				else
					panel:OpenPaintMenu(category, sub, data.type, false, prevCat)
				end
				return
			end

			if !panel:CanBuy(data.type, data.value, data.id or 0) then return end

            // Check if our characters money is enough or more than the price
            if LocalPlayer():getChar():getMoney() >= (data.price or 0) then
				LocalPlayer():EmitSound(unpack(SOUND_CHAR_CLICK))
				local text = Format("Are you sure you want to purchase %s?", name)
				if (isToggleOption(data.type) && panel:HasEquipped(data.type, data.value, 0)) then
					text = Format("Are you sure you want to uninstall %s?", name)
				end
                Derma_Query(
                    text,
                    "Purchase", 
                    "Yes", 
                    function()
						if (isToggleOption(data.type)) then
							panel.vehicleData[PLUGIN.TypeToName[data.type]] = !panel.vehicleData[PLUGIN.TypeToName[data.type]]
						elseif (data.type == BODYGROUP) then
							panel.vehicleData[PLUGIN.TypeToName[data.type]][data.id] = data.value
						else
							panel.vehicleData[PLUGIN.TypeToName[data.type]] = data.value
						end
						panel:RefreshPrices(true)

                        net.Start("nutVehMechanicPurchase")
                            net.WriteString(category)
                            net.WriteString(name)
							net.WriteInt(panel.vehicleID, 32)
                            if sub == true then net.WriteString(prevCat) end
                        net.SendToServer()
                    end,
                    "No"
                )
            else
				LocalPlayer():EmitSound(unpack(SOUND_CHAR_WARNING))
                Derma_Query(
                    Format("You don't have to money to purchase %s!", name),
                    "Not enough money", 
                    "Okay"
                )
            end
        end

        if data.sub then continue end

		optionBtn.price = optionBtn:Add("DLabel")
        if self:HasEquipped(data.type, data.value, data.id or 0) then
		    optionBtn.price:SetText("Installed")
        else
		    optionBtn.price:SetText(nut.currency.symbol..data.price)
        end
		optionBtn.price:SetTextColor(Color(255,255,255))
		optionBtn.price:SetFont("nutBigFont")
		optionBtn.price:SizeToContents()
		optionBtn.price:SetTall(36)
		optionBtn.price:SetPos(optionBtn:GetWide() - optionBtn.price:GetWide(), 0)
		optionBtn.price.data = {
			type = data.type,
			value = data.value,
			id = data.id or 0,
			price = data.price
		}
		table.insert(self.prices, optionBtn.price)

    end
	panel:RefreshPrices(false)

    // Remove the back button if it still exists
    if self.back then
        self.back:Remove()
    end

    self.back = self.menu:Add("nutMechanicButton")
    self.back:SetText("Back")
    self.back:SetFont("nutBigFont")
    self.back:DockMargin(5,0,5,5)
    self.back:Dock(BOTTOM)
    self.back:SetTall(36)
    self.back:SetZPos(999)
    self.back.DoClick = function(self)
		LocalPlayer():EmitSound(unpack(SOUND_CHAR_CLICK))

		// Reset model stuff
		for k, v in pairs(panel.vehicleData["bodygroups"]) do
			csMdl:SetBodygroup(k, v)
		end
		if panel.wheels != nil and istable(panel.wheels) then
			panel:SetWheels(panel.vehicleData["wheels"])
		end
		csMdl:SetSkin(panel.vehicleData["skin"])

		// If we're in a sub category, remove the back button and select the previous category
        if sub then
            self:Remove()
            panel:SelectCategory(prevCat, false)
        else
            panel:PopulateCategories()
        end
    end
end


function PANEL:OnMousePressed(keyCode)
	if keyCode == MOUSE_LEFT then
		self.lastAngles = self.showcaseModel:GetAngles()
		self.beginMouse = gui.MouseX()
		self.mouseLeftDown = true
	end
end

function PANEL:OnMouseReleased(keyCode)
	if keyCode == MOUSE_LEFT then
		self.mouseLeftDown = false
	end
end

function PANEL:Paint(w, h)
	if self.mouseLeftDown then
		self.showcaseModel:SetAngles( Angle( 0, self.lastAngles[2] - (self.beginMouse - (gui.MouseX() % 360)), 0 ) )
	elseif self.mouseLeftDown and !self:IsHovered() then
		self.mouseLeftDown = false
	end
end

function PANEL:Think()
	if input.IsKeyDown(KEY_ESCAPE) then
		self:Remove()
	end
end

function PANEL:OnRemove()
	if self.showcaseModel then
        self.showcaseModel:Remove()
    end
	if self.wheels then
		for k, v in pairs(self.wheels) do
			v:Remove()
		end
	end
end
vgui.Register("nsvehCustomMenu", PANEL, "EditablePanel")

function PLUGIN:CalcView(ply, origin, angles, fov, znear, zfar)
    if IsValid(nut.gui.garagemenu) then
        local view = {
            origin = PLUGIN.Showcase.campos,
            angles = PLUGIN.Showcase.camang,
            fov = fov,
            drawviewer = true,
        }

        return view
    end
end

local meta = FindMetaTable("Player")

trackingCar = false
function meta:TrackCar(carEnt)
	trackingCar = !trackingCar
	if !trackingCar then
		hook.Remove("HUDPaint", "CarTracker"..self:EntIndex())
	else
		hook.Add("HUDPaint", "CarTracker"..self:EntIndex(), function()
			if (!IsValid(carEnt) || carEnt == nil || carEnt == NULL) then
				hook.Remove("HUDPaint", "CarTracker"..self:EntIndex())
				return
			end
			local dist = self:GetPos():Distance(carEnt:GetPos())
			local spos = carEnt:GetPos():ToScreen()

			local howclose = math.Round(math.floor(dist) / 40)

			if !spos then return end

			surface.SetTextColor(128, 128, 128)
			surface.SetFont("Trebuchet18")

			local tW, tH = surface.GetTextSize("Car Location")
			surface.SetTextPos(spos.x - (tW / 2), spos.y)
			surface.DrawText("Car Location")

			local distText = howclose .. " Meters"
			tW, tH = surface.GetTextSize(distText)
			surface.SetTextPos(spos.x - (tW / 2), spos.y + 16)
			surface.DrawText(distText)
		end)
	end
end

net.Receive("nutTrackCar", function()
	local carEnt = net.ReadEntity()
	if (carEnt == nil) then return end

	LocalPlayer():TrackCar(carEnt)
end)

local SKIN = {}
	SKIN.fontFrame = "BudgetLabel"
	SKIN.fontTab = "nutSmallFont"
	SKIN.fontButton = "nutSmallFont"

	SKIN.Colours = table.Copy(derma.SkinList.Default.Colours)
	SKIN.Colours.Window.TitleActive = Color(0, 0, 0)
	SKIN.Colours.Window.TitleInactive = Color(255, 255, 255)

	SKIN.Colours.Button.Normal = Color(255, 255, 255)
	SKIN.Colours.Button.Hover = Color(0, 0, 0)
	SKIN.Colours.Button.Down = Color(20, 20, 20)
	SKIN.Colours.Button.Disabled = Color(0, 0, 0, 100)

	function SKIN:PaintFrame(panel)
		surface.SetDrawColor(0, 0, 0, 180)
		surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())
	end

	function SKIN:DrawGenericBackground(x, y, w, h)
		surface.SetDrawColor(45, 45, 45, 240)
		surface.DrawRect(x, y, w, h)

		surface.SetDrawColor(0, 0, 0, 180)
		surface.DrawOutlinedRect(x, y, w, h)

		surface.SetDrawColor(100, 100, 100, 25)
		surface.DrawOutlinedRect(x + 1, y + 1, w - 2, h - 2)
	end

	function SKIN:PaintPanel(panel)
		if (not panel.m_bBackground) then return end
		if (panel.GetPaintBackground and not panel:GetPaintBackground()) then
			return
		end

		local w, h = panel:GetWide(), panel:GetTall()

		surface.SetDrawColor(0, 0, 0, 100)
		surface.DrawRect(0, 0, w, h)
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	function SKIN:PaintButton(panel)
		if !panel.laidOut then
			if IsValid(panel.price) then
				panel.price:SetPos(panel:GetWide() - panel.price:GetWide(), 0)
			end

			panel.laidOut = true
		end

		if (not panel.m_bBackground) then return end
		if (panel.GetPaintBackground and not panel:GetPaintBackground()) then
			return
		end

		if IsValid(panel.price) then
			panel.price:SetTextColor(Color(255,255,255))
		end

		local w, h = panel:GetWide(), panel:GetTall()
		local alpha = 0

		if (panel:GetDisabled()) then
			alpha = 10
		elseif (panel.Depressed) then
			alpha = 180
			if IsValid(panel.price) then
				panel.price:SetTextColor(Color(0,0,0))
			end
		elseif (panel.Hovered) then
			alpha = 200
			if IsValid(panel.price) then
				panel.price:SetTextColor(Color(0,0,0))
			end
		end

		surface.SetDrawColor(255, 255, 255, alpha)
		surface.DrawRect(0, 0, w, h)
	end

	-- I don't think we gonna need minimize button and maximize button.
	function SKIN:PaintWindowMinimizeButton(panel, w, h)
	end

	function SKIN:PaintWindowMaximizeButton(panel, w, h)
	end
derma.DefineSkin("CarMechanic", "The skin for the car mechanic menu.", SKIN)
derma.RefreshSkins()