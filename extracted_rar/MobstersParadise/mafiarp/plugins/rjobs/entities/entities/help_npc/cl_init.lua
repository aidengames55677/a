-- "gamemodes\\mafiarp\\plugins\\rjobs\\entities\\entities\\help_npc\\cl_init.lua"

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

	drawText("Sean Johnson", x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 0.65)
	drawText("Need anything? (Press E)", x, y + 16, colorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
end


ENT.jobs = {}
ENT.jobs[ "taxis" ] = {
	name = "Brooklyn Taxis",
	coordsx = 1127.700928, coordsy = -3626.913818, coordsz = -125.6590580,
}
ENT.jobs[ "deliver" ] = {
	name = "Speedy Delivery",
	coordsx = 277.017487, coordsy = -4323.226074, coordsz = -125.500519,
}
ENT.jobs[ "worker" ] = {
	name = "NYC Repairs",
	coordsx = 3181.037354, coordsy = 5135.968750, coordsz = 106.634941,
}
ENT.jobs[ "fishing" ] = {
	name = "Fishing",
	coordsx = 4433.730469, coordsy = -6043.116211, coordsz = -227.843750,
}

ENT.destinations = {}
vector = Vector(7358.828125, 7906.062988, 249.890900)
ENT.destinations[ "police" ] = {
	name = "Police Station",
	coordsx = vector.x, coordsy = vector.y, coordsz = vector.z,
}	
vector = Vector(-2080.275635, 10885.531250, 192.031250)
ENT.destinations[ "clothingstore" ] = {
	name = "Clothing Store",
	coordsx = vector.x, coordsy = vector.y, coordsz = vector.z,
}	
vector = Vector(-1510.959106, 2057.274902, -39.968750)
ENT.destinations[ "bank" ] = {
	name = "Bank",
	coordsx = vector.x, coordsy = vector.y, coordsz = vector.z,
}	
vector = Vector(-1541.531250, 10432.136719, 200.031250)
ENT.destinations[ "guns" ] = {
	name = "Gun Store",
	coordsx = vector.x, coordsy = vector.y, coordsz = vector.z,
}	
vector = Vector(7414.340332, 4641.147461, 0.031250)
ENT.destinations[ "hospital" ] = {
	name = "Hospital",
	coordsx = vector.x, coordsy = vector.y, coordsz = vector.z,
}	
vector = Vector(-7172.570313, 1261.010742, 24.031250)
ENT.destinations[ "card" ] = {
	name = "Car Dealership",
	coordsx = vector.x, coordsy = vector.y, coordsz = vector.z,
}	
vector = Vector(6443.674805, 2006.749756, -39.968750)
ENT.destinations[ "hotel" ] = {
	name = "Hotel",
	coordsx = vector.x, coordsy = vector.y, coordsz = vector.z,
}	
vector = Vector(5209.477051, -5109.213379, -255.968750)
ENT.destinations[ "docks" ] = {
	name = "Docks",
	coordsx = vector.x, coordsy = vector.y, coordsz = vector.z,
}

ENT.NPC_INFORMATION = {
	name = "Sean Johnson",
	profession = "Secretary; New York City",
	model = "models/player/Suits/male_07_closed_tie.mdl",
}

ENT.NPC_CONVERSATION = {
	opening = {
		response = "Welcome to the city?, you need anything?",
		options = {
			"seeing_errors",
			"remove_waypoints",
			"getstarted",
			"looking_job",
			"looking_dirs",
			"exit",
		},
	},
	seeing_errors = {
		dialog = "I'm seeing errors (Content)",
		response = "Let's take care of that for you.",
		callback = function(panel, key)
			gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=2238810677")
			panel:BackToOpening()
		end,
	},
	getstarted = {
		dialog = "How do I get started?",
		callback = function(panel, key)
            local f = vgui.Create("DFrame")
            f:SetSize(ScrW()*0.8, ScrH()*0.8)
            f:SetTitle("Guides")
            f:Center()
            f:MakePopup()
            local h = vgui.Create("DHTML", f)
            h:Dock(FILL)
            h:OpenURL("https://divergenet.works/forums/showthread.php?tid=3423")
		end,
	},
	remove_waypoints = {
		dialog = "Remove my waypoint.",
		response = "No problem.",
		can_see = function(panel, key)
			return hook.GetTable()["HUDPaint"] && hook.GetTable()["HUDPaint"]["WeighPoint"]
		end,
		callback = function(panel, key)
			hook.Remove("HUDPaint", "WeighPoint")
			panel:BackToOpening()
		end,
	},
	looking_job = {
		dialog = "I'm looking for a job.",
		response = "There are a few places around the city that are hiring. Local bars and resturants especially! Ask around and I'm sure you'll find something. I also have a list of other jobs you may be interested in if you'd like to take a look.",
		options = {
			"looking_job_list",
			"looking_job_drugs",
			"looking_job_nevermind",
		}
	},
	looking_dirs = {
		dialog = "I'm lost, could you provide me with directions?",
		response = "Sure, where are you looking to get to?",
		callback = function(panel, key)
			local dialog = panel.conversations[key]
			panel:ClearDialogOptions()
			panel:SetText(dialog.response)

			for _,data in next, panel.NPCEntity.destinations do
				panel:AddDialogOption(data.name, _, function(panel, key)
					panel:Close()
					nut.util.notify(data.name.. " has been marked on your screen. Follow the waypoint to get to the destination.")
					LocalPlayer():SetWeighPoint(data.name, Vector(data.coordsx,data.coordsy,data.coordsz), function()
						nut.util.notify("You have arrived at the "..v.name..".")
					end)
				end)
			end

			panel:AddDialogOption("Back", "go_back", function(panel, key)
				panel:BackToOpening()
			end)
		end,
	},
	looking_job_list = {
		dialog = "Sure!",
		response = "Here are a few of the more established businesses in the area.",
		callback = function(panel, key)
			local dialog = panel.conversations[key]
			panel:ClearDialogOptions()
			panel:SetText(dialog.response)

			for _,data in next, panel.NPCEntity.jobs do
				panel:AddDialogOption(data.name, _, function(panel, key)
					panel:Close()
					nut.util.notify(data.name.. " has been marked on your screen. Follow the waypoint to get to the destination.")
					LocalPlayer():SetWeighPoint(data.name, Vector(data.coordsx,data.coordsy,data.coordsz), function()
						nut.util.notify("You have arrived. Speak to the NPC for information about a job.")
					end)
				end)
			end

			panel:AddDialogOption("Back", "go_back", function(panel, key)
				panel:BackToOpening()
			end)
		end,
	},
	looking_job_drugs = {
		dialog = "I'm looking to make some money through some less legal means... can you help?",
		response = "Keep your voice down. I might know a guy, he has a spot, go speak to him. If anyone asks you don't know me from shit.",
		callback = function(panel, key)
			local dialog = panel.conversations[key]
			panel:SetText(dialog.response)
			panel:ClearDialogOptions()
			
			nut.util.notify("Drug Dealer has been marked on your screen. Follow the waypoint to get to the destination.")
			LocalPlayer():SetWeighPoint("Drug Dealer", Vector(-3437.756836, 7200.746094, 128.031250), function()
				nut.util.notify("You have arrived. Speak to the NPC for information.")
			end)
			panel:AddDialogOption("Back", "go_back", function(panel, key)
				panel:BackToOpening()
			end)
		end,
	},
	looking_job_nevermind = {
		dialog = "Nevermind, thank you anyway.",
		response = "No problem.",
	},
	exit = {
		dialog = "Exit",
		callback = function(panel, key)
			panel:Close()
		end,
	},
}

net.Receive("ui_help_npc", function(len)
	local npc = net.ReadEntity()
	local dialog = vgui.Create("hdNPCDialog")
	dialog:SetTitle(npc.NPC_INFORMATION.name.." - "..npc.NPC_INFORMATION.profession)
	dialog:AddDialogOptions(npc.NPC_CONVERSATION)
	dialog.NPCEntity = npc
	dialog:SetModel("models/player/Suits/male_07_closed_tie.mdl")
end)