local PLUGIN = PLUGIN
PLUGIN.name = "Character Creation"
PLUGIN.desc = "Modifies character creation."
PLUGIN.author = "rusty"

nut.util.include("sv_plugin.lua")

if !nut.plugin.list.multichar then return end

PLUGIN.character_customization = {
	{
		["Name"] = "Eye Color",
		["Options"] = { "Brown", "Hazel", "Blue", "Green", "Gray", "Amber" },
		["Type"] = "Dropdown",
	},
	{
		["Name"] = "Hair Color",
		["Options"] = { "Bald", "Brown", "Blond", "Black", "Auburn", "Red", "Gray" },
		["Type"] = "Dropdown",
	},
	{
		["Name"] = "Blood Type",
		["Options"] = { "O+", "O-", "A+", "A-", "B+", "B-", "AB+", "AB-" },
		["Type"] = "Dropdown",
	},
	{
		["Name"] = "Ethnicity",
		["Options"] = { "American", "Italian", "Italian-American", "African", "African-American", 
			"Indian", "Indian-American", "English" ,"English-American", "Middle Eastern", "Middle Eastern-American", 
			"Latin-American", "Irish", "Irish-American", "Native-American", "Greek", "Greek-American", "Polish", "Polish-American", "German", 
			"German-American", "Dutch", "Dutch-American", "Jewish", "Jewish-American", "Scottish", "Scottish-American", 
			"Cuban", "Cuban-American", "Japanese", "Japanese-American", "French", "French-American", "Russian-American",
			"Spanish-American", "Canadian", "Canadian-American", "Hungarian", "Hungarian-American", "Russian", "Hispanic", 
			"Baltic", "Baltic-American", "Eastern-European", "Slavic-American", "Asian", "Asian-American", "Norwegian", "Australian" },
		["Type"] = "Dropdown",
	},
	{
		["Name"] = "Age",
		["Minimum"] = 18, 
		["Maximum"] = 99,
		["Type"] = "NumberWang"
	},
	{
		["Name"] = "Weight - LBS",
		["Minimum"] = 90,
		["Maximum"] = 400,
		["Type"] = "NumberWang"
	},
	{
		["Name"] = "Height - Inches",
		["Minimum"] = 0,
		["Maximum"] = 11,
		["Type"] = "NumberWang"
	},
	{
		["Name"] = "Height - Feet",
		["Minimum"] = 5,
		["Maximum"] = 6,
		["Type"] = "NumberWang"
	},

}

PLUGIN.desc_change_warn = "Are you sure you want to modify your characters description?\nYour description was auto-generated based on the options you chose for your character.\nUnless you are an experienced roleplayer and know what you're doing, we recommend keeping it as is.\nDescriptions are supposed to be your physical appearance only.\nBe aware that if your description is invalid, you may be punished for it."

function PLUGIN:GenerateDescription(t)
	local name = t["name"] or "none"; local ethnicity = t["Ethnicity"] or "none"; local blood = t["Blood Type"] or "none"; 
	local eye = t["Eye Color"] or "none"; local hair = t["Hair Color"] or "none"; local age = t["Age"] or "none";
	local gender = "male"; local height1 = t["Height - Feet"] or "none"; local height2 = t["Height - Inches"] or "0"; local weight = t["Weight - LBS"] or "none";
	if (nut.faction.indices[t["faction"]].models && nut.faction.indices[t["faction"]].models[t["model"]]) then
		local mdl = nut.faction.indices[t["faction"]].models[t["model"]]
		if (string.lower(mdl):find("female", 1, true)) then
			gender = "female"
		end
	end
	
	local vowels = {"a", "e", "i", "o", "u"}
	local aan = "a"
	if (ethnicity && table.HasValue(vowels, string.lower(ethnicity)[1])) then
		aan = "an"
	end
	
	return "A "..gender.." stands before you at around "..height1.."'"..height2.." and weighing around "..weight.." pounds. They have "..hair.." hair and "..eye.." coloured eyes."
end

nut.char.registerVar("descgenerator", {
	field = "_descgenerator",
	default = "[]",
	isLocal = false,
	noDisplay = false,
	onValidate = function(data)
		if !data then return end

		for _,detail in next, nut.plugin.list.modified_charcreation.character_customization do
			if detail.Type == "NumberWang" then
				if !detail.Minimum then continue end
				if !detail.Maximum then continue end

				local value = data[detail.Name] or detail.Minimum
				if value < detail.Minimum then
					return false, detail.Name.." value is too low."
				elseif value > detail.Maximum then
					return false, detail.Name.." value is too high."
				end
			end

			if detail.Type == "Dropdown" then
				local options = detail.Options
				
				if !table.HasValue(options, data[detail.Name]) then
					return false, "You didn't make a selection for "..detail.Name.."!"
				end
			end
		end
	end
})

nut.char.registerVar("skin", {
	field = "_skin",
	default = 0
})

if CLIENT then
	function PLUGIN:LoadFonts(font)
		surface.CreateFont("TypeRaMedium", {
			font = "Roboto",
			size = ScreenScale(16),
			extended = true,
			weight = 1000
		})

		surface.CreateFont("TypeRaMediumLight", {
			font = "Roboto",
			size = ScreenScale(16),
			extended = true,
			weight = 200
		})
	end
end

local globalRanks = {
	eventmanager = true,
	moderator = true,
	administrator = true,
	seasonedadministrator = true,
	senioradministrator = true,
	superadministrator = true,
	headadministrator = true,
	communitymanager = true,
	founder = true,
}

nut.command.add("charsetbodygroup", {
	syntax = "<string name> <string bodyGroup> [number value]",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!globalRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		local value = tonumber(arguments[3])
		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target) and target:getChar()) then
			local index = target:FindBodygroupByName(arguments[2])

			if (index > -1) then
				if (value and value < 1) then
					value = nil
				end

				local groups = target:getChar():getGroups()
				if isstring(groups) then
					groups = util.JSONToTable(groups)
				end

				groups[index] = value
				target:getChar():setGroups(groups)
				target:SetBodygroup(index, value or 0)
				nut.util.notifyLocalized("cChangeGroups", {client, target}, client:Name(), target:Name(), arguments[2], value or 0)
			else
				return "@invalidArg", 2
			end
		end
	end
})

if SERVER then
	util.AddNetworkString("nutApproveID")
	util.AddNetworkString("nutRequestID")

	local function nutApproveID(len, ply)
		local requester = ply.SearchID

		if !requester then return end
		if !requester.SearchID then return end

		local approveID = net.ReadBool()

		if !approveID then
			requester:notify("Player denied your request to view your ID.")

			requester.SearchID = nil
			ply.SearchID = nil

			return
		end

		if requester:GetPos():DistToSqr(ply:GetPos()) > 250*250 then return end
		local item = ply:getChar():getInv():getFirstItemOfType('idcard')
		netstream.Start(ply, "OpenCharInfoDisplay", requester, ply:getChar():getID())
		if !requester.nutAdminSearch then
			ply:getChar():recognize(requester:getChar():getID())
		end
		
		requester.SearchID = nil
		ply.SearchID = nil
	end
	net.Receive("nutApproveID", nutApproveID)
else
	local function nutRequestID(len)
		nut.util.notifQuery("A player is requesting to show you their ID.", "Accept", "Deny", true, NOT_CORRECT, function(code)
			if code == 1 then
				net.Start("nutApproveID")
					net.WriteBool(true)
				net.SendToServer()
			elseif code == 2 then
				net.Start("nutApproveID")
					net.WriteBool(false)
				net.SendToServer()
			end
		end)
	end
	net.Receive("nutRequestID", nutRequestID)

	netstream.Hook("OpenCharInfoDisplay", function(ply, id)
		if ply:Team() && ply:Team() == FACTION_POLICE then
			local pnl = vgui.Create("SWCharInfoDisplayPolice")
			pnl:setCharacter(ply, id)
		else
			local pnl = vgui.Create("SWCharInfoDisplay")
			pnl:setCharacter(ply, id)
		end
	end)
end