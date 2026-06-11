-- "gamemodes\\mafiarp\\plugins\\payphones\\sh_plugin.lua"

local PLUGIN = PLUGIN
PLUGIN.name = "Payphones"
PLUGIN.author = "rusty"
PLUGIN.ActiveCalls = PLUGIN.ActiveCalls or {}

nut.util.include("cl_plugin.lua")
nut.util.include("sv_plugin.lua")

nut.config.add("PhoneMusic", "music/hl2_song31.mp3", "The default phone music.", nil, {
	category = "phone"
})

nut.command.add("savecharnumber", {
	syntax = "<number phone> <string name>",
	onRun = function(client, arguments)
		local number = arguments[1]
		local name = arguments[2]
		if not number or not name then return end
		local character = client:getChar()
		if not character then return end
		local inventory = character:getInv()
		if not inventory then return end
		local item = inventory:getFirstItemOfType('phone')
		if not item then return end

		local contacts = table.Copy(character:getData('savedContacts', {}))
		contacts[number] = name
		character:setData('savedContacts', contacts)
	end
})

nut.command.add("removecharnumber", {
	syntax = "<number phone>",
	onRun = function(client, arguments)
		if (!arguments[1]) then
			return L("invalidArg", client, 1)
		end

		local number = arguments[1]
		if not number then return end
		local character = client:getChar()
		if not character then return end
		local inventory = character:getInv()
		if not inventory then return end
		local item = inventory:getFirstItemOfType('phone')
		if not item then return end

		local contacts = table.Copy(character:getData('savedContacts', {}))
		contacts[number] = nil
		character:setData('savedContacts', contacts)
	end
})

nut.config.add("chatPhoneColor", Color(168, 20, 20), "The color for IC chat of the player on the other end of the phone line.", nil, {category = "chat"})

function PLUGIN:InitPostEntity()
	nut.chat.classes["ic"].onGetColor = function(speaker, text)
		-- If you are looking at the speaker, make it greener to easier identify who is talking.
		if (LocalPlayer():GetEyeTrace().Entity == speaker) then
			return nut.config.get("chatListenColor")
		end

		if LocalPlayer():GetNW2Int("IsPhoneCall", 0) == 1 && LocalPlayer():GetNW2Int("nutPhoneCall", 0) > 0 and LocalPlayer():GetNW2Int("nutPhoneCall", 0) == speaker:GetNW2Int("nutPhoneCall", 0) then
			return nut.config.get("chatPhoneColor")
		end

		-- Otherwise, use the normal chat color.
		return nut.config.get("chatColor")
	end
	nut.chat.classes["ic"].onCanHear = function(speaker, listener)
		local range = nut.config.get("chatRange", 280) ^ 2
		if listener:GetNW2Int("IsPhoneCall", 0) == 1 && listener:GetNW2Int("nutPhoneCall", 0) > 0 and listener:GetNW2Int("nutPhoneCall", 0) == speaker:GetNW2Int("nutPhoneCall", 0) then
			return true
		end

		return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= range
	end

	nut.chat.classes["w"].onGetColor = function(speaker, text)
		local color = nut.chat.classes.ic.onGetColor(speaker, text)

		-- Make the whisper chat slightly darker than IC chat.
		return Color(color.r - 35, color.g - 35, color.b - 35)
	end
	nut.chat.classes["w"].onCanHear = function(speaker, listener)
		local range = (nut.config.get("chatRange", 280) * 0.25) ^ 2
		if listener:GetNW2Int("IsPhoneCall", 0) == 1 && listener:GetNW2Int("nutPhoneCall", 0) > 0 and listener:GetNW2Int("nutPhoneCall", 0) == speaker:GetNW2Int("nutPhoneCall", 0) then
			return true
		end

		return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= range
	end

	nut.chat.classes["y"].onGetColor = function(speaker, text)
		local color = nut.chat.classes.ic.onGetColor(speaker, text)

		-- Make the yell chat slightly brighter than IC chat.
		return Color(color.r + 35, color.g + 35, color.b + 35)
	end
	nut.chat.classes["y"].onCanHear = function(speaker, listener)
		local range = (nut.config.get("chatRange", 280) * 2) ^ 2
		if listener:GetNW2Int("IsPhoneCall", 0) == 1 && listener:GetNW2Int("nutPhoneCall", 0) > 0 and listener:GetNW2Int("nutPhoneCall", 0) == speaker:GetNW2Int("nutPhoneCall", 0) then
			return true
		end

		return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= range
	end
end