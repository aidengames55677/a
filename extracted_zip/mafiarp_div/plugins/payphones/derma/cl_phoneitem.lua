-- "gamemodes\\mafiarp\\plugins\\payphones\\derma\\cl_phoneitem.lua"

local PLUGIN = PLUGIN

/*
	All old gfake phone code
*/

net.Receive("nutPhoneDermaMenu", function(len)
	local panel = vgui.Create('DFrame')
	panel:SetSize(230, 500)
	panel:MakePopup()
	panel:Center()
	panel:SetTitle('Phone')

	local inputpanel = panel:Add('DPanel')
	inputpanel:Dock(TOP)
	inputpanel:SetTall(85)

	local input = inputpanel:Add('DLabel')
	input:Dock(TOP)
	input:DockMargin(1, 1, 1, 1)
	input:SetFont('nutMenuButtonFont')
	input:SetTall(50)
	input:SetContentAlignment(5)
	input:SetText("")
	input.SetValue = input.SetText
	input.GetValue = input.GetText

	local remove = inputpanel:Add("DButton")
	remove:Dock(FILL)
	remove:DockMargin(1, 1, 1, 1)
	remove:SetFont('nutMenuButtonFont')
	remove:SetTextColor(color_white)
	remove:SetText('Clear')
	remove.Paint = function(this, w, h)
		surface.SetDrawColor(175, 45, 45, 255)
		surface.DrawRect(0, 0, w, h)
	end
	remove.DoClick = function(this)
		surface.PlaySound('ui/buttonclickrelease.wav')
		local value = tostring(input:GetText())
		if string.len(value) > 0 then
			input:SetValue(string.sub(value, 1, string.len(value) - 1))
			input:SetText(string.sub(value, 1, string.len(value) - 1))
		else
			input.oldText = value
		end
	end

	local numbers = panel:Add('DPanel')
	numbers:Dock(TOP)
	numbers:SetTall(225)
	numbers.Paint = function(this, w, h)
		surface.SetDrawColor(44, 44, 44, 255)
		surface.DrawRect(0, 0, w, h)            
	end

	-- First

	local firstline = numbers:Add('DPanel')
	firstline:Dock(BOTTOM)
	firstline:DockMargin(2, 1, 2, 0)
	firstline:SetTall(70)

	local number7 = firstline:Add('DPanel')
	number7:Dock(LEFT)
	number7:DockMargin(2, 2, 2, 2)
	number7:SetWide(67)
	number7:SetCursor('hand')
	number7.OnMousePressed = function()
		input:SetValue(input:GetValue() .. 7)
		surface.PlaySound('ui/buttonclick.wav')
	end

	local number7text = number7:Add('DLabel')
	number7text:Dock(FILL)
	number7text:SetContentAlignment(5)
	number7text:SetFont('nutMenuButtonFont')
	number7text:SetText(7)

	local number8 = firstline:Add('DPanel')
	number8:Dock(FILL)
	number8:DockMargin(2, 2, 2, 2)
	number8:SetWide(67)
	number8:SetCursor('hand')
	number8.OnMousePressed = function()
		input:SetValue(input:GetValue() .. 8)
		surface.PlaySound('ui/buttonclick.wav')
	end

	local number8text = number8:Add('DLabel')
	number8text:Dock(FILL)
	number8text:SetContentAlignment(5)
	number8text:SetFont('nutMenuButtonFont')
	number8text:SetText(8)

	local number9 = firstline:Add('DPanel')
	number9:Dock(RIGHT)
	number9:DockMargin(2, 2, 2, 2)
	number9:SetWide(67)
	number9:SetCursor('hand')
	number9.OnMousePressed = function()
		input:SetValue(input:GetValue() .. 9)
		surface.PlaySound('ui/buttonclick.wav')
	end

	local number9text = number9:Add('DLabel')
	number9text:Dock(FILL)
	number9text:SetContentAlignment(5)
	number9text:SetFont('nutMenuButtonFont')
	number9text:SetText(9)

	-- Second

	local secondline = numbers:Add('DPanel')
	secondline:DockMargin(2, 1, 2, 1)
	secondline:Dock(BOTTOM)
	secondline:SetTall(70)

	local number4 = secondline:Add('DPanel')
	number4:Dock(LEFT)
	number4:DockMargin(2, 2, 2, 2)
	number4:SetWide(67)
	number4:SetCursor('hand')
	number4.OnMousePressed = function()
		input:SetValue(input:GetValue() .. 4)
		surface.PlaySound('ui/buttonclick.wav')
	end

	local number4text = number4:Add('DLabel')
	number4text:Dock(FILL)
	number4text:SetContentAlignment(5)
	number4text:SetFont('nutMenuButtonFont')
	number4text:SetText(4)

	local number5 = secondline:Add('DPanel')
	number5:Dock(FILL)
	number5:SetWide(67)
	number5:DockMargin(2, 2, 2, 2)
	number5:SetCursor('hand')
	number5.OnMousePressed = function()
		input:SetValue(input:GetValue() .. 5)
		surface.PlaySound('ui/buttonclick.wav')
	end

	local number5text = number5:Add('DLabel')
	number5text:Dock(FILL)
	number5text:SetContentAlignment(5)
	number5text:SetFont('nutMenuButtonFont')
	number5text:SetText(5)

	local number6 = secondline:Add('DPanel')
	number6:Dock(RIGHT)
	number6:DockMargin(2, 2, 2, 2)
	number6:SetWide(67)
	number6:SetCursor('hand')
	number6.OnMousePressed = function()
		input:SetValue(input:GetValue() .. 6)
		surface.PlaySound('ui/buttonclick.wav')
	end

	local number6text = number6:Add('DLabel')
	number6text:Dock(FILL)
	number6text:SetContentAlignment(5)
	number6text:SetFont('nutMenuButtonFont')
	number6text:SetText(6)

	-- Third

	local thirdline = numbers:Add('DPanel')
	thirdline:DockMargin(2, 25, 2, 1)
	thirdline:Dock(BOTTOM)
	thirdline:SetTall(70)

	local number1 = thirdline:Add('DPanel')
	number1:Dock(LEFT)
	number1:DockMargin(2, 2, 2, 2)
	number1:SetWide(67)
	number1:SetCursor('hand')
	number1.OnMousePressed = function()
		input:SetValue(input:GetValue() .. 1)
		surface.PlaySound('ui/buttonclick.wav')
	end

	local number1text = number1:Add('DLabel')
	number1text:Dock(FILL)
	number1text:SetContentAlignment(5)
	number1text:SetFont('nutMenuButtonFont')
	number1text:SetText(1)

	local number2 = thirdline:Add('DPanel')
	number2:Dock(FILL)
	number2:DockMargin(2, 2, 2, 2)
	number2:SetWide(67)
	number2:SetCursor('hand')
	number2.OnMousePressed = function()
		input:SetValue(input:GetValue() .. 2)
		surface.PlaySound('ui/buttonclick.wav')
	end

	local number2text = number2:Add('DLabel')
	number2text:Dock(FILL)
	number2text:SetContentAlignment(5)
	number2text:SetFont('nutMenuButtonFont')
	number2text:SetText(2)

	local number3 = thirdline:Add('DPanel')
	number3:Dock(RIGHT)
	number3:DockMargin(2, 2, 2, 2)
	number3:SetWide(67)
	number3:SetCursor('hand')
	number3.OnMousePressed = function()
		input:SetValue(input:GetValue() .. 3)
		surface.PlaySound('ui/buttonclick.wav')
	end

	local number3text = number3:Add('DLabel')
	number3text:Dock(FILL)
	number3text:SetContentAlignment(5)
	number3text:SetFont('nutMenuButtonFont')
	number3text:SetText(3)

	-- Bottom buttons

	local bottombuttons = panel:Add('DPanel')
	bottombuttons:Dock(FILL)

	local zeropanel = bottombuttons:Add('DPanel')
	zeropanel:Dock(TOP)
	zeropanel:DockMargin(2, 2, 2, 2)
	zeropanel:SetTall(110)
	zeropanel.OnMousePressed = function()
		input:SetValue(input:GetValue() .. '0')
		surface.PlaySound('ui/buttonclick.wav')
	end
	zeropanel.Paint = function(this, w, h)
		surface.SetDrawColor(38, 38, 38, 255)
		surface.DrawRect(0, 0, w, h)
	end

	local zero = zeropanel:Add('DPanel')
	zero:Dock(TOP)
	zero:SetTall(65)
	zero:DockMargin(2, 2, 2, 0)
	zero:SetCursor('hand')
	zero.OnMousePressed = function()
		input:SetValue(input:GetValue() .. '0')
		surface.PlaySound('ui/buttonclick.wav')
	end

	local zerotext = zero:Add('DLabel')
	zerotext:Dock(FILL)
	zerotext:SetContentAlignment(5)
	zerotext:SetFont('nutMenuButtonFont')
	zerotext:SetText('0')

	local contacts = zeropanel:Add('DButton')
	contacts:Dock(FILL)
	contacts:DockMargin(2, 2, 2, 2)
	contacts:SetFont('nutMenuButtonFont')
	contacts:SetTextColor(color_white)
	contacts:SetText('Contacts')
	contacts.DoClick = function(this)
		surface.PlaySound('garrysmod/content_downloaded.wav')

		local list = vgui.Create('DFrame')
		list:SetSize(panel:GetSize())
		list:Center()
		list:SetTitle('Contact List')
		list:MakePopup()

		local scroll = list:Add("DScrollPanel")
		scroll:Dock(FILL)
		scroll.Paint = function(this, w, h)
			surface.SetDrawColor(35, 35, 35, 255)
			surface.DrawRect(0, 0, w, h)
		end

		local add = scroll:Add("DButton")
		add:Dock(TOP)
		add:SetTall(50)
		add:SetText("ADD")
		add:SetFont('nutMenuButtonFont')
		add:SetTextColor(color_white)
		add.Paint = function(this, w, h)
			surface.SetDrawColor(54, 170, 54, 255)
			surface.DrawRect(0, 0, w, h)
		end
		add.DoClick = function(this)
			Derma_StringRequest("Save phone number", "Which number do you want to save?", '0000000000', function(text1)
				Derma_StringRequest("Contact name", "What do you want to call this contact?", 'John Doe', function(text2)
					nut.command.send("savecharnumber", text1, text2)
					surface.PlaySound('garrysmod/save_load1.wav')
				end)
			end)
			list:Remove()
		end

		if LocalPlayer():getChar():getData('savedContacts') then
			for k, v in pairs(LocalPlayer():getChar():getData('savedContacts')) do
				local contact = scroll:Add('DButton')
				contact:Dock(TOP)
				contact:DockMargin(2, 2, 2, 2)
				contact:SetTall(30)
				contact:SetText(k .. ' (' .. v .. ')')
				contact.DoClick = function(this)
					net.Start("nutPhoneMakeCall")
						net.WriteString(tostring(k))
					net.SendToServer()
					panel:Remove()
					list:Remove()
				end

				local remove = contact:Add('DButton')
				remove:Dock(RIGHT)
				remove:DockMargin(4, 4, 4, 4)
				remove:SetWide(20)
				remove:SetText('x')
				remove.Paint = function(this, w, h)
					surface.SetDrawColor(170, 54, 54, 255)
					surface.DrawRect(0, 0, w, h)
				end
				remove.DoClick = function(this)
					nut.command.send('removecharnumber', k)
					this:GetParent():Remove()
				end
			end
		else
			local empty = scroll:Add('DLabel')
			empty:SetContentAlignment(5)
			empty:SetText('Your contact list is empty!')
			empty:SetFont('nutToolTipText')
			empty:Dock(FILL)
		end
	end

	local call = bottombuttons:Add('DButton')
	call:Dock(FILL)
	call:DockMargin(4, 4, 4, 4)
	call:SetFont('nutMenuButtonFont')
	call:SetTextColor(color_white)
	call:SetText('Call')
	call.Paint = function(this, w, h)
		surface.SetDrawColor(40, 175, 40, 255)
		surface.DrawRect(0, 0, w, h)
	end
	call.DoClick = function(this)
		surface.PlaySound('garrysmod/content_downloaded.wav')
		net.Start("nutPhoneMakeCall")
			net.WriteString(tostring(input:GetValue()))
		net.SendToServer()
		panel:Remove()
	end
end)

net.Receive("nutPhoneReceiveCall", function(len)
	local phoneNumber = net.ReadString()
	local character = LocalPlayer():getChar()
	local contacts = character:getData("savedContacts", {})
	local contactName = contacts[phoneNumber]

	local sound = CreateSound(LocalPlayer(), nut.config.get('PhoneMusic', "music/hl2_song31.mp3"))
	sound:PlayEx(0.4, 100)

	local panel = vgui.Create('DFrame')
	panel:SetSize(350, 500)
	panel:MakePopup()
	panel:Center()
	panel:SetTitle('Incoming call from #'..phoneNumber)
	panel:ShowCloseButton(false)

	local upsection = panel:Add('DPanel')
	upsection:Dock(FILL)

	local icon = upsection:Add('DPanel')
	icon:Dock(TOP)
	icon:DockMargin(4, 4, 4, 4)
	icon:SetTall(270)

	local undefined = icon:Add("DPanel")
	undefined:SetBackgroundColor(Color(15, 15, 15))
	undefined:Dock(FILL)

	local question = undefined:Add('DLabel')
	question:SetFont('nutMenuButtonFont')
	question:SetText('?')
	question:SetContentAlignment(5)
	question:Dock(FILL)

	undefined:SetToolTip(
		contactName or 'Unknown'
	)

	local buttons = upsection:Add("DPanel")
	buttons:Dock(FILL)

	local accept = buttons:Add('DButton')
	accept:SetFont('nutMenuButtonFont')
	accept:SetText('ACCEPT')
	accept:SetContentAlignment(5)
	accept:Dock(LEFT)
	accept:SetWide(167)
	accept.Paint = function(this, w, h)
		surface.SetDrawColor(40, 175, 40, 255)
		surface.DrawRect(0, 0, w, h)
	end
	accept.DoClick = function(this, w, h)
		net.Start("nutPhoneAcceptCall")
			net.WriteBool(true)
		net.SendToServer()

		panel:Remove()
		sound:Stop()
		surface.PlaySound('ui/buttonclick.wav')
	end

	local cancel = buttons:Add('DButton')
	cancel:SetFont('nutMenuButtonFont')
	cancel:SetText('CANCEL')
	cancel:SetContentAlignment(5)
	cancel:Dock(FILL)
	cancel.Paint = function(this, w, h)
		surface.SetDrawColor(175, 40, 40, 255)
		surface.DrawRect(0, 0, w, h)
	end
	cancel.DoClick = function(this, w, h)
		net.Start("nutPhoneAcceptCall")
			net.WriteBool(false)
		net.SendToServer()

		panel:Remove()
		sound:Stop()
		surface.PlaySound('ui/buttonclick.wav')
	end

	PLUGIN.incomingCall = panel
	PLUGIN.incomingCallSoundPatch = sound
end)

net.Receive("nutPhoneCallEndedPrematurely", function(len)
	if IsValid(nut.plugin.list.payphones.incomingCall) then
		nut.plugin.list.payphones.incomingCall:Close()
	end

	if IsValid(nut.plugin.list.payphones.incomingCallSoundPatch) then
		nut.plugin.list.payphones.incomingCallSoundPatch:Stop()
		nut.plugin.list.payphones.incomingCallSoundPatch = nil
	end
end)

net.Receive("nutPhoneSaveNumber", function(len, client)
	local placeholder_num = '0000000000'
	local placeholder_str = 'John Doe'
	
	Derma_StringRequest("Save phone number", "Which number do you want to save?", placeholder_num, function(text1)
		Derma_StringRequest("Contact name", "What do you want to call this contact?", placeholder_str, function(text2)
			nut.command.send("savecharnumber", text1, text2)
		end)
	end)
end)