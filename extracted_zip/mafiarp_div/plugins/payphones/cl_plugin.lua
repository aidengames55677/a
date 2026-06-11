-- "gamemodes\\mafiarp\\plugins\\payphones\\cl_plugin.lua"

local PLUGIN = PLUGIN
local STATE_RINGING = 1
local STATE_ACTIVE = 2

/*
	Networking
*/

local function nutOpenDialer(len)
	vgui.Create("nutPhoneDialer")
end
net.Receive("nutOpenDialer", nutOpenDialer)

local function nutPhoneCallCreated(len)
	local index = net.ReadUInt(32)
	local callData = {
		state = net.ReadUInt(4),
	}

	local callMemberCount = net.ReadUInt(32)
	local listeners = {}
	for i = 1, callMemberCount do
		local ply = net.ReadEntity()
		table.insert(listeners, ply)
	end

	callData.listeners = listeners

	PLUGIN.ActiveCalls[index] = callData

	hook.Run("PhoneCallCreated", index, callData)
end
net.Receive("nutPhoneCallCreated", nutPhoneCallCreated)

local function nutPhoneCallDestroyed(len)
	local index = net.ReadUInt(32)

	local callData = PLUGIN.ActiveCalls[index]
	if !callData then return end

	hook.Run("PhoneCallDestroyed", index, callData)

	PLUGIN.ActiveCalls[index] = nil
end
net.Receive("nutPhoneCallDestroyed", nutPhoneCallDestroyed)

local function nutPhoneCallJoined(len)
	local index = net.ReadUInt(32)
	local listener = net.ReadEntity()

	local callData = PLUGIN.ActiveCalls[index]
	if !callData then return end

	table.insert(callData.listeners, listener)

	local oldState = callData.state
	if oldState == STATE_RINGING then
		callData.state = STATE_ACTIVE

		hook.Run("PhoneCallStateChanged", index, callData, oldState)
	end

	hook.Run("PhoneCallJoined", listener, index, callData)
end
net.Receive("nutPhoneCallJoined", nutPhoneCallJoined)

local function nutPhoneCallLeft(len)
	local index = net.ReadUInt(32)
	local listener = net.ReadEntity()

	local callData = PLUGIN.ActiveCalls[index]
	if !callData then return end

	table.RemoveByValue(callData.listeners, listener)

	hook.Run("PhoneCallLeft", listener, index, callData)
end
net.Receive("nutPhoneCallLeft", nutPhoneCallLeft)

local function nutPhoneCallDenied(len)
	local index = net.ReadUInt(32)

	local callData = PLUGIN.ActiveCalls[index]
	if !callData then return end

	hook.Run("PhoneCallDenied", index, callData)
end
net.Receive("nutPhoneCallDenied", nutPhoneCallDenied)



local function nutPhoneCopyClipboard()
	local number = net.ReadString()
	SetClipboardText(number)
end
net.Receive("nutPhoneCopyNumber", nutPhoneCopyClipboard)

/*
	Hooks
*/

function PLUGIN:PhoneCallCreated(index, callData)
	if #callData.listeners == 0 and callData.state == STATE_RINGING then
		hook.Run("PhoneCallOutgoing", index, callData)
	end
end

function PLUGIN:PhoneCallDestroyed(index, callData)
	if self.OutgoingCall then
		self.OutgoingCall = false
	end
end

function PLUGIN:PhoneCallDenied(index, callData)
	nut.util.notify("The call was denied.")
end

function PLUGIN:PhoneCallStateChanged(index, callData, oldState)
	if oldState == STATE_RINGING and callData.state == STATE_ACTIVE and self.OutgoingCall then
		self.OutgoingCall = false
	end
end

function PLUGIN:PhoneCallOutgoing(index, callData)
	if !self.OutgoingCall then
		self.OutgoingCall = true
	end

	nut.util.notify("Calling, use the telephone again to hang up.")
end

function PLUGIN:Think()
	if self.OutgoingCall then
		if !self.nextDialingRing then
			self.nextDialingRing = CurTime()
		end

		if self.nextDialingRing <= CurTime() then
			self.nextDialingRing = CurTime() + 4
			self.lastDialingRing = CurTime()
		end

		if self.lastDialingRing and self.lastDialingRing + 0.3 <= CurTime() and self.nextDialingRing - 3 > CurTime() then
			surface.PlaySound("garrysmod/ui_hover.wav")
			self.lastDialingRing = CurTime()
		end
	elseif self.nextDialingRing then
		self.nextDialingRing = nil
	end
end

local bindKey = KEY_G

local function GetItemWithDataKeyValue(inv, class, key, value)
	local items = inv:getItemsOfType(class);
	local foundItem;

	for _,item in pairs(items) do
		if item:getData(key) == value then
			foundItem = item;
			break
		end
	end

	return foundItem;
end

function PLUGIN:PlayerButtonDown(client, key)
	if client:GetNW2Int('nutPhoneCall', 0) == 0 then return end
	if not client or not client:Alive() or not client:getChar() then return end
	if (not IsFirstTimePredicted()) then return end

	local inventory = client:getChar():getInv()
	local phoneItem = GetItemWithDataKeyValue(inventory, "phone", "enabled", true)

	if phoneItem and key == bindKey then
		client:EmitSound('ui/buttonclick.wav')

		net.Start("nut.PhoneMode")
			net.WriteBool(true)
		net.SendToServer()
		
		permissions.EnableVoiceChat(true)

		return
	end

	local radioItem = GetItemWithDataKeyValue(inventory, "radio", "power", true)

	if radioItem and key == bindKey then
		client:EmitSound('ui/buttonclick.wav')

		net.Start("nut.PhoneMode")
			net.WriteBool(true)
		net.SendToServer()
		
		permissions.EnableVoiceChat(true)
		--RunConsoleCommand("+voicerecord")
	end
end

function PLUGIN:PlayerButtonUp(client, key)
	if client:GetNW2Int('nutPhoneCall', 0) == 0 then return end
	if not client or not client:Alive() or not client:getChar() then return end
	if (not IsFirstTimePredicted()) then return end

	local inventory = client:getChar():getInv()
	local phoneItem = GetItemWithDataKeyValue(inventory, "phone", "enabled", true)

	if phoneItem and key == bindKey then
		client:EmitSound('ui/buttonclick.wav')

		net.Start("nut.PhoneMode")
			net.WriteBool(false)
		net.SendToServer()
		
		permissions.EnableVoiceChat(false)

		return
	end

	local radioItem = GetItemWithDataKeyValue(inventory, "radio", "power", true)

	if radioItem and key == bindKey then
		client:EmitSound('ui/buttonclick.wav')

		net.Start("nut.PhoneMode")
			net.WriteBool(false)
		net.SendToServer()
		
		permissions.EnableVoiceChat(false)
		RunConsoleCommand("-voicerecord")
	end
end