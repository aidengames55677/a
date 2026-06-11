-- "gamemodes\\mafiarp\\plugins\\rjobs\\derma\\cl_dialog.lua"

surface.CreateFont( "Credentials_Font", {
	font = "Times New Roman", 
	extended = false,
	size = 35,
} )

surface.CreateFont( "Dialog_Font", {
	font = "Times New Roman", 
	extended = false,
	size = 25,
} )

surface.CreateFont( "Item_Font", {
	font = "Times New Roman",
	size = 18,
	weight = 800,
	antialias = true,
} )

local DEV_CONVERSATION = {
	opening = {
		response = "Hey there, how can I help you?",
		options = {
			"ask_help",
			"seen_anything",
			"got_money",
			"exit",
		}
	},
	ask_help = {
		dialog = "Hey man, do you know where I can find some help?",
		response = "Sounds like you mean the mental kind of help.",
	},
	seen_anything = {
		dialog = "Heard anything recently?",
		response = "I heard that sometimes the payphones around here will ring, and when you pick it up, a voice tells you how many days you have left to live. Spooky, right?",
		options = {
			"skeptical_response",
		}
	},
	skeptical_response = {
		dialog = "Yeah, sure, whatever you say.",
		response = "Hey man, I swear it's true! My friend said his friend heard it himself.",
	},
	got_money = {
		dialog = function(panel, key)
			return Format("I have %s%d.", nut.currency.symbol, LocalPlayer():getChar():getMoney())
		end,
		response = function(panel, key)
			return Format("Good for you, %s", LocalPlayer():getChar():getName())
		end,
		can_see = function(panel, key)
			return LocalPlayer():getChar():getMoney() > 0
		end,
	},
	exit = {
		dialog = "Exit",
		callback = function(panel, key)
			panel:Close()
		end,
	},
}

local PANEL = {}

function PANEL:Init()
	self:SetTitle("Dialog")
	self:SetSize(ScrW() * .4, ScrH() * .4)
	self:SetPos((ScrW() * .5) - (self:GetWide() / 2), ScrH() * .95 - self:GetTall())
	self:ShowCloseButton(true)
	self:MakePopup()

	self.modelDisplay = self:Add("DModelPanel")
	self.modelDisplay:Dock(LEFT)
	self.modelDisplay:SetWide(self:GetWide() / 3)
	self.modelDisplay:SetZPos(1)
	self.modelDisplay:SetFOV(28)
	self.modelDisplay:SetCamPos(Vector(50, 0, 64))
	self.modelDisplay:SetLookAt(Vector(0, 0, 64))
	function self.modelDisplay:LayoutEntity() return end

	self.content = self:Add("DPanel")
	self.content:Dock(RIGHT)
	self.content:SetWide(self:GetWide() - self.modelDisplay:GetWide())
	self.content:SetZPos(2)

	self.dialogText = self.content:Add("DLabel")
	self.dialogText:Dock(TOP)
	self.dialogText:DockMargin(2,0,2,4)
	self.dialogText:SetZPos(3)
	self.dialogText:SetFont("Dialog_Font")
	self.dialogText:SetAutoStretchVertical(true)
	self.dialogText:SetWrap(true)

	self.dialogOptions = self.content:Add("DScrollPanel")
	self.dialogOptions:Dock(FILL)
	self.dialogOptions:SetZPos(4)

	--self:AddDialogOptions(DEV_CONVERSATION)

	self:SizeToContentsY()
end

function PANEL:InitiateDevDialog()
	self:AddDialogOptions(DEV_CONVERSATION)
end

function PANEL:PerformLayout(w, h)
	local titlePush = 0

	if ( IsValid( self.imgIcon ) ) then

		self.imgIcon:SetPos( 5, 5 )
		self.imgIcon:SetSize( 16, 16 )
		titlePush = 16

	end

	self.btnClose:SetPos( self:GetWide() - 31 - 4, 0 )
	self.btnClose:SetSize( 31, 24 )

	self.btnMaxim:SetPos( self:GetWide() - 31 * 2 - 4, 0 )
	self.btnMaxim:SetSize( 31, 24 )

	self.btnMinim:SetPos( self:GetWide() - 31 * 3 - 4, 0 )
	self.btnMinim:SetSize( 31, 24 )

	self.lblTitle:SetPos( 8 + titlePush, 2 )
	self.lblTitle:SetSize( self:GetWide() - 25 - titlePush, 20 )

	self:SizeToContentsY()
end

function PANEL:SizeToContentsY()
	local children = self.dialogOptions:GetCanvas():GetChildren()
	local maxHeight = 24 + self.dialogText:GetTall() -- height for title bar of frames plus dialog
	if children and #children > 0 then
		for _,dialog in ipairs(children) do
			maxHeight = maxHeight + dialog:GetTall() + 8
		end
	end

	if maxHeight < ScrH() * .25 then
		maxHeight = ScrH() * .25
	end

	self:SetTall(maxHeight)
	self:SetPos((ScrW() * .5) - (self:GetWide() / 2), ScrH() * .95 - self:GetTall())
end

local function defaultDialogCallback(panel, key)
	panel:ClearDialogOptions()

	local dialogData = panel.conversations[key]
	local options = dialogData.options or panel.conversations.opening.options

	for _,dialogKey in ipairs(options) do
		local dialogData = panel.conversations[dialogKey]

		if dialogData.can_see and !dialogData.can_see(panel, dialogKey) then
			continue 
		end

		panel:AddDialogOption((isfunction(dialogData.dialog) and dialogData.dialog(panel, dialogKey)) or dialogData.dialog, dialogKey, dialogData.callback)
	end

	panel:SetText((isfunction(dialogData.response) and dialogData.response(panel, key)) or dialogData.response or "")
end

function PANEL:BackToOpening()
	if !self.conversations then return end

	defaultDialogCallback(self, "opening")
end

function PANEL:AddDialogOptions(data)
	self.conversations = data
	local openingDialog = data.opening
	if !openingDialog then
		error("Invalid data passed to function, conversation must have an opening!\n")
	end

	self:SetText((isfunction(openingDialog.response) and openingDialog.response(self, "opening")) or openingDialog.response or "")
	
	if openingDialog.options then
		for _,dialog in ipairs(openingDialog.options) do
			local dialogData = data[dialog]
			if !dialogData then
				error("Specified dialog doesn't exist!\n")
			end

			if dialogData.can_see and !dialogData.can_see(self, dialog) then
				continue 
			end

			self:AddDialogOption((isfunction(dialogData.dialog) and dialogData.dialog(self, dialog)) or dialogData.dialog, dialog, dialogData.callback)
		end
	end
end

-- if ur not gonna have a custom callback u really need a key
function PANEL:AddDialogOption(text, key, callback)
	callback = callback or defaultDialogCallback

	local choice = self.dialogOptions:Add("DButton")
	choice:Dock(TOP)
	choice:DockMargin(4, 4, 4, 0)
	choice:SetText(text)
	choice.DoClick = function(btn)
		callback(self, key)
	end

	self:InvalidateLayout(true)
end

function PANEL:SetText(text)
	self.dialogText:SetText(text)
	self.dialogText:SizeToContentsX()
	self:InvalidateLayout(true)
end

function PANEL:SetModel(model)
	self.modelDisplay:SetModel(model)
end

function PANEL:ClearDialogOptions()
	self.dialogOptions:Clear()
end

vgui.Register("hdNPCDialog", PANEL, "DFrame")