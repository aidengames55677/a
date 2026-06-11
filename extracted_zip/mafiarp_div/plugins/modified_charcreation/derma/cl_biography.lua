-- "gamemodes\\mafiarp\\plugins\\modified_charcreation\\derma\\cl_biography.lua"

local PLUGIN = PLUGIN
local PANEL = {}

local HIGHLIGHT = Color(255, 255, 255, 50)

function PANEL:Init()
	self.nameLabel = self:addLabel("name")
	self.nameLabel:SetZPos(0)

	self.name = self:addTextEntry("name")
	self.name:SetTall(48)
	self.name.onTabPressed = function()
	end
	self.name:SetZPos(1)

	local zpos = 2
	local i = 1
	for k, v in ipairs(PLUGIN.character_customization) do
		local label = self:Add("DLabel")
		label:SetFont("nutCharButtonFont")
		label:SetText(L(v.Name):upper())
		label:SizeToContents()
		label:SetPos((k % 2) * (ScrW() / 4.95), (i * ScrH() / 12.6) + ScrH() / 40)
		label:SetZPos(zpos)

		if v.Type == "Dropdown" then
			self["var_"..v.Name] = self:Add("DComboBox"); local combo = self["var_"..v.Name]
			combo:SetFont("nutCharButtonFont")
			combo:SetTextColor(color_white)
			combo.Paint = self.paintTextEntry
			combo:SetSize(ScrW() / 5.9, ScrH() / 24)
			combo:SetPos((k % 2) * (ScrW() / 4.95), (i * ScrH() / 13) + ScrH() / 15)
			combo:SetZPos(zpos)
			combo.OnSelect = function(_, index, value, data)
				local descgenerator = self:getContext("descgenerator", {})

				descgenerator[v.Name] = value

				self:setContext("descgenerator", descgenerator)
			end
			
			combo:SetValue("Select")
			for k2, v2 in pairs(v.Options) do
				combo:AddChoice(v2)
			end

			--combo:ChooseOptionID(1)
		elseif v.Type == "Text" then
			self["var_"..v.Name] = self:Add("DTextEntry"); local entry = self["var_"..v.Name]
			entry:SetFont("nutCharButtonFont")
			entry.Paint = self.paintTextEntry
			entry:SetSize(ScrW() / 5.9, ScrH() / 24)
			entry:SetPos((k % 2) * (ScrW() / 4.95), (i * ScrH() / 13) + ScrH() / 15)
			entry:SetZPos(zpos)
			entry.OnValueChange = function(_, value)
				local descgenerator = self:getContext("descgenerator", {})

				descgenerator[v.Name] = string.Trim(value)

				self:setContext("descgenerator", descgenerator)
			end
		elseif v.Type == "NumberWang" then
			self["var_"..v.Name] = self:Add("DNumberWang"); local wang = self["var_"..v.Name]
			wang.AllowInput = function() return true end -- Disables typing
			wang.OnValueChanged = function(wang, value)
				value = tonumber(value)
				if value > wang:GetMax() then
					wang:SetValue(v.Maximum)
					wang:SetValue(v.Maximum)
				end
				if wang:GetMin() > value then
					wang:SetText(v.Minimum)
					wang:SetValue(v.Minimum)
				end

				local descgenerator = self:getContext("descgenerator", {})

				descgenerator[v.Name] = wang:GetValue()

				self:setContext("descgenerator", descgenerator)
			end
			wang:SetFont("nutCharButtonFont")
			wang:SetSize(ScrW() / 5.9, ScrH() / 24)
			wang:SetPos((k % 2) * (ScrW() / 4.95), (i * ScrH() / 13) + ScrH() / 15)
			wang:SetMinMax(v.Minimum or 0, v.Maximum or 100)
			wang:SetValue(v.Minimum or 0)
			wang:SetDecimals(0)
			wang:SetTooltip("Click on the arrows to change value. \nYou can use your scroll wheel.")
			wang.Paint = self.paintTextEntry
			wang:SetZPos(zpos)

			if (v.Minimum) then
				wang:SetMin(v.Minimum)
			end
			
			if (v.Maximum) then
				wang:SetMax(v.Maximum)
			end
		end

		if (k % 2) == 0 then
			i = i + 1
		end
	end
end

function PANEL:addTextEntry(contextName)
	local entry = self:Add("DTextEntry")
	entry:Dock(TOP)
	entry:SetFont("nutCharButtonFont")
	entry.Paint = self.paintTextEntry
	entry:DockMargin(0, 4, 0, 16)
	entry.OnValueChange = function(_, value)
		self:setContext(contextName, string.Trim(value))
	end
	entry.contextName = contextName
	entry.OnKeyCodeTyped = function(name, keyCode)
		if (keyCode == KEY_TAB) then
			entry:onTabPressed()
			return true
		end
	end
	entry:SetUpdateOnType(true)
	return entry
end

function PANEL:onDisplay()
	local faction = self:getContext("faction")
	assert(faction, "faction not set before showing name input")
	local default, override =
		hook.Run("GetDefaultCharName", LocalPlayer(), faction)

	if (override) then
		self.nameLabel:SetVisible(false)
		self.name:SetVisible(false)
	else
		if (default and not self:getContext("name")) then
			self:setContext("name", default)
		end
		self.nameLabel:SetVisible(true)
		self.name:SetVisible(true)
		self.name:SetText(self:getContext("name", ""))
	end

	-- Requesting focus same frame causes issues with docking.
	self.name:RequestFocus()
end

function PANEL:validate()
	if (self.name:IsVisible()) then
		local res = {self:validateCharVar("name")}
		if (res[1] == false) then
			return unpack(res)
		end
	end

	local info = table.Copy(self:getContext("descgenerator", {}))
	info.model = self:getContext("model")
	info.faction = self:getContext("faction")
	
	self:setContext("desc", PLUGIN:GenerateDescription(info))
end

-- self refers to the text entry
function PANEL:paintTextEntry(w, h)
	nut.util.drawBlur(self)
	surface.SetDrawColor(0, 0, 0, 100)
	surface.DrawRect(0, 0, w, h)
	self:DrawTextEntryText(color_white, HIGHLIGHT, HIGHLIGHT)
end

vgui.Register("nutCharacterBiography", PANEL, "nutCharacterCreateStep")