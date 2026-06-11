-- "gamemodes\\mafiarp\\plugins\\payphones\\derma\\cl_phonedialer.lua"

local PLUGIN = PLUGIN
local PANEL = {}

/*
	I hate this, frankly.
*/

/*
local function drawCircle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

local function getDist(mouseX, mouseY, centerX, centerY)
	return math.sqrt((centerX-mouseX)^2 + (centerY-mouseY)^2)
end

local function isClicking(pnl, mouseX, mouseY)
	local centerX = pnl:GetWide() / 2
	local centerY = pnl:GetTall() / 2
	local dist = getDist(mouseX, mouseY, centerX, centerY)

	if dist > centerX or dist < centerX - (centerX*0.75) then return end

	if !pnl.lastAngle then
		pnl.lastAngle = math.atan2(mouseY - centerY, mouseX - centerX)
	end
	
	pnl.number = nil
	pnl.clicking = true
end

local function goBack(pnl)
	pnl.goBack = true
	pnl.clicking = false
end

local function clear(pnl)
	goBack(pnl)
	pnl.newAngle = nil
	pnl.lastAngle = nil
	pnl.number = nil
end

local function result(pnl)
	local parent = pnl:GetParent()
	local label = parent.dialedNumber
	local labelText = label:GetText()
	if #labelText == 4 then
		clear(pnl)
		return
	end

	if pnl.number == 10 then
		pnl.number = 0
	end

	label:SetText(labelText..(pnl.number or ""))

	clear(pnl)
end

local function rotate(pnl, mouseX, mouseY)
	if !pnl.currentAngle then
		pnl.currentAngle = 1
	end

	if pnl.goBack and pnl.currentAngle and pnl.currentAngle > 1 then
		pnl.currentAngle = pnl.currentAngle - 0.015
	elseif pnl.goBack and pnl.currentAngle <= 1 then
		pnl.currentAngle = 1
		pnl.goBack = false
	end

	if !pnl.clicking or pnl.currentAngle > math.pi*2 then return end

	if pnl.currentAngle < 1 then
		pnl.currentAngle = 1
		return
	end

	local centerX = pnl:GetWide() / 2
	local centerY = pnl:GetTall() / 2
	local dist = getDist(mouseX, mouseY, centerX, centerY)

	if dist > centerX or dist < centerX - (centerX*0.75) then
		clear(pnl)
		return 
	end

	local n = math.floor((pnl.currentAngle-1.1) / ((math.pi*2) - 0.8) * 11)
	if n > 0 then
		pnl.number = n
	else
		pnl.number = nil
	end

	pnl.newAngle = math.atan2(mouseY - centerY, mouseX - centerX)

	local delta = (pnl.currentAngle - (pnl.lastAngle - pnl.newAngle))

	if delta > 0 then
		pnl.currentAngle = delta
	else
		pnl.currentAngle = math.pi*2 + delta
	end

	pnl.lastAngle = pnl.newAngle
end

local function PaintRotary(pnl, w, h)
	if !pnl.currentAngle then
		pnl.currentAngle = 1
	end

	if !pnl.triangleSpec then
		pnl.triangleSpec = {
			{x = w * 0.85, y = h * 0.5},
			{x = w * 0.95, y = h * 0.45},
			{x = w * 0.95, y = h * 0.55},
		}
	end

	surface.SetDrawColor( 255, 255, 255, 255 )
	draw.NoTexture()
	surface.DrawPoly( pnl.triangleSpec )

	local x, y = pnl:LocalCursorPos()
	rotate(pnl, x, y)

	local center_x = w / 2
	local center_y = h / 2

	surface.SetDrawColor(255, 255, 255)
	surface.DrawCircle(center_x, center_y, center_x * 0.75, 255, 255, 255)

	surface.SetDrawColor(255, 255, 255)
	surface.DrawCircle(center_x, center_y, center_x * 0.525, 255, 255, 255)

	for i = 0, 9 do
		local a = pnl.currentAngle + i/2
		local x = math.cos(a) * 150
		local y = math.sin(a) * 150
		local n = (10-i)%10

		if pnl.number and pnl.number % 10 == n then
			surface.SetDrawColor(255, 0, 0, 255)
		else
			surface.SetDrawColor(255, 255, 255, 255)
		end
		draw.NoTexture()
		drawCircle(center_x + x, center_y + y, 20, 20)

		surface.SetFont("nutGenericFont")
		surface.SetTextColor(0, 0, 0)

		local tW, tH = surface.GetTextSize(n)

		surface.SetTextPos(center_x + x - (tW / 2), center_y + y - (tH / 2))
		surface.DrawText(n)
	end
end

local function OnMousePressed(pnl, keyCode)
	if keyCode == MOUSE_LEFT then
		local x, y = pnl:LocalCursorPos()
		isClicking(pnl, x, y)
	end
end

local function OnMouseReleased(pnl, keyCode)
	if keyCode == MOUSE_LEFT then
		result(pnl)
	end
end

local function RotaryThink(pnl)
	if pnl.clicking and !pnl:IsHovered() then
		clear(pnl)
		return
	end
end

local function MakeCall(pnl)
	local parent = pnl:GetParent()
	local label = parent.dialedNumber
	local labelText = label:GetText()

	label:SetText("")
	net.Start("Payphone_DialNumber")
		net.WriteString(labelText)
	net.SendToServer()

	timer.Simple(0, function()
		parent.callStarted = true
		parent:Close()
	end)
end

-- rotary gui init
function PANEL:Init()
	self:SetTitle("Phone")
	self:SetSize(ScrW() * 0.3, ScrH() * 0.55)
	self:Center()
	self:MakePopup()

	self.dialedNumber = self:Add("DLabel")
	self.dialedNumber:SetZPos(1)
	self.dialedNumber:SetFont("nutSubTitleFont")
	self.dialedNumber:SetText("")
	self.dialedNumber:SetContentAlignment(5)
	self.dialedNumber:Dock(TOP)
	self.dialedNumber:SizeToContents()
	self.dialedNumber:DockMargin(0, 0, 0, 0)

	self.dialer = self:Add("DPanel")
	self.dialer:SetZPos(2)
	self.dialer:Dock(FILL)
	self.dialer.Paint = PaintRotary
	self.dialer.OnMousePressed = OnMousePressed
	self.dialer.OnMouseReleased = OnMouseReleased
	self.dialer.Think = RotaryThink

	self.call = self:Add("DButton")
	self.call:SetZPos(3)
	self.call:Dock(BOTTOM)
	self.call:SetText("Call")
	self.call.DoClick = MakeCall
end
*/

local function NumberButton(pnl)
	local label = pnl:GetParent():GetParent().dialedNumber
	if #label:GetText() >= 7 then
		return
	end

	label:SetText(label:GetText()..pnl.number)
end

local function BackButton(pnl)
	local label = pnl:GetParent():GetParent().dialedNumber
	local labelText = label:GetText()
	if #labelText == 0 then
		return
	end

	label:SetText(labelText:sub(1, #labelText - 1))
end

local function MakeCall(pnl)
	local mainPanel = pnl:GetParent():GetParent()
	local label = mainPanel.dialedNumber
	local labelText = label:GetText()

	label:SetText("")
	net.Start("Payphone_DialNumber")
		net.WriteString(labelText)
	net.SendToServer()

	timer.Simple(0, function()
		mainPanel.callStarted = true
		mainPanel:Close()
	end)
end

function PANEL:Init()
	self:SetTitle("Phone")
	self:SetSize(ScrW() * 0.2, ScrH() * 0.55)
	self:Center()
	self:MakePopup()

	self.dialedNumber = self:Add("DLabel")
	self.dialedNumber:SetZPos(1)
	self.dialedNumber:SetFont("nutSubTitleFont")
	self.dialedNumber:SetText("")
	self.dialedNumber:SetContentAlignment(5)
	self.dialedNumber:Dock(TOP)
	self.dialedNumber:SizeToContents()
	self.dialedNumber:DockMargin(0, 10, 0, 10)

	local nextNumber = 1

	for rowIndex = 1,3 do
		local row = self:Add("DPanel")
		row:SetZPos(rowIndex + 1)
		row:Dock(TOP)
		row:SetTall(ScrH() * 0.11)

		self["numberRow_"..rowIndex] = row

		for keyIndex = 1,3 do
			local number = row:Add("DButton")
			number:SetContentAlignment(5)
			number:SetFont("nutTitleFont")
			number:SetText(nextNumber)
			number:Dock(LEFT)
			number:SetWide(ScrW() * 0.06495)
			number.DoClick = NumberButton
			number.number = nextNumber

			self["number_"..nextNumber] = number
			nextNumber = nextNumber + 1
		end
	end

	local finalRow = self:Add("DPanel")
	finalRow:SetZPos(5)
	finalRow:Dock(TOP)
	finalRow:SetTall(ScrH() * 0.11)

	self["numberRow_4"] = row

	local back = finalRow:Add("DButton")
	back:SetContentAlignment(5)
	back:SetFont("nutTitleFont")
	back:SetText("<")
	back:Dock(LEFT)
	back:SetWide(ScrW() * 0.06495)
	back.DoClick = BackButton

	local zero = finalRow:Add("DButton")
	zero:SetContentAlignment(5)
	zero:SetFont("nutTitleFont")
	zero:SetText("0")
	zero:Dock(LEFT)
	zero:SetWide(ScrW() * 0.06495)
	zero.DoClick = NumberButton
	zero.number = 0

	local call = finalRow:Add("DButton")
	call:SetContentAlignment(5)
	call:SetFont("nutTitleFont")
	call:SetText("+")
	call:Dock(LEFT)
	call:SetWide(ScrW() * 0.06495)
	call.DoClick = MakeCall
end

function PANEL:SetEntity(ent)
	self.entity = ent
	self:SetTitle("Phone (#"..ent:GetPhoneNumber()..")")
end

function PANEL:OnClose()
	if IsValid(self.entity) and !self.callStarted then
		net.Start("Payphone_HangUp")
		net.SendToServer()
	end
end

vgui.Register("nutPhoneDialer", PANEL, "DFrame")