-- "gamemodes\\mafiarp\\plugins\\rjobs\\entities\\entities\\delivery_npc\\cl_init.lua"

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
	--local desc = self.getNetVar(self, "desc")

	drawText("Pierce Bowman", x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 0.65)

	--if (desc) then
		drawText("Need some work?", x, y + 16, colorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
	--end
end

net.Receive("delivery_sendtruck_cl", function()	-- deliveryTruckEnt
	LocalPlayer()[net.ReadString()] = net.ReadEntity()
end)

net.Receive("delivery_setwaypoint", function()
	local setNew = net.ReadBool()
	if (!setNew) then
		LocalPlayer().DeliveryWaypoint = nil
		return
	end
	
	LocalPlayer().DeliveryWaypoint = { Name = net.ReadString(), Position = net.ReadVector() }
end)


hook.Add("HUDPaint", "DeliveryNPC::DeliveryLocation", function()
	local info = LocalPlayer().DeliveryWaypoint
	if (!info) then return end
	
	local dist = LocalPlayer():GetPos():Distance(info.Position)
	local spos = info.Position:ToScreen()

	local howclose = math.Round(dist / 40)

	if !spos then return end
	
	surface.SetFont("CenterPrintText")
	local t_w, t_h = surface.GetTextSize("A")
	draw.DrawText( info.Name, "CenterPrintText", spos.x + 1, spos.y + 1, color_black, TEXT_ALIGN_CENTER)
	draw.DrawText( info.Name, "CenterPrintText", spos.x, spos.y, Color(128,128,128), TEXT_ALIGN_CENTER)
	spos.y = spos.y + t_h
	
	draw.DrawText( howclose .. " m", "CenterPrintText", spos.x + 1, spos.y + 1, color_black, TEXT_ALIGN_CENTER)
	draw.DrawText( howclose .. " m", "CenterPrintText", spos.x, spos.y, color_white, TEXT_ALIGN_CENTER)
	spos.y = spos.y + t_h
	
	
	if (howclose < 30) then
		draw.DrawText( howclose .. " m", "CenterPrintText", spos.x + 1, spos.y + 1, color_black, TEXT_ALIGN_CENTER)
		draw.DrawText( "/deliver to Drop Off", "CenterPrintText", spos.x, spos.y, color_white, TEXT_ALIGN_CENTER)
		spos.y = spos.y + t_h
	end
end)

DeliveryNPCLocations = {
	["Dock Warehouse"] = {
		Position = Vector(-13718.661133, -11079.399414, -41.572052),
		Pay = 50
	},	
	
	["Diner"] = {
		Position = Vector(264.015320, 10266.295898, 261.698181),
		Pay = 30
	},
	
	["Hospital"] = {
		Position = Vector(6602.341309, 4489.569336, 31.281250),
		Pay = 20
	},
	
	["7/11"] = {
		Position = Vector(-47.867271, 13489.824219, 231.580933),
		Pay = 40
	}
}

ENT.NPC_INFORMATION = {
	name = "Pierce Bowman",
	profession = "Manager; Speedy Delivery",
	model = "models/player/suits/male_08_open.mdl",
}

ENT.NPC_CONVERSATION = {
	opening = {
		response = "Hey, whatcha need?",
		options = {
			"inquire_npc",
			"gibjob3",
			"gibjob2",
			"gibjob",
			"spawn_delivery_van",
			"store_delivery_van",
			"get_delivery",
			"cant_complete_delivery",
			"resign",
			"exit",
		},
	},
		inquire_npc = {
			dialog = "What do you do?",
			response = "Speedy Delivery is a business that transports goods from one place to another for our clients for a price. We employ people such as yourself to deliver these packages.",
			can_see = function(panel, key)
				return LocalPlayer():Team() == FACTION_CITIZEN
			end,
			options = {
				"thanks_for_info",
				"gibjob3",
				"gibjob2",
				"gibjob",
			}
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
				return LocalPlayer():Team() == FACTION_CITIZEN and team.NumPlayers(FACTION_DELIVERY) >= 5 and player.GetCount() <= nut.config.get("cars_deleteplayercount", 75)
			end,
			options = {
				"nevermind2",
			},
		},
	gibjob = {
		dialog = "I'm interested in a position here.",
		response = "Great, just sign here and we'll get you started!",
			can_see = function(panel, key)
				return LocalPlayer():Team() == FACTION_CITIZEN and team.NumPlayers(FACTION_DELIVERY) < 5 and player.GetCount() <= nut.config.get("cars_deleteplayercount", 75)
			end,
			options = {
				"sign_paperwork",
				"nevermind",
			},
		},
		sign_paperwork = {
			dialog = "Sign paperwork. (Become Delivery Driver)",
			response = "Welcome to the team pal, let me know when you want to work and I'll assign you a task. You work when you want and for as long as you want. You'll be paid for each delivery you complete.",
			callback = function(panel, key)
				panel:ClearDialogOptions()

				local dialogData = panel.conversations[key]

				panel:AddDialogOption("Got it.", nil, function(panel)
					panel:Close()
				end)

				panel:SetText((isfunction(dialogData.response) and dialogData.response(panel, key)) or dialogData.response or "")

				net.Start( "delivery_job" )
				net.SendToServer()
			end,
			can_see = function(panel, key)
				return LocalPlayer():Team() == FACTION_CITIZEN and team.NumPlayers(FACTION_DELIVERY) < 5
			end,
		},
		thanks_for_info = {
			dialog = "I see, thanks for the information!",
			response = "No problem.",
		},
		nevermind = {
			dialog = "Nevermind.",
			response = "No problem, let me know if you change your mind.",
		},
		nevermind2 = {
			dialog = "Nevermind then.",
			response = "Try again later, we may have some vacancies.",
		},
	spawn_delivery_van = {
		dialog = "I'd like to take out a delivery van.",
		callback = function(panel, key)
		if player.GetCount() >= nut.config.get("cars_deleteplayercount", 75) then nut.util.notify("Too many players on the server to use vehicles currently!") return false end
			panel:Close()
			net.Start( "delivery_truck" )
			net.SendToServer()
		end,
		can_see = function(panel, key)
			return LocalPlayer():Team() == FACTION_DELIVERY and !IsValid(LocalPlayer().deliveryTruckEnt)
		end,
	},
	store_delivery_van = {
		dialog = "I'd like to return my delivery van.",
		callback = function(panel, key)
			panel:Close()
			net.Start( "delivery_truck_return" )
			net.SendToServer()
		end,
		can_see = function(panel, key)
			return LocalPlayer():Team() == FACTION_DELIVERY and IsValid(LocalPlayer().deliveryTruckEnt)
		end,
	},
	get_delivery = {
		dialog = "What deliveries need to be made?",
		callback = function(panel, key)
			panel:Close()

			local frame = vgui.Create("DFrame")
			frame:SetTitle("Deliveries")
			frame:SetSize(500,500)
			frame:Center()
			frame:MakePopup()
			for k, v in pairs(DeliveryNPCLocations) do
				frame.button = vgui.Create("DButton", frame)
				frame.button:SetText(k .. " (" .. nut.currency.get(v.Pay) .. ")")
				frame.button:Dock(TOP)
				frame.button:DockMargin(0, 0, 0, 5)
				frame.button:SetTextColor(color_white)
				frame.button:SetTall(45)
				frame.button.DoClick = function()
					net.Start("delivery_start")
					net.WriteString( k )
					net.SendToServer()
					frame:Remove()
				end
			end
		end,
		can_see = function(panel, key)
			return LocalPlayer():Team() == FACTION_DELIVERY and !IsValid(LocalPlayer().DeliveryCrate)
		end,
	},
	cant_complete_delivery = {
		dialog = "I can't make my delivery.",
		callback = function(panel, key)
			net.Start("delivery_cancel")
			net.SendToServer()
			panel:Close()
		end,
		can_see = function(panel, key)
			return LocalPlayer():Team() == FACTION_DELIVERY and IsValid(LocalPlayer().DeliveryCrate)
		end,
	},
	resign = {
		dialog = "I'd like to resign.",
		response = "You're not joking? Damn, okay. Thanks for the help, come back and speak to me if you ever want to do some more work. We always need people like you.",
		callback = function(panel, key)
			panel:ClearDialogOptions()

			local dialogData = panel.conversations[key]

			panel:AddDialogOption("Exit", nil, function(panel)
				panel:Close()
			end)

			panel:SetText((isfunction(dialogData.response) and dialogData.response(panel, key)) or dialogData.response or "")

			net.Start( "delivery_resign" )
			net.SendToServer()
		end,
		can_see = function(panel, key)
			return (LocalPlayer():Team() == FACTION_DELIVERY and !IsValid(LocalPlayer().DeliveryCrate))
		end,
	},
	exit = {
		dialog = "Exit",
		callback = function(panel, key)
			panel:Close()
		end,
	},
}

net.Receive("ui_delivery_npc",function()
	local ent = net.ReadEntity()

	local dialog = vgui.Create("hdNPCDialog")
	dialog:SetTitle(ent.NPC_INFORMATION.name.." - "..ent.NPC_INFORMATION.profession)
	dialog:AddDialogOptions(ent.NPC_CONVERSATION)
	dialog:SetModel(ent.NPC_INFORMATION.model)
end)