-- "gamemodes\\mafiarp\\plugins\\typewriter\\derma\\cl_typewriter.lua"

local PANEL = {}

function PANEL:Init()
	self:SetSize(ScrW() * 0.4, ScrH() * 0.12)
	self:SetTitle("Typewriter")
	self:Center()
	self:MakePopup()

	self.title = self:Add("DTextEntry")
	self.title:SetZPos(1)
	self.title:DockMargin(0, 0, 0, 4)
	self.title:Dock(TOP)
	self.title:SetPlaceholderText("Document Title")

	self.body = self:Add("DTextEntry")
	self.body:SetZPos(2)
	self.body:DockMargin(0, 0, 0, 4)
	self.body:Dock(TOP)
	self.body:SetPlaceholderText("Document Body (Google Drive Link)")

	self.dropdown = self:Add("DComboBox")
	self.dropdown:SetZPos(3)
	self.dropdown:Dock(TOP)
	self.dropdown:SetValue("Model (Choose)")

	local options = {
		"models/props_lab/clipboard.mdl",
		"models/props_lab/binderblue.mdl",
		"models/foodnhouseholditems/newspaper1.mdl",
	}

	for _, option in ipairs(options) do
		self.dropdown:AddChoice(option)
	end

	self.create = self:Add("DButton")
	self.create:SetZPos(4)
	self.create:Dock(TOP)
	self.create:SetText("Print")
	self.create.DoClick = function(btn)
		local title = self.title:GetText()
		local titleTooLong = #title > 128
		local titleTooShort = #title == 0
		if titleTooLong or titleTooShort then
			nut.util.notify(
				titleTooLong and "The title cannot be longer than 128 characters in length!" or 
				"The title cannot be empty!"	
			)
			return
		end

		local body = self.body:GetText()
		local bodyTooLong = #body > 256
		local bodyTooShort = #body < 16
		if bodyTooLong or bodyTooShort then
			nut.util.notify(
				bodyTooLong and "The document body cannot be longer than 256 characters in length!" or
				"The document body cannot be any shorter than 16 characters in length!"	
			)
			return
		end

		local selectedOption = self.dropdown:GetValue()

		net.Start("nutCreateDocument")
			net.WriteString(title)
			net.WriteString(body)
			net.WriteString(selectedOption)
		net.SendToServer()

		nut.util.notify("Document successfully printed.")
	end
end

vgui.Register("nutTypewriter", PANEL, "DFrame")
