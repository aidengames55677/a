-- "gamemodes\\mafiarp\\plugins\\gamemaster\\derma\\cl_gamemasters.lua"

local PLUGIN = PLUGIN
local PANEL = {}

local function ListRightClicked(self, keyCode)
	if keyCode == MOUSE_RIGHT then
		local menu = DermaMenu()
		menu:AddOption("Add to Gamemasters", function()
			Derma_StringRequest(
				"Add Gamemaster", 
				"Input the SteamID of the player you wish to add as a gamemaster.", 
				"", 
				function(text) 
					nut.command.send("gamemasteradd", text)
				end
			)
		end)

		menu:Open()
	end
end

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
	self:SetTitle("Gamemasters")
	self:SetSize(ScrW() * 0.4, ScrH() * 0.4)
	self:Center()
	self:MakePopup()

	self.GamemasterList = self:Add("DListView")
	self.GamemasterList:AddColumn("SteamID")
	self.GamemasterList:AddColumn("Steam Name")
	self.GamemasterList:Dock(FILL)
	self.GamemasterList.OnMousePressed = ListRightClicked
	function self.GamemasterList:OnRowRightClick(lineID, line)
		local menu = DermaMenu()
		menu:AddOption("Remove from Gamemasters", function()
			nut.command.send("gamemasterremove", line:GetColumnText(1))
		end)
		menu:AddOption("View Spawn Logs", function()
			nut.command.send("gamemasterlogs", line:GetColumnText(1))
		end)
		menu:Open()
	end
	
	local stack = util.Stack()
	for steamID,_ in next, PLUGIN.Gamemasters do
		local line = self.GamemasterList:AddLine(steamID, "Loading...")
		stack:Push({line = line, id = steamID})
	end

	if stack:Size() > 0 then
		GetSteamNames(stack)
	end
end

vgui.Register("nutGamemasters", PANEL, "DFrame")