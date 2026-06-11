nut.chat = nut.chat or {}
nut.chat.classes = nut.char.classes or {}

local DUMMY_COMMAND = {syntax = "<string text>", onRun = function() end}

local bannedWords = {
    "Nigga",
    "Nigger",
    "n1gga",
    "n1gger",
    "nazi",
    "nigg3r",
    "nigg4h",
    "nigga",
    "niggah",
    "niggas",
    "niggaz",
    "nigger",
    "niggers"
}

function HSLToRGB(h, s, l)
    local r, g, b

    if s == 0 then
        r, g, b = l, l, l -- achromatic
    else
        local function hue2rgb(p, q, t)
            if t < 0   then t = t + 1 end
            if t > 1   then t = t - 1 end
            if t < 1/6 then return p + (q - p) * 6 * t end
            if t < 1/2 then return q end
            if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
            return p
        end

        local q = l < 0.5 and l * (1 + s) or l + s - l * s
        local p = 2 * l - q

        r = hue2rgb(p, q, h + 1/3)
        g = hue2rgb(p, q, h)
        b = hue2rgb(p, q, h - 1/3)
    end

    return Color(r * 255, g * 255, b * 255)
end

function SplitRainbowText(text, icon, timestamp, speaker)
    chat.AddText(icon, timestamp, color_offRed, " [OOC] ", speaker) -- add these elements in default color
    local hueStep = 1 / #text -- step size for hue
    for i = 1, #text do
        local char = text:sub(i, i) -- get character at position i
        if char ~= "\n" then -- ignore newlines
            local hue = (i - 1) * hueStep -- calculate hue
            local color = HSLToRGB(hue, 1, 0.5) -- convert HSL to RGB
            chat.AddText(color, char) -- add character with color
        else
            chat.AddText("\n") -- add newline
        end
    end
end

if (not nut.command) then
	include("sh_command.lua")
end

-- Returns a timestamp
function nut.chat.timestamp(ooc)
	return nut.config.get("chatShowTime") and (ooc and " " or "") .. "(" .. nut.date.getFormatted("%H:%M") .. ")" .. (ooc and "" or " ") or ""
end

local color_yellow = Color(242, 230, 160)

-- Registers a new chat type with the information provided.
function nut.chat.register(chatType, data)
	if (not data.onCanHear) then
		-- Let's see first if a dynamic radius has been set.
		if (isfunction(data.radius)) then
			-- If this is the case, then it gives the same situation where onCanHear property is a number.
			-- But instead of entering a static number, the radius function will be called each time.
			-- This can be useful if you want it to be linked to a variable that can be changed.
			data.onCanHear = function(speaker, listener)
				-- Squared distances will always perform better than standard distances.
				return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= (data.radius() ^ 2)
			end
		elseif (isnumber(data.radius)) then
			-- To avoid confusion, the radius can be a static number.
			-- In this case, we use the same method as the one used for the "onCanHear" property.
			local range = data.radius ^ 2

			data.onCanHear = function(speaker, listener)
				return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= range
			end
		else
			-- Have a substitute if the canHear and radius properties are not found.
			data.onCanHear = function(speaker, listener)
				-- The speaker will be heard by everyone.
				return true
			end
		end
	elseif (isnumber(data.onCanHear)) then
		-- Use the value as a range and create a function to compare distances.
		local range = data.onCanHear ^ 2

		data.onCanHear = function(speaker, listener)
			-- Length2DSqr is faster than Length2D, so just check the squares.
			return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= range
		end
	end

	-- Allow players to use this chat type by default.
	if (not data.onCanSay) then
		data.onCanSay = function(speaker, text)
			if (not data.deadCanChat and not speaker:Alive()) then
				speaker:notifyLocalized("noPerm")

				return false
			end

			return true
		end
	end

	-- Chat text color.
	data.color = data.color or color_yellow

	if (not data.onChatAdd) then
		data.format = data.format or "%s: \"%s\""

		data.onChatAdd = function(speaker, text, anonymous)
			local color = data.color
			local name = anonymous and L("someone") or hook.Run("GetDisplayedName", speaker, chatType) or (IsValid(speaker) and speaker:Name() or "Console")

			if (data.onGetColor) then
				color = data.onGetColor(speaker, text)
			end

			local timestamp = nut.chat.timestamp(false)
			local translated = L2(chatType .. "Format", name, text)

			chat.AddText(timestamp, color, translated or string.format(data.format, name, text))
		end
	end

	if (CLIENT and data.prefix) then
		if (type(data.prefix) == "table") then
			for _, v in ipairs(data.prefix) do
				if (v:sub(1, 1) == "/") then
					nut.command.add(v:sub(2), DUMMY_COMMAND)
				end
			end
		else
			nut.command.add(chatType, DUMMY_COMMAND)
		end
	end

	data.filter = data.filter or "ic"

	-- Add the chat type to the list of classes.
	nut.chat.classes[chatType] = data
end

-- Identifies which chat mode should be used.
function nut.chat.parse(client, message, noSend)
	local anonymous = false
	local chatType = "ic"

	-- Loop through all chat classes and see if the message contains their prefix.
	for k, v in pairs(nut.chat.classes) do
		local isChosen = false
		local chosenPrefix = ""
		local noSpaceAfter = v.noSpaceAfter

		-- Check through all prefixes if the chat type has more than one.
		if (type(v.prefix) == "table") then
			for _, prefix in ipairs(v.prefix) do
				-- Checking if the start of the message has the prefix.
				if (message:sub(1, #prefix + (noSpaceAfter and 0 or 1)):lower() == prefix .. (noSpaceAfter and "" or " "):lower()) then
					isChosen = true
					chosenPrefix = prefix .. (v.noSpaceAfter and "" or " ")

					break
				end
			end
		-- Otherwise the prefix itself is checked.
		elseif (type(v.prefix) == "string") then
			isChosen = message:sub(1, #v.prefix + (noSpaceAfter and 1 or 0)):lower() == v.prefix .. (noSpaceAfter and "" or " "):lower()
			chosenPrefix = v.prefix .. (v.noSpaceAfter and "" or " ")
		end

		-- If the checks say we have the proper chat type, then the chat type is the chosen one!
		-- If this is not chosen, the loop continues. If the loop doesn't find the correct chat
		-- type, then it falls back to IC chat as seen by the chatType variable above.
		if (isChosen) then
			-- Set the chat type to the chosen one.
			chatType = k
			-- Remove the prefix from the chat type so it does not show in the message.
			message = message:sub(#chosenPrefix + 1)

			if (nut.chat.classes[k].noSpaceAfter and message:sub(1, 1):match("%s")) then
				message = message:sub(2)
			end

			break
		end
	end

	if (not message:find("%S")) then
		return
	end

	-- Only send if needed.
	if (SERVER and not noSend) then
		-- Send the correct chat type out so other player see the message.
		nut.chat.send(client, chatType, hook.Run("PlayerMessageSend", client, chatType, message, anonymous) or message, anonymous)
	end

	-- Return the chosen chat type and the message that was sent if needed for some reason.
	-- This would be useful if you want to send the message on your own.
	return chatType, message, anonymous
end

if (SERVER) then
	-- Send a chat message using the specified chat type.
	function nut.chat.send(speaker, chatType, text, anonymous, receivers)
		local class = nut.chat.classes[chatType]

		if (class and class.onCanSay(speaker, text) ~= false) then
			if (class.onCanHear and not receivers) then
				receivers = {}

				for _, v in ipairs(player.GetAll()) do
					if (v:getChar() and class.onCanHear(speaker, v) ~= false) then
						receivers[#receivers + 1] = v
					end
				end

				if (#receivers == 0) then
					return
				end
			end
			netstream.Start(receivers, "cMsg", speaker, chatType, hook.Run("PlayerMessageSend", speaker, chatType, text, anonymous, receivers) or text, anonymous)
		end
	end
else
	-- Call onChatAdd for the appropriate chatType.
	netstream.Hook("cMsg", function(client, chatType, text, anonymous)
		if (IsValid(client)) then
			local class = nut.chat.classes[chatType]
			text = hook.Run("OnChatReceived", client, chatType, text, anonymous) or text

			if (class) then
				CHAT_CLASS = class
					class.onChatAdd(client, text, anonymous)
					if (SOUND_CUSTOM_CHAT_SOUND and SOUND_CUSTOM_CHAT_SOUND ~= "") then
						surface.PlaySound(SOUND_CUSTOM_CHAT_SOUND)
					else
						chat.PlaySound()
					end
				CHAT_CLASS = nil
			end
		end
	end)
end

-- Add the default chat types here.
do
	-- Load the chat types after the configs so we can access changed configs.
	hook.Add("InitializedConfig", "nutChatTypes", function()
		-- The default in-character chat.
		nut.chat.register("ic", {
			onCanSay =  function(speaker, text)
				for _, bannedWord in ipairs(bannedWords) do
					if string.find(text, bannedWord) then
						--[[ Replace the banned word with "bubba"
						text = string.gsub(text, bannedWord, "bubba")]]--
						-- Notify the speaker
						speaker:notifyLocalized("You have said a banned word.")
						return false
					end
				end
			end,
			format = "%s says \"%s\"",
			onGetColor = function(speaker, text)
				-- If you are looking at the speaker, make it greener to easier identify who is talking.
				if (LocalPlayer():GetEyeTrace().Entity == speaker) then
					return nut.config.get("chatListenColor")
				end

				-- Otherwise, use the normal chat color.
				return nut.config.get("chatColor")
			end,
			radius = function()
				return nut.config.get("chatRange", 280)
			end
		})

		-- Actions and such.
		nut.chat.register("me", {
			onCanSay =  function(speaker, text)
				for _, bannedWord in ipairs(bannedWords) do
					if string.find(text, bannedWord) then
						--[[ Replace the banned word with "bubba"
						text = string.gsub(text, bannedWord, "bubba")]]--
						-- Notify the speaker
						speaker:notifyLocalized("You have said a banned word.")
						return false
					end
				end
			end,
			format = "**%s %s",
			onGetColor = nut.chat.classes.ic.onGetColor,
			radius = function() return nut.config.get("chatRange", 280) end,
			prefix = {"/me", "/action"},
			font = "nutChatFontItalics",
			filter = "actions",
			deadCanChat = true
		})

		-- Actions and such.
		nut.chat.register("it", {
			onCanSay =  function(speaker, text)
				for _, bannedWord in ipairs(bannedWords) do
					if string.find(text, bannedWord) then
						--[[ Replace the banned word with "bubba"
						text = string.gsub(text, bannedWord, "bubba")]]--
						-- Notify the speaker
						speaker:notifyLocalized("You have said a banned word.")
						return false
					end
				end
			end,
			onChatAdd = function(speaker, text)
				chat.AddText(nut.chat.timestamp(false), nut.config.get("chatColor"), "**" .. text)
			end,
			radius = function()
				return nut.config.get("chatRange", 280)
			end,
			prefix = {"/it"},
			font = "nutChatFontItalics",
			filter = "actions",
			deadCanChat = true
		})

		-- Whisper chat.
		nut.chat.register("w", {
			onCanSay =  function(speaker, text)
				for _, bannedWord in ipairs(bannedWords) do
					if string.find(text, bannedWord) then
						--[[ Replace the banned word with "bubba"
						text = string.gsub(text, bannedWord, "bubba")]]--
						-- Notify the speaker
						speaker:notifyLocalized("You have said a banned word.")
						return false
					end
				end
			end,
			format = "%s whispers \"%s\"",
			onGetColor = function(speaker, text)
				local color = nut.chat.classes.ic.onGetColor(speaker, text)

				-- Make the whisper chat slightly darker than IC chat.
				return Color(color.r - 35, color.g - 35, color.b - 35)
			end,
			radius = function()
				return nut.config.get("chatRange", 280) * 0.25
			end,
			prefix = {"/w", "/whisper"}
		})

		-- Yelling out loud.
		nut.chat.register("y", {
			onCanSay =  function(speaker, text)
				for _, bannedWord in ipairs(bannedWords) do
					if string.find(text, bannedWord) then
						--[[ Replace the banned word with "bubba"
						text = string.gsub(text, bannedWord, "bubba")]]--
						-- Notify the speaker
						speaker:notifyLocalized("You have said a banned word.")
						return false
					end
				end
			end,
			format = "%s yells \"%s\"",
			onGetColor = function(speaker, text)
				local color = nut.chat.classes.ic.onGetColor(speaker, text)

				-- Make the yell chat slightly brighter than IC chat.
				return Color(color.r + 35, color.g + 35, color.b + 35)
			end,
			radius = function()
				return nut.config.get("chatRange", 280) * 2
			end,
			prefix = {"/y", "/yell"}
		})

		local color_offRed = Color(255, 50, 50)

		-- Out of character.
		nut.chat.register("ooc", {
			onCanSay =  function(speaker, text)
				for _, bannedWord in ipairs(bannedWords) do
					if string.find(text, bannedWord) then
						--[[ Replace the banned word with "bubba"
						text = string.gsub(text, bannedWord, "bubba")]]--
						-- Notify the speaker
						speaker:notifyLocalized("You have said a banned word.")
						return false
					end
				end

				if (not nut.config.get("allowGlobalOOC")) then
					speaker:notifyLocalized("Global OOC is disabled on this server.")
					return false
				elseif speaker:getChar():hasFlags("*") then
					speaker:notifyLocalized("You are OOC Banned.")
					return false
				else
					local delay = nut.config.get("oocDelay", 10)

					-- Only need to check the time if they have spoken in OOC chat before.
					if (delay > 0 and speaker.nutLastOOC) then
						local lastOOC = CurTime() - speaker.nutLastOOC

						-- Use this method of checking time in case the oocDelay config changes (may not affect admins).
						if (lastOOC <= delay and (not speaker:IsAdmin() or speaker:IsAdmin() and nut.config.get("oocDelayAdmin", false))) then
							speaker:notifyLocalized("oocDelay", delay - math.ceil(lastOOC))

							return false
						end
					end
					-- Save the last time they spoke in OOC.
					speaker.nutLastOOC = CurTime()
				end
			end,
			onChatAdd = function(speaker, text)
				local icon = "icon16/user.png"
				local customIcons = {
					["STEAM_0:1:34930764"] = "icon16/script_gear.png", -- Chessnut
					["STEAM_0:0:19814083"] = "icon16/gun.png", -- Black Tea the edgiest man
					["STEAM_0:0:50197118"] = "icon16/script_gear.png", -- Zoephix
					["STEAM_0:1:62585986"] = "icon16/tux.png", -- JayyKashta
					["STEAM_0:1:55088012"] = "icon16/script_gear.png" -- TovarischPootis
				}

				-- man, I did all that works and I deserve different icon on ooc chat
				-- if you dont like it
				-- well..
				-- it's on your own.
				if (customIcons[speaker:SteamID()]) then
					icon = customIcons[speaker:SteamID()]
				elseif (speaker:IsUserGroup("network_owner")) then
					icon = "icon16/award_star_gold_1.png"
				elseif (speaker:IsUserGroup("network_coowner")) then
					icon = "icon16/ruby.png"
				elseif (speaker:IsUserGroup("head_developer")) then
					icon = "icon16/database_gear.png"
				elseif (speaker:IsUserGroup("community_director")) then
					icon = "icon16/asterisk_yellow.png"
				elseif (speaker:IsUserGroup("supervising_administrator")) then
					icon = "icon16/user_suit.png"
				elseif (speaker:IsUserGroup("community_manager")) then
					icon = "icon16/briefcase.png"
				elseif (speaker:IsUserGroup("head_administrator")) then
					icon = "icon16/shield.png"
				elseif (speaker:IsUserGroup("administrator")) then
					icon = "icon16/star.png"
				elseif (speaker:IsUserGroup("admin")) then
					icon = "icon16/star.png"
				elseif (speaker:IsUserGroup("moderator")) then
					icon = "icon16/wrench.png"
				elseif (speaker:IsUserGroup("trial_moderator")) then
					icon = "icon16/wrench_orange.png"
				elseif (speaker:IsUserGroup("superadmin")) then
					icon = "icon16/star.png"
				elseif (speaker:IsUserGroup("user")) then
					icon = "icon16/user.png"
				elseif (speaker:IsUserGroup("vip") or speaker:IsUserGroup("donator") or speaker:IsUserGroup("donor")) then
					icon = "icon16/money_dollar.png"
				end

				if (nut.config.get("oocLimit", 0) ~= 0) and (#text > nut.config.get("oocLimit", 0)) then
					text = string.sub(text, 1, nut.config.get("oocLimit", 0)) .. "..."
				end
				icon = Material(hook.Run("GetPlayerIcon", speaker) or icon)				

				-- Check if the text starts with "rainbow:"
				if ((string.sub(text, 1, 8) == "rainbow:") or (string.sub(text, 1, 9) == "rainbow1:")) then
					-- Change the color to a rainbow
					local h = (CurTime() % 1) -- vary hue over time
					local rainbow = HSLToRGB(h, 1, 0.5) -- full saturation, half lightness
					chat.AddText(icon, nut.chat.timestamp(true), color_offRed, " [OOC] ", speaker, rainbow, ": " .. string.sub(text, 9))
				elseif string.sub(text, 1, 9) == "rainbow2:" then
					SplitRainbowText(string.sub(text, 9), icon, nut.chat.timestamp(true), speaker)
				else
					chat.AddText(icon, nut.chat.timestamp(true), color_offRed, " [OOC] ", speaker, color_white, ": " .. text)
				end


			end,
			prefix = {"//", "/ooc"},
			noSpaceAfter = true,
			filter = "ooc"
		})

		-- Local out of character.
		nut.chat.register("looc", {
			onCanSay =  function(speaker, text)
				for _, bannedWord in ipairs(bannedWords) do
					if string.find(text, bannedWord) then
						--[[ Replace the banned word with "bubba"
						text = string.gsub(text, bannedWord, "bubba")]]--
						-- Notify the speaker
						speaker:notifyLocalized("You have said a banned word.")
						return false
					end
				end

				local delay = nut.config.get("loocDelay", 0)

				-- Only need to check the time if they have spoken in LOOC chat before.
				if (speaker:IsAdmin() and nut.config.get("loocDelayAdmin", false) and delay > 0 and speaker.nutLastLOOC) then
					local lastLOOC = CurTime() - speaker.nutLastLOOC

					-- Use this method of checking time in case the oocDelay config changes (may not affect admins).
					if (lastLOOC <= delay and (not speaker:IsAdmin() or speaker:IsAdmin() and nut.config.get("loocDelayAdmin", false))) then
						speaker:notifyLocalized("loocDelay", delay - math.ceil(lastLOOC))

						return false
					end
				end

				-- Save the last time they spoke in OOC.
				speaker.nutLastLOOC = CurTime()
			end,
			onChatAdd = function(speaker, text)
				if (nut.config.get("oocLimit", 0) ~= 0) and (#text > nut.config.get("oocLimit", 0)) then
					text = string.sub(text, 1, nut.config.get("oocLimit", 0)) .. "..."
				end
				chat.AddText(nut.chat.timestamp(false), color_offRed, "[LOOC] ", nut.config.get("chatColor"), speaker:Name() .. ": " .. text)
			end,
			radius = function()
				return nut.config.get("chatRange", 280)
			end,
			prefix = {".//", "[[", "/looc"},
			noSpaceAfter = true,
			filter = "ooc"
		})

		-- Roll information in chat.
		nut.chat.register("roll", {
			format = "%s has rolled %s.",
			color = Color(155, 111, 176),
			filter = "actions",
			font = "nutChatFontItalics",
			radius = function() return nut.config.get("chatRange", 280) end,
			deadCanChat = true
		})
	end)
end

-- Private messages between players.
nut.chat.register("pm", {
	onCanSay =  function(speaker, text)
		for _, bannedWord in ipairs(bannedWords) do
			if string.find(text, bannedWord) then
				-- Replace the banned word with "bubba"
				text = string.gsub(text, bannedWord, "bubba")
				-- Notify the speaker
				speaker:notifyLocalized("You have said a banned word.")
			end
		end
	end,
	format = "[PM] %s: %s.",
	color = Color(249, 211, 89),
	filter = "pm",
	deadCanChat = true
})

local color_orange = Color(255, 150, 0)

-- Global events.
nut.chat.register("event", {
	onCanSay =  function(speaker, text)
		for _, bannedWord in ipairs(bannedWords) do
			if string.find(text, bannedWord) then
				-- Replace the banned word with "bubba"
				text = string.gsub(text, bannedWord, "bubba")
				-- Notify the speaker
				speaker:notifyLocalized("You have said a banned word.")
			end
		end

		return speaker:IsAdmin()
	end,
	onChatAdd = function(speaker, text)
		chat.AddText(nut.chat.timestamp(false), color_orange, text)
	end,
	prefix = {"/event"}
})

-- Why does ULX even have a /me command?
hook.Remove("PlayerSay", "ULXMeCheck")