-- "gamemodes\\mafiarp\\plugins\\cassette_player\\derma\\cl_cassetteplayer.lua"


local PLUGIN = PLUGIN

SOUND_CHAR_HOVER = {"buttons/button15.wav", 35, 250}
SOUND_CHAR_CLICK = {"buttons/button14.wav", 35, 255}
SOUND_CHAR_WARNING = {"friends/friend_join.wav", 40, 255}

local function canUse(ply, ent)
	if !simfphys.IsCar( ent ) then
		if ply:GetEyeTrace().Entity != ent then
			return false
		end
	else
		if ply:GetSimfphys() != ent then return false end
	end
	return true
end

function PLUGIN:OpenCassetteMenu(cassettePlayer)
	local cassetteMenu = vgui.Create("nutCassetteMenu")
	cassetteMenu.player = cassettePlayer

	// Bit messy, but essentially just makes sure the volume slider gets adjusted depending of if it's a car or not
	if (simfphys.IsCar(cassetteMenu.player)) then
		cassetteMenu.volume:SetMax(PLUGIN.MaxCarVolume)
	else
		cassetteMenu.volume:SetMax(PLUGIN.MaxCPlayerVolume)
	end
	if PLUGIN.RadioChannels[cassettePlayer] then
		local volume = simfphys.IsCar(cassetteMenu.player) and PLUGIN.DefaultCarVolume or PLUGIN.DefaultCPlayerVolume
		if IsValid(PLUGIN.RadioChannels[cassettePlayer]) then
			volume = PLUGIN.RadioChannels[cassettePlayer]:GetVolume()
		end
		cassetteMenu.volume:SetValue(volume)
	else
		if (simfphys.IsCar(cassetteMenu.player)) then
			cassetteMenu.volume:SetValue(PLUGIN.DefaultCarVolume)
		else
			cassetteMenu.volume:SetValue(PLUGIN.DefaultCPlayerVolume)
		end
	end

	nut.gui.cassetteplayer = cassetteMenu

	// Show pickup button only if not in a car
	if (!LocalPlayer():GetSimfphys() || LocalPlayer():GetSimfphys() == NULL || LocalPlayer():GetSimfphys() == nil) then
		cassetteMenu.pickup = cassetteMenu:Add("DButton")
		cassetteMenu.pickup:SetSize(55, 23)
		cassetteMenu.pickup:SetPos(0, 0)
		cassetteMenu.pickup:SetFont("nutSmallFont")
		cassetteMenu.pickup:SetText("Pickup")
		cassetteMenu.pickup:SetTextColor(color_white)
		function cassetteMenu.pickup:Paint(w, h)
			if self:IsHovered() then
				self:SetTextColor(Color(255, 255, 255))
			else
				self:SetTextColor(Color(220, 220, 220))
			end
		end
		function cassetteMenu.pickup:DoClick()
			if !canUse(LocalPlayer(), cassetteMenu.player) then return end
			net.Start("nutCassetteAction")
				net.WriteEntity(cassetteMenu.player)
				net.WriteInt(PICKUP, 32)
			net.SendToServer()
			cassetteMenu:Remove()
		end
	end

	// Load and eject button
	if !cassettePlayer:getNetVar("cassette", false) then
		cassetteMenu.load = cassetteMenu:Add("DComboBox")
		cassetteMenu.load:SetSize(100, 23)
		if (!LocalPlayer():GetSimfphys() || LocalPlayer():GetSimfphys() == NULL || LocalPlayer():GetSimfphys() == nil) then
			cassetteMenu.load:SetPos(55, 0)
		else
			cassetteMenu.load:SetPos(0, 0)
		end
		cassetteMenu.load:SetFont("nutSmallFont")
		cassetteMenu.load:SetValue("Load Cassette")
		cassetteMenu.load:SetTextColor(color_white)
		function cassetteMenu.load:Paint(w, h)
			if self:IsHovered() then
				self:SetTextColor(Color(255, 255, 255))
			else
				self:SetTextColor(Color(220, 220, 220))
			end
		end
		function cassetteMenu.load.DropButton:Paint(w, h) end
		// We override this function to stop it from setting the text upon selecting an option
		function cassetteMenu.load:ChooseOption(value, index) if ( self.Menu ) then self.Menu:Remove() self.Menu = nil end self.selected = index self:OnSelect( index, value, self.Data[ index ] ) end
		local items = {}
		for id, item in pairs(LocalPlayer():getChar():getInv():getItems()) do
			if item.isCassette && !items[item.name] then
				cassetteMenu.load:AddChoice(item.name)
				items[item.name] = item.uniqueID
			end
		end
		cassetteMenu.load.OnSelect = function(self, index, value)
			if (cassetteMenu.loadDelay or 0) < CurTime() then
				if !cassetteMenu.player:getNetVar("cassette", false) then
					net.Start("nutCassetteAction")
						net.WriteEntity(cassetteMenu.player)
						net.WriteInt(LOAD, 32)
						net.WriteFloat(0)
						net.WriteString(items[value])
					net.SendToServer()
				end
				cassetteMenu.loadDelay = CurTime() + 1
			end
		end
	else
		cassetteMenu.eject2 = cassetteMenu:Add("DButton")
		cassetteMenu.eject2:SetSize(45, 23)
		if (!LocalPlayer():GetSimfphys() || LocalPlayer():GetSimfphys() == NULL || LocalPlayer():GetSimfphys() == nil) then 
			cassetteMenu.eject2:SetPos(55, 0)
		else
			cassetteMenu.eject2:SetPos(0, 0)
		end
		cassetteMenu.eject2:SetFont("nutSmallFont")
		cassetteMenu.eject2:SetText("Eject")
		function cassetteMenu.eject2:DoClick()
			if cassetteMenu.player:getNetVar("cassette", false) then
				net.Start("nutCassetteAction")
					net.WriteEntity(cassetteMenu.player)
					net.WriteInt(EJECT, 32)
				net.SendToServer()
			end
		end
		function cassetteMenu.eject2:Paint(w, h)
			if self:IsHovered() then
				self:SetTextColor(Color(255, 255, 255))
			else
				self:SetTextColor(Color(220, 220, 220))
			end
		end
	end
end

local PANEL = {}

function PANEL:Init()
	self:SetSize(480, 230)
	self:SetTitle("")
	self:MakePopup()
    self:Center()

	local panel = self

	local buttonOffset = (self:GetWide()/3)

	self.play = self:Add("DButton")
	self.play:SetSize(84, 84)
	self.play:SetPos(buttonOffset-84, self:GetTall()/4)
	self.play:SetText("")
	self.play:SetTextColor(color_white)
	local playIcon = Material("diverge/play.png", "mips")
	function self.play:Paint(w, h)
		if self:IsHovered() then
			surface.SetDrawColor(Color(255, 255, 255))
		else
			surface.SetDrawColor(Color(200, 200, 200))
		end
		surface.SetMaterial(playIcon)
		surface.DrawTexturedRect(0, 0, w, h)
	end
	function self.play:DoClick()
		if !canUse(LocalPlayer(), panel.player) then return end
		net.Start("nutCassetteAction")
			net.WriteEntity(panel.player)
			net.WriteInt(PLAY, 32)
		net.SendToServer()
	end

	self.stop = self:Add("DButton")
	self.stop:SetSize(84, 84)
	self.stop:SetPos((buttonOffset*2)-84-(84/2), self:GetTall()/4) // Could probably use a DGrid but i'm too lazy, and doesn't really make a difference
	self.stop:SetText("")
	self.stop:SetTextColor(color_white)
	function self.stop:Paint(w, h)
		if self:IsHovered() then
			surface.SetDrawColor(Color(255, 255, 255))
		else
			surface.SetDrawColor(Color(200, 200, 200))
		end
		surface.DrawRect(0, 0, w/3, h)
		surface.DrawRect((w/3)*2, 0, w/3, h)
	end
	function self.stop:DoClick()
		if !canUse(LocalPlayer(), panel.player) then return end
		net.Start("nutCassetteAction")
			net.WriteEntity(panel.player)
			net.WriteInt(STOP, 32)
		net.SendToServer()
	end

	self.eject = self:Add("DButton")
	self.eject:SetSize(84, 84)
	self.eject:SetPos((buttonOffset*3)-84-(84/2)-(84/2), self:GetTall()/4)
	self.eject:SetText("")
	self.eject:SetTextColor(color_white)
	local ejectIcon = Material("diverge/eject.png", "mips")
	function self.eject:Paint(w, h)
		if self:IsHovered() then
			surface.SetDrawColor(Color(255, 255, 255))
		else
			surface.SetDrawColor(Color(200, 200, 200))
		end
		surface.SetMaterial(ejectIcon)
		surface.DrawTexturedRect(0, 0, w, h)
	end
	function self.eject:DoClick()
		if !canUse(LocalPlayer(), panel.player) then return end
		if panel.player:getNetVar("cassette", false) then
			net.Start("nutCassetteAction")
				net.WriteEntity(panel.player)
				net.WriteInt(EJECT, 32)
			net.SendToServer()
		end
	end

	self.volume = self:Add("DNumSlider")
	self.volume:SetText("Volume")
	self.volume:SetSize(self:GetWide()/1.5, 25)
	self.volume:SetPos(0, self:GetTall()-50)
	self.volume:CenterHorizontal()
	self.volume.TextArea:SetTextColor(color_white)
	self.volume.TextArea:SetFont("nutSmallFont")
	self.volume.Label:SetFont("nutSmallFont")
	function self.volume:OnValueChanged(val)
		if !canUse(LocalPlayer(), panel.player) then return end
		if panel.player:getNetVar("cassette", false) then
			panel.player.cassetteVolume = val
			net.Start("nutCassetteAction")
				net.WriteEntity(panel.player)
				net.WriteInt(VOLUME, 32)
				net.WriteFloat(val)
			net.SendToServer()
		end
	end

end

function PANEL:Refresh()
	PLUGIN:OpenCassetteMenu(self.player)
	self:Remove()
end

function PANEL:OnKeyCodePressed(keyCode)
	if keyCode == KEY_F1 || keyCode == KEY_ESCAPE then
		self:Remove()
	end
end
vgui.Register("nutCassetteMenu", PANEL, "DFrame")

net.Receive("nutCassetteMenu", function()
	local cassettePlayer = net.ReadEntity()
	PLUGIN:OpenCassetteMenu(cassettePlayer)
end)

net.Receive("nutCassetteMenuRefresh", function()
	if ValidPanel(nut.gui.cassetteplayer) then
		nut.gui.cassetteplayer:Refresh()
	end
end)

