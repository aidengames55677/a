-- "gamemodes\\mafiarp\\plugins\\gamemaster\\derma\\cl_gmlogs.lua"

local PLUGIN = PLUGIN
local PANEL = {}

local function GetSteamNames(stack)
	local top = stack:Top()

	steamworks.RequestPlayerInfo(util.SteamIDTo64(top.id), function(steamName)
		top.line:SetColumnText(2, steamName)
		stack:Pop()

		if stack:Size() > 0 then
			GetSteamNames(stack)
		end
	end)
end

function PANEL:Init()
	self:SetTitle("Gamemaster Logs")
	self:SetSize(ScrW() * 0.4, ScrH() * 0.4)
	self:Center()
	self:MakePopup()

	self.GamemasterLogs = self:Add("DListView")
	self.GamemasterLogs:AddColumn("SteamID")
	self.GamemasterLogs:AddColumn("Steam Name")
	self.GamemasterLogs:AddColumn("Rank")
	self.GamemasterLogs:AddColumn("Is Event Item?")
	self.GamemasterLogs:AddColumn("Item Class")
	self.GamemasterLogs:AddColumn("Spawn Reason")
	self.GamemasterLogs:AddColumn("Timestamp")
	self.GamemasterLogs:Dock(FILL)
	function self.GamemasterLogs:OnRowRightClick(lineID, line)
		local menu = DermaMenu()
		menu:AddOption("Copy Spawn Reason", function()
			SetClipboardText(line:GetColumnText(5))
		end)
		menu:AddOption("Copy Timestamp", function()
			SetClipboardText(line:GetColumnText(6))
		end)
		menu:Open()
	end
end

function PANEL:PopulateData(data)
	local stack = util.Stack()
	for _,info in ipairs(data) do
		local line = self.GamemasterLogs:AddLine(info._steamID, "Loading...", info._rank, info._isEventItem == 1 and "true" or "false", info._itemClass, info._spawnReason, info._logTime)
		stack:Push({line = line, id = info._steamID})
	end

	if stack:Size() > 0 then
		GetSteamNames(stack)
	end
end

vgui.Register("nutGMLogs", PANEL, "DFrame")