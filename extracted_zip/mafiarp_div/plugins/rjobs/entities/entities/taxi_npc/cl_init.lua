-- "gamemodes\\mafiarp\\plugins\\rjobs\\entities\\entities\\taxi_npc\\cl_init.lua"

include( "shared.lua" )

local TEXT_OFFSET = Vector(0, 0, 20)
local toScreen = FindMetaTable("Vector").ToScreen
local colorAlpha = ColorAlpha
local drawText = nut.util.drawText
local configGet = nut.config.get
	
ENT.DrawEntityInfo = true

function ENT:onDrawEntityInfo(alpha)
	local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self)) + TEXT_OFFSET)
	local x, y = position.x, position.y

	drawText("Owen Hall", x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 0.65)
	drawText("Need some work?", x, y + 16, colorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
end

net.Receive("taxi_sendtruck_cl", function()
	LocalPlayer()[net.ReadString()] = net.ReadEntity()
end)

ENT.NPC_INFORMATION = {
	name = "Owen Hall",
	profession = "Manager; Taxi Company",
	model = "models/odessa.mdl",
}

ENT.NPC_CONVERSATION = {
	opening = {
		response = "What can I do for you?",
		options = {
			"wyd",
			"gibjob3",
			"gibjob2",
			"gibjob",
			"spawn_taxi",
			"store_taxi",
			"resign",
			"exit",
		},
	},
	wyd = {
		dialog = "What do you do?",
		response = "We're this cities largest taxi firm! We transport thousands of people a day to and from wherever they need!",
		can_see = function(panel, key)
			return LocalPlayer():Team() == FACTION_CITIZEN and team.NumPlayers(FACTION_DELIVERY) < 5
		end,
		options = {
			"thanks_for_info",
			"gibjob3",
			"gibjob2",
			"gibjob",
		}
	},
		thanks_for_info = {
			dialog = "I see, thanks for the information!",
			response = "No problem.",
		},
	gibjob3 = {
		dialog = "I'm interested in a position here.",
		response = "Unfortunately we have no vacancies at the moment, try again later (Too many people on the server to use vehicles!)",
			can_see = function(panel, key)
				return LocalPlayer():Team() == FACTION_CITIZEN and player.GetCount() >= nut.config.get("cars_deleteplayercount", 75)
			end,
			options = {
				"nevermind2",
			},
		},
	gibjob2 = {
		dialog = "I'm interested in a position here.",
		response = "Unfortunately we have no vacancies at the moment, try again later (Too many people working this job!)",
			can_see = function(panel, key)
				return LocalPlayer():Team() == FACTION_CITIZEN and team.NumPlayers(FACTION_TAXI) >= 5 and player.GetCount() <= nut.config.get("cars_deleteplayercount", 75)
			end,
			options = {
				"nevermind2",
			},
		},
	gibjob = {
		dialog = "I'm interested in a position here.",
		response = "Great, just sign here and we'll get you started!",
			can_see = function(panel, key)
				return LocalPlayer():Team() == FACTION_CITIZEN and team.NumPlayers(FACTION_TAXI) < 5 and player.GetCount() <= nut.config.get("cars_deleteplayercount", 75)
			end,
			options = {
				"sign_paperwork",
				"nevermind",
			},
		},
		sign_paperwork = {
			dialog = "Sign paperwork. (Become Taxi Driver)",
			response = "Welcome aboard! Let me know when you want to get started!",
			callback = function(panel, key)
				panel:ClearDialogOptions()

				local dialogData = panel.conversations[key]

				panel:AddDialogOption("Got it.", nil, function(panel)
					panel:Close()
				end)

				panel:SetText((isfunction(dialogData.response) and dialogData.response(panel, key)) or dialogData.response or "")

				net.Start( "taxi_job" )
				net.SendToServer()
			end,
			can_see = function(panel, key)
				return LocalPlayer():Team() == FACTION_CITIZEN and team.NumPlayers(FACTION_TAXI) < 5
			end,
		},
		nevermind = {
			dialog = "Nevermind.",
			response = "No problem, let me know if you change your mind.",
		},
		nevermind2 = {
			dialog = "Nevermind then.",
			response = "Try again later, we may have some vacancies.",
		},
	spawn_taxi = {
		dialog = "I'd like to take out a taxi.",
		callback = function(panel, key)
		if player.GetCount() >= nut.config.get("cars_deleteplayercount", 75) then nut.util.notify("Too many players on the server to use vehicles currently!") return false end
			panel:Close()
			net.Start( "taxi_take" )
			net.SendToServer()
		end,
		can_see = function(panel, key)
			return LocalPlayer():Team() == FACTION_TAXI and (!IsValid(LocalPlayer().taxiEnt))
		end,
	},
	store_taxi = {
		dialog = "I'd like to return my taxi.",
		callback = function(panel, key)
			panel:Close()
			net.Start( "taxi_return" )
			net.SendToServer()
		end,
		can_see = function(panel, key)
			return LocalPlayer():Team() == FACTION_TAXI and (IsValid(LocalPlayer().taxiEnt))
		end,
	},
	resign = {
		dialog = "I'd like to resign.",
		response = "Okay, let me know if you need another job. We're always in need of drivers.",
		callback = function(panel, key)
			panel:ClearDialogOptions()

			local dialogData = panel.conversations[key]

			panel:AddDialogOption("Exit", nil, function(panel)
				panel:Close()
			end)

			panel:SetText((isfunction(dialogData.response) and dialogData.response(panel, key)) or dialogData.response or "")

			net.Start( "taxi_resign" )
			net.SendToServer()
		end,
		can_see = function(panel, key)
			return (LocalPlayer():Team() == FACTION_TAXI)
		end,
	},
	exit = {
		dialog = "Exit",
		callback = function(panel, key)
			panel:Close()
		end,
	},
}

net.Receive("ui_taxi_npc",function()
	local ent = net.ReadEntity()

	local dialog = vgui.Create("hdNPCDialog")
	dialog:SetTitle(ent.NPC_INFORMATION.name.." - "..ent.NPC_INFORMATION.profession)
	dialog:AddDialogOptions(ent.NPC_CONVERSATION)
	dialog:SetModel(ent.NPC_INFORMATION.model)
end)