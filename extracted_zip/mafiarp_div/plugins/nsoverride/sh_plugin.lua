-- "gamemodes\\mafiarp\\plugins\\nsoverride\\sh_plugin.lua"

PLUGIN.name = "NS Base Overrides"
PLUGIN.desc = "Overrides to base NS features without modifying the framework folder."
PLUGIN.author = "Pendred, rusty"
PLUGIN.NameBlacklist = {
	"fuck",
	"shit",
	"asshole",
	"Tony Soprano",
	"nigg",
}


nut.util.includeDir("derma")
nut.util.includeDir("libs")

/*
	Networking
*/

if SERVER then
	netstream.Hook("reset_description", function(ply)
		local data = ply:getChar():getDescgenerator()
		if isstring(data) then
			data = util.JSONToTable(data)
		end

		data.faction = ply:getChar():getFaction()
		data.model = table.KeyFromValue(nut.faction.indices[data.faction].models, ply:GetModel())
		PrintTable({(nut.plugin.list["modified_charcreation"]:GenerateDescription(data):gsub("\226\128\139#", "#"))})

		nut.command.run(
			ply,
			"chardesc",
			{(nut.plugin.list["modified_charcreation"]:GenerateDescription(data):gsub("\226\128\139#", "#"))}
		)
	end)
end

/*
	Hooks
*/

function PLUGIN:CharacterNameValid(name, data, client)
	for _,blacklist in next, self.NameBlacklist do
		if name:find(blacklist) then
			return false, "You have a disallowed string in your name!"
		end
	end
end

/*
	Character vars
*/

nut.config.add("maxDescLen", 1000, "The maximum number of characters in a description.", nil, {
	data = {min = 0, max = 1000},
	category = "characters"
})

nut.config.add("minNameLen", 4, "The minimum number of characters in a name.", nil, {
	data = {min = 0, max = 80},
	category = "characters"
})

nut.config.add("maxNameLen", 80, "The maximum number of characters in a name.", nil, {
	data = {min = 0, max = 80},
	category = "characters"
})

nut.char.registerVar("name", {
	field = "_name",
	default = "John Doe",
	index = 1,
	onValidate = function(value, data, client)
		local name, override = hook.Run("GetDefaultCharName", client, data.faction, data)

		if (isstring(name) and override) then
			return true
		end
		if (not isstring(value) or not value:find("%S")) then
			return false, "invalid", "name"
		end

		local minLength = nut.config.get("minNameLen", 4)
		if (!value or #value:gsub("%s", "") < minLength) then
			return false, "nameMinLen", minLength
		end

		local maxLength = nut.config.get("maxNameLen", 80)
		if (!value or #value:gsub("%s", "") > maxLength) then
			return false, "nameMaxLen", maxLength
		end

		local result, reason = hook.Run("CharacterNameValid", value, data, client)
		if result ~= true then
			return result, reason
		end

		return true
	end,
	onAdjust = function(client, data, value, newData)
		local name, override =
			hook.Run("GetDefaultCharName", client, data.faction, data)
		if (isstring(name) and override) then
			newData.name = name
		else
			newData.name = string.Trim(value):sub(1, 70)
		end
	end,
	onPostSetup = function(panel, faction, payload)
		local name, disabled = hook.Run(
			"GetDefaultCharName",
			LocalPlayer(),
			faction
		)

		if (name) then
			panel:SetText(name)
			payload.name = name
		end

		if (disabled) then
			panel:SetDisabled(true)
			panel:SetEditable(false)
		end
	end
})

nut.char.registerVar("desc", {
	field = "_desc",
	default = "",
	index = 2,
	onValidate = function(value, data)
		if (noDesc) then return true end

		local minLength = nut.config.get("minDescLen", 16)

		if (!value or #value:gsub("%s", "") < minLength) then
			return false, "descMinLen", minLength
		end

		local maxLength = nut.config.get("maxDescLen", 1000)
		if (!value or #value:gsub("%s", "") > maxLength) then
			return false, "descMaxLen", maxLength
		end
	end
})