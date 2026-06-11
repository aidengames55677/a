-- "gamemodes\\mafiarp\\plugins\\rjobs\\entities\\entities\\worker_npc\\cl_init.lua"

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

	drawText("Max Williams", x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 0.65)
	drawText("Looking for a job?", x, y + 16, colorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
end

ENT.NPC_INFORMATION = {
	name = "Max Williams",
	profession = "Foreman; NYC Repairs",
	model = "models/player/Suits/male_02_open_tie.mdl",
}

ENT.NPC_CONVERSATION = {
	opening = {
		response = "Can I help you with anything?",
		options = {
			"wyd",
			"gibjob2",
			"gibjob",
			"whatdoido",
			"take_tools",
			"resign",
			"exit",
		},
	},
	wyd = {
		dialog = "What do you do?",
		response = "I'm the Foreman of NYC Repairs, we are responsible for maintaining public property and keeping our city's infrastracture stable and in a working condition! We deal with repairs and maintenance.",
		can_see = function(panel, key)
			return LocalPlayer():Team() == FACTION_CITIZEN
		end,
		options = {
			"thanks_for_info",
			"gibjob2",
			"gibjob",
		}
	},
		thanks_for_info = {
			dialog = "I see, thanks for the information!",
			response = "No problem.",
		},
	gibjob2 = {
		dialog = "I'm interested in a position here.",
		response = "Unfortunately we have no vacancies at the moment, try again later (Too many people working this job!)",
			can_see = function(panel, key)
				return LocalPlayer():Team() == FACTION_CITIZEN and team.NumPlayers(FACTION_WORKER) > 8
			end,
			options = {
				"nevermind2",
			},
		},
	gibjob = {
		dialog = "I'm interested in a position here.",
		response = "Brilliant! If you're sure, I'll get the paperwork and get you started.",
			can_see = function(panel, key)
				return LocalPlayer():Team() == FACTION_CITIZEN and team.NumPlayers(FACTION_WORKER) < 8
			end,
			options = {
				"sign_paperwork",
				"nevermind",
			},
		},
		sign_paperwork = {
			dialog = "Yes, I'm sure. (Become City Worker)",
			response = "Welcome aboard! Here are the tools you'll need to complete the tasks that will be assigned to you. When a new job is available, we will notify you, as well as inform you of its location. If you lose your tools, just ask for a new pair.",
			callback = function(panel, key)
				panel:ClearDialogOptions()

				local dialogData = panel.conversations[key]

				panel:AddDialogOption("Got it.", nil, function(panel)
					panel:Close()
				end)

				panel:SetText((isfunction(dialogData.response) and dialogData.response(panel, key)) or dialogData.response or "")

				net.Start( "worker_job" )
				net.SendToServer()
			end,
			can_see = function(panel, key)
				return LocalPlayer():Team() == FACTION_CITIZEN and team.NumPlayers(FACTION_WORKER) < 8
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
	whatdoido = {
		dialog = "What am I supposed to do again?",
		response = "Your job is to wait until there's something in the city that needs fixing, and then repair it using the tools we have provided you. We'll inform you when something needs to be fixed.",
		can_see = function(panel, key)
			return LocalPlayer():Team() == FACTION_WORKER
		end,
		options = {
			"thanks_for_info",
		}
	},
	take_tools = {
		dialog = "I'd like to retrieve my tools.",
		callback = function(panel, key)
			panel:Close()
			nut.util.notify("You have retrieved your tools.")
			net.Start( "worker_tools" )
			net.SendToServer()
		end,
		can_see = function(panel, key)
			return LocalPlayer():Team() == FACTION_WORKER
		end,
	},
	resign = {
		dialog = "I'd like to resign.",
		response = "Alright, sad to see you go. Come back if you're ever looking for some work, there's always a position for you here.",
		callback = function(panel, key)
			panel:ClearDialogOptions()

			local dialogData = panel.conversations[key]

			panel:AddDialogOption("Exit", nil, function(panel)
				panel:Close()
			end)

			panel:SetText((isfunction(dialogData.response) and dialogData.response(panel, key)) or dialogData.response or "")

			net.Start( "worker_resign" )
			net.SendToServer()
		end,
		can_see = function(panel, key)
			return (LocalPlayer():Team() == FACTION_WORKER)
		end,
	},
	exit = {
		dialog = "Exit",
		callback = function(panel, key)
			panel:Close()
		end,
	},
}

net.Receive("ui_worker_npc",function()
	local ent = net.ReadEntity()

	local dialog = vgui.Create("hdNPCDialog")
	dialog:SetTitle(ent.NPC_INFORMATION.name.." - "..ent.NPC_INFORMATION.profession)
	dialog:AddDialogOptions(ent.NPC_CONVERSATION)
	dialog:SetModel(ent.NPC_INFORMATION.model)
end)