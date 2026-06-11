-- "gamemodes\\mafiarp\\plugins\\languages\\sh_plugin.lua"

local PLUGIN = PLUGIN
PLUGIN.name = "Languages"
PLUGIN.author = "rusty"
PLUGIN.desc = "Add other languages as chat-types."

nut.util.include("sv_plugin.lua")
nut.util.include("cl_plugin.lua")

LANGUAGE_ITALIAN = bit.lshift(1, 0)
LANGUAGE_RUSSIAN = bit.lshift(1, 1)
LANGUAGE_JAPANESE = bit.lshift(1, 2)
LANGUAGE_SPANISH = bit.lshift(1, 3)
LANGUAGE_FRENCH = bit.lshift(1, 4)
LANGUAGE_CHINESE = bit.lshift(1, 5)
LANGUAGE_KOREAN = bit.lshift(1, 6)
LANGUAGE_GERMAN = bit.lshift(1, 7)
LANGUAGE_YIDDISH = bit.lshift(1, 8)
LANGUAGE_GAELIC = bit.lshift(1, 9)
LANGUAGE_POLISH = bit.lshift(1, 10)
LANGUAGE_GREEK = bit.lshift(1, 11)
LANGUAGE_ARABIC = bit.lshift(1, 12)
LANGUAGE_ROMANI = bit.lshift(1, 13)
LANGUAGE_ARMENIAN = bit.lshift(1, 14)

PLUGIN.Languages = {
	[LANGUAGE_ITALIAN] = {
		name = "Italian",
		prefix = "ita",
		knows_chat = "%s %s in Italian, \"%s\"",
		unknown_chat = "%s %s something in another language.",
	},
	[LANGUAGE_RUSSIAN] = {
		name = "Russian",
		prefix = "rus",
		knows_chat = "%s %s in Russian, \"%s\"",
		unknown_chat = "%s %s something in another language.",
	},
	[LANGUAGE_JAPANESE] = {
		name = "Japanese",
		prefix = "jap",
		knows_chat = "%s %s in Japanese, \"%s\"",
		unknown_chat = "%s %s something in another language.",
	},
	[LANGUAGE_SPANISH] = {
		name = "Spanish",
		prefix = "spa",
		knows_chat = "%s %s in Spanish, \"%s\"",
		unknown_chat = "%s %s something in another language.",
	},
	[LANGUAGE_FRENCH] = {
		name = "French",
		prefix = "fre",
		knows_chat = "%s %s in French, \"%s\"",
		unknown_chat = "%s %s something in another language.",
	},
	[LANGUAGE_CHINESE] = {
		name = "Mandarin",
		prefix = "man",
		knows_chat = "%s %s in Mandarin, \"%s\"",
		unknown_chat = "%s %s something in another language.",
	},
	[LANGUAGE_KOREAN] = {
		name = "Korean",
		prefix = "kor",
		knows_chat = "%s %s in Korean, \"%s\"",
		unknown_chat = "%s %s something in another language.",
	},
	[LANGUAGE_GERMAN] = {
		name = "German",
		prefix = "ger",
		knows_chat = "%s %s in German, \"%s\"",
		unknown_chat = "%s %s something in another language.",
	},
	[LANGUAGE_YIDDISH] = {
		name = "Yiddish",
		prefix = "yid",
		knows_chat = "%s %s in Yiddish, \"%s\"",
		unknown_chat = "%s %s something in another language.",
	},
	[LANGUAGE_GAELIC] = {
		name = "Gaelic",
		prefix = "gae",
		knows_chat = "%s %s in Gaelic, \"%s\"",
		unknown_chat = "%s %s something in another language.",
	},
	[LANGUAGE_POLISH] = {
		name = "Polish",
		prefix = "pol",
		knows_chat = "%s %s in Polish, \"%s\"",
		unknown_chat = "%s %s something in another language.",
	},
	[LANGUAGE_GREEK] = {
		name = "Greek",
		prefix = "gre",
		knows_chat = "%s %s in Greek, \"%s\"",
		unknown_chat = "%s %s something in another language.",
	},
	[LANGUAGE_ARABIC] = {
		name = "Arabic",
		prefix = "ara",
		knows_chat = "%s %s in Arabic, \"%s\"",
		unknown_chat = "%s %s something in another language.",
	},
	[LANGUAGE_ROMANI] = {
		name = "Romani",
		prefix = "rom",
		knows_chat = "%s %s in Romani, \"%s\"",
		unknown_chat = "%s %s something in another language.",
	},
	[LANGUAGE_ROMANI] = {
		name = "Romani",
		prefix = "rom",
		knows_chat = "%s %s in Romani, \"%s\"",
		unknown_chat = "%s %s something in another language.",
	},
	[LANGUAGE_ARMENIAN] = {
		name = "Armenian",
		prefix = "arm",
		knows_chat = "%s %s in Armenian, \"%s\"",
		unknown_chat = "%s %s something in another language.",
	},
}
PLUGIN.CanManageLanguages = {
	communitymanager = true,
	founder = true,
}

local CHARACTER = nut.meta.character

function CHARACTER:knowsLanguage(lang)
	return bit.band(self:getData("knownLanguages", 0), lang) == lang
end

hook.Add("InitializedConfig", "nutLanguageChatTypes", function()
	for i,data in next, PLUGIN.Languages do
		-- The default in-character chat.
		nut.chat.register(data.prefix, {
			prefix = {"/"..data.prefix},
			onCanHear = nut.config.get("chatRange", 280),
			onCanSay = function(speaker, text)
				if !speaker:Alive() then
					speaker:notifyLocalized("noPerm")

					return false
				end

				if !speaker:getChar():knowsLanguage(i) then
					speaker:notify("You don't speak this language.")

					return false
				end

				return true
			end,
			onChatAdd = function(speaker, text, anonymous)
				local color = nut.config.get("chatColor")
				local name = anonymous and L"someone" or hook.Run("GetDisplayedName", speaker, chatType) or (IsValid(speaker) and speaker:Name() or "Console")

				if (LocalPlayer():GetEyeTrace().Entity == speaker) then
					color = nut.config.get("chatListenColor")
				end

				chat.AddText(color, string.format(LocalPlayer():getChar():knowsLanguage(i) and data.knows_chat or data.unknown_chat, name, "says", text))
			end
		})

		nut.chat.register(data.prefix.."w", {
			prefix = {"/"..data.prefix.."w", "/"..data.prefix.."whisper"},
			onCanHear = nut.config.get("chatRange", 280) * 0.25,
			onCanSay = function(speaker, text)
				if !speaker:Alive() then
					speaker:notifyLocalized("noPerm")

					return false
				end

				if !speaker:getChar():knowsLanguage(i) then
					speaker:notify("You don't speak this language.")

					return false
				end

				return true
			end,
			onChatAdd = function(speaker, text, anonymous)
				local color = nut.config.get("chatColor")
				local name = anonymous and L"someone" or hook.Run("GetDisplayedName", speaker, chatType) or (IsValid(speaker) and speaker:Name() or "Console")

				if (LocalPlayer():GetEyeTrace().Entity == speaker) then
					color = nut.config.get("chatListenColor")
				end

				color.r = color.r - 35
				color.g = color.g - 35
				color.b = color.b - 35

				chat.AddText(color, string.format(LocalPlayer():getChar():knowsLanguage(i) and data.knows_chat or data.unknown_chat, name, "whispers", text))
			end
		})

		nut.chat.register(data.prefix.."y", {
			prefix = {"/"..data.prefix.."y", "/"..data.prefix.."yell"},
			onCanHear = nut.config.get("chatRange", 280) * 2,
			onCanSay = function(speaker, text)
				if !speaker:Alive() then
					speaker:notifyLocalized("noPerm")

					return false
				end

				if !speaker:getChar():knowsLanguage(i) then
					speaker:notify("You don't speak this language.")

					return false
				end

				return true
			end,
			onChatAdd = function(speaker, text, anonymous)
				local color = nut.config.get("chatColor")
				local name = anonymous and L"someone" or hook.Run("GetDisplayedName", speaker, chatType) or (IsValid(speaker) and speaker:Name() or "Console")

				if (LocalPlayer():GetEyeTrace().Entity == speaker) then
					color = nut.config.get("chatListenColor")
				end

				color.r = color.r + 35
				color.g = color.g + 35
				color.b = color.b + 35

				chat.AddText(color, string.format(LocalPlayer():getChar():knowsLanguage(i) and data.knows_chat or data.unknown_chat, name, "yells", text))
			end
		})
	end
end)