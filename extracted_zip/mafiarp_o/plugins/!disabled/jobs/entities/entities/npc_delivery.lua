AddCSLuaFile();
ENT.Type = "anim"
ENT.PrintName	= "Delivery NPC"
ENT.Author	= "Killing Torcher"
ENT.Category = "Themis Networks"

ENT.Spawnable	= true
ENT.AdminOnly	= true


function ENT:setAnim()
	for k, v in ipairs(self:GetSequenceList()) do
		if (v:lower():find("idle") and v ~= "idlenoise") then
			return self:ResetSequence(k)
		end
	end

	self:ResetSequence(4)
end

function ENT:Initialize()
	if (SERVER) then
		self:SetModel( "models/player/suits/male_08_open.mdl" )
		self:SetSkin(13)
		self:SetUseType(SIMPLE_USE)
		self:SetMoveType(MOVETYPE_NONE)
		self:DrawShadow(true)
		self:SetSolid(SOLID_BBOX)
		self:PhysicsInit(SOLID_BBOX)
		--self:DropToFloorent()
	end
	
	timer.Simple(1, function()
		if (IsValid(self)) then
			self:setAnim()
		end
	end)
	
	local physObj = self:GetPhysicsObject()
	
	if (IsValid(physObj)) then
		physObj:EnableMotion(false)
		physObj:Sleep()
	end
end

DeliveryNPCLocations = {
	["Farm"] = {
		Position = Vector(5714.014648, 7850.494629, 7392.885254),
		Pay = 350
	},	
	
	["Hospital"] = {
		Position = Vector(-12024.591797, 9351.599609, 7350.006836),
		Pay = 400
	},
	
	["Outer City Train station"] = {
		Position = Vector(5481.834961, 4406.503906, 7608.666016),
		Pay = 450
	},
	
	["General Store"] = {
		Position = Vector(-5730.772461, 5843.581543, 7469.721191),
		Pay = 300
	},
	
	["Inner City Train station"] = {
		Position = Vector(-9395.455078, 5543.091797, 7455.915039),
		Pay = 400
	}
}

if (SERVER) then

	local function spawnNPC()
		/*if (!NPC_delivery || !IsValid(NPC_delivery)) then
			NPC_delivery = ents.Create("npc_delivery")
			NPC_delivery:SetModel("models/player/suits/male_08_open.mdl")
			NPC_delivery:SetPos(Vector(2093.173340, 5441.591309, 7403.623047))
			NPC_delivery:SetAngles(Angle(21.449921, 89.608803, 0.000000))
			NPC_delivery:Spawn()
		end*/
	end
	hook.Add("LoadData", "DeliveryNPC::Spawn", spawnNPC)

	util.AddNetworkString("ui_delivery_npc")
	util.AddNetworkString("ui_delivery_hired_npc")
	util.AddNetworkString("delivery_job")
	util.AddNetworkString("delivery_start")
	util.AddNetworkString("delivery_resign")
	util.AddNetworkString("delivery_truck")
	util.AddNetworkString("delivery_truck_return")
	util.AddNetworkString("delivery_job_accepted")
	
	net.Receive("delivery_job", function( len, ply )
		if (ply.DeliveryJobCD && ply.DeliveryJobCD > SysTime()) then
			ply:notify("You recently resigned from this job! Wait " .. math.floor(ply.DeliveryJobCD - SysTime()) .. " seconds before taking this job on again")
			return
		end
		
		if team.GetName( ply:Team() ) == "Citizens of Berlin" then
			local faction = nut.faction.indices[FACTION_DELIVERY]
			ply:getChar().vars.faction = faction.uniqueID
			ply:getChar():setFaction(faction.index)
			ply:notify("You have been hired into Speedy Delivery LTD.")
			net.Start("delivery_job_accepted")
			net.Send(ply)
		else
			ply:notify("You already have a job!")
		end
	end)			
		
	net.Receive("delivery_resign", function( len, ply ) 
		if (ply:Team() != FACTION_DELIVERY) then return end
		
		local faction = nut.faction.indices[FACTION_civy]
    	ply:getChar().vars.faction = faction.uniqueID
		ply:getChar():setFaction(faction.index)
		
		if (IsValid(ply.deliveryTruckEnt)) then
			ply.deliveryTruckEnt:Remove()
		end
		
		if (IsValid(ply.DeliveryCrate)) then
			ply.DeliveryCrate:Remove()
		end
		
		ply.DeliveryJobCD = SysTime() + 30
		net.Start("delivery_setwaypoint")
		net.WriteBool(false)
		net.Send(ply)
	end)
		
	net.Receive('delivery_truck', function(length, ply)
		if (IsValid(ply.deliveryTruckEnt)) then 
			ply:notify("You already have a Delivery Van taken out.")
			return 
		end
		
		local pos = Vector( -2549.119385, 5291.402344, 7376.031250 )

		for k,v in pairs(ents.FindInSphere(pos, 100)) do
			if (IsValid(v) && (v:GetClass() == "gmod_sent_vehicle_fphysics_base" || (v:IsPlayer() && v:Alive()))) then
				ply:notify("The Delivery Van spawn is being blocked.")
				return
			end
		end
		
		local _v = simfphys.SpawnVehicleSimple( "simfphys_mafia2_shubert_truck_qd", pos, Angle( 0, 90, 0 ) )
		_v:SetNWInt( "Owner", ply:EntIndex() )
		_v:SetBodygroup( 1, 1 )
		_v:Lock()
		_v.CPPIGetOwner = function()
			return ply
		end
		_v.DeliveryTruck = true
		_v.DeliveryTruckOwner = ply
		
		ply.deliveryTruckEnt = _v
		timer.Simple(0.1, function()
			net.Start("delivery_sendtruck_cl")
			net.WriteString("deliveryTruckEnt")
			net.WriteEntity(_v)
			net.Send(ply)
		end)
		ply:notify("You have taken out a Delivery Van.")
	end)
	
	net.Receive('delivery_truck_return', function(length, ply)
		local ent = ply.deliveryTruckEnt
		if (IsValid(ent)) then
			ent:Remove()
			ply:notify("Your Delivery Van has been returned.")
			net.Start("delivery_sendtruck_cl")
			net.WriteString("deliveryTruckEnt")
			net.WriteEntity(NULL)
			net.Send(ply)
		else
			ply:notify("You don't have a Delivery Van taken out.")
		end
	end)
	
	hook.Add("PlayerEnteredVehicle", "DeliveryTruck::PlayerEnteredVehicle", function(ply, veh, role)
		if (IsValid(veh.vehiclebase)) then
			veh = veh.vehiclebase
		end

		if (veh.DeliveryTruck) then
			veh:SetBodygroup(1, 0)
		end
	end)
	
	hook.Add("PlayerLeaveVehicle", "DeliveryTruck::PlayerLeaveVehicle", function(ply, veh)
		if (IsValid(veh.vehiclebase)) then
			veh = veh.vehiclebase
		end
		
		if (veh.DeliveryTruck) then
			veh:SetBodygroup(1, 1)
		end
	end)
	
	hook.Add("PlayerDisconnected", "DeliveryTruck::PlayerDisconnected", function(ply)
		local ent = ply.deliveryTruckEnt
		if (IsValid(ent)) then
			ent:Remove()
		end
		
		if (IsValid(ply.DeliveryCrate)) then
			ply.DeliveryCrate:Remove()
		end
	end)
	
	net.Receive('delivery_start', function(length, ply)
		if (ply.NextNewDelivery && ply.NextNewDelivery > SysTime()) then
			ply:notify("You have to wait another " .. math.floor(ply.NextNewDelivery - SysTime()) .. " seconds before starting another delivery.")
			return
		end
	
		if (IsValid(ply.DeliveryCrate)) then
			ply:notify("You already have a crate you are delivering.")
			return
		end

		local place = net.ReadString()
		if (!DeliveryNPCLocations[place]) then
			return
		end
		
		ply.NextNewDelivery = SysTime() + 205
		
		local crate = ents.Create("kt_delivery_crate")
		crate.CrateOwner = ply
		crate.Location = place
		crate:SetPos(Vector(-2198.015381, 5265.795410, 7376.031250))
		crate:Spawn()
		ply.DeliveryCrate = crate
		ply:notify("Load the package into your truck and deliver the package to " .. place .. " (Follow the waypoint)")
		ply:ChatPrint("Use /deliver once at the location to drop the package off.")
		
		timer.Simple(0.1, function()
			net.Start("delivery_sendtruck_cl")
			net.WriteString("DeliveryCrate")
			net.WriteEntity(crate)
			net.Send(ply)
		end)
		
		net.Start("delivery_setwaypoint")
		net.WriteBool(true)
		net.WriteString(place)
		net.WriteVector(DeliveryNPCLocations[place].Position)
		net.Send(ply)
	end)
	
	net.Receive("delivery_cancel", function(len, ply)
		if (IsValid(ply.DeliveryCrate)) then
			ply.DeliveryCrate:Remove()
			
			ply:notify("You've cancelled your delivery. Your boss is disappointed in you.")
		end
	end)

	function ENT:OnTakeDamage()
	    return false
	end 
	

	function ENT:AcceptInput( Name, Activator, Caller )    
	    if Name == "Use" and Caller:IsPlayer() and team.GetName( Caller:Team() ) == "Speedy Delivery LTD" then
		    net.Start("ui_delivery_hired_npc")
		    net.Send(Caller)
		else
		    net.Start("ui_delivery_npc")
		    net.Send(Caller)
	    end
	end
	
	util.AddNetworkString("delivery_setwaypoint")
else
	net.Receive("delivery_job_accepted", function()
		themis.dialogframe("Timon Seidl", "models/player/suits/male_08_open.mdl", "Manager", "Speedy Delivery")
		themis.dialogtext("Welcome to the team pal, let me know when you want to work and I'll assign you a task. You work when you want and for as long as you want. You'll be paid for each delivery you complete.")
		themis.dialogbutton("Got it. (Close)", 40, function()
			self:Remove()	
		end)
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
		draw.DrawText( info.Name, "CenterPrintText", spos.x, spos.y, Color(123, 57, 209), TEXT_ALIGN_CENTER)
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
end

nut.command.add("deliver", {
	syntax = "",
	onRun = function(client, arguments)
		if (client:Team() != FACTION_DELIVERY) then
			client:notify("Only deliverymen can use this command.")
			return
		end
		
		if (!IsValid(client.DeliveryCrate)) then
			client:notify("You have no active deliveries. Talk to the delivery NPC.")
			return
		end
		
		local crate = client.DeliveryCrate
		
		if (crate.Reserved) then
			return
		end
		
		if (!crate.Location) then
			client:notify("Crate spawned with no location - error")
			return
		end
		
		local location = DeliveryNPCLocations[crate.Location]
		local place = crate.Location
		if (!location) then
			client:notify("Crate location invalid - error")
			return
		end
		
		local distance = crate:GetPos():Distance(location.Position)
		if (distance > 600) then
			client:notify("You need to get the crate closer to the location")
			return
		end
		
		crate.Reserved = true
		crate:Remove()
		
		if (IsValid(client.deliveryTruckEnt)) then
			client.deliveryTruckEnt.DeliveryCrateAttached = nil
		end
		
		local pay = location.Pay
		
		client:getChar():giveMoney(pay)
		client:notify("You've made " .. nut.currency.get(pay) .. " for delivering this package to " .. place)
		
		net.Start("delivery_sendtruck_cl")
		net.WriteString("DeliveryCrate")
		net.WriteEntity(NULL)
		net.Send(client)
		
		net.Start("delivery_setwaypoint")
		net.WriteBool(false)
		net.Send(client)
	end
})

if (SERVER) then
	util.AddNetworkString("delivery_sendtruck_cl")
	util.AddNetworkString("delivery_cancel")
else
	net.Receive("delivery_sendtruck_cl", function()	-- deliveryTruckEnt
		LocalPlayer()[net.ReadString()] = net.ReadEntity()
	end)
end
if (CLIENT) then
	net.Receive("delivery_job", delivery_jobReceived)
	net.Receive("ui_delivery_npc",function()
		cooldown = net.ReadBool()

	    themis.dialog("Timon Seidl", "models/player/suits/male_08_open.mdl", "Manager", "Speedy Delivery", function(ply)
	    	themis.dialogframe("Timon Seidl", "models/player/suits/male_08_open.mdl", "Manager", "Speedy Delivery")

	    	themis.dialogtext("Hey, whatcha need?")
	    	themis.dialogbutton("Nevermind. (Close)", 40, function()
	    		self:Remove()
			end)
	    	themis.dialogbutton("What do you do?", 40, function()
	    		self:Remove()	
			themis.dialogframe("Timon Seidl", "models/player/suits/male_08_open.mdl", "Manager", "Speedy Delivery")
			themis.dialogtext("Speedy Delivery is a business that transports goods from one place to another for our clients for a price. We employ people such as yourselves to deliver these packages. ")	
	    	themis.dialogbutton("I see, thanks for the information! (Close)", 40, function()
	    		self:Remove()	
	    	end)
	    	end)
	    	themis.dialogbutton("I'm interested in a position here.", 40, function()
	    		self:Remove()	
			themis.dialogframe("Timon Seidl", "models/player/suits/male_08_open.mdl", "Manager", "Speedy Delivery")
			themis.dialogtext("Great, just sign here and we'll get to work. We also provide you with a Truck to complete these deliveries, providing you meet the legal requirement. ")	
	    	themis.dialogbutton("Nevermind. (Close)", 40, function()
	    		self:Remove()	
	    	end)
	    	themis.dialogbutton("Sign paperwork. (Become Delivery Driver)", 40, function()
				if team.GetName( LocalPlayer():Team() ) != "Citizens of Berlin" then
					nut.util.notify("You already have a job!", 2)
					self:Remove()
					return
				end
			net.Start( "delivery_job" )
			net.SendToServer()
			self:Remove()
			end)
	    	end)
		end)
	end)
	
	
	net.Receive("delivery_resign", delivery_resignReceived)
	net.Receive("delivery_truck", delivery_truckReceived)
	net.Receive("delivery_truck_return", delivery_truck_returnReceived)
	net.Receive("delivery_start", delivery_startReceived)
	net.Receive("ui_delivery_hired_npc",function()
		cooldown = net.ReadBool()

	    themis.dialog("Timon Seidl", "models/player/suits/male_08_open.mdl", "Manager", "Speedy Delivery", function(ply)
				themis.dialogframe("Timon Seidl", "models/player/suits/male_08_open.mdl", "Manager", "Speedy Delivery")

				themis.dialogtext("Hey, what do you need?")
				
				themis.dialogbutton("Nevermind. (Close)", 35, function()
					self:Remove()
				end)
				
				themis.dialogbutton("Delivery Options", 35, function()
					self:Remove()
						
					themis.dialogframe("Timon Seidl", "models/player/suits/male_08_open.mdl", "Manager", "Speedy Delivery")
					
					themis.dialogtext("What exactly do you need?")
					
					themis.dialogbutton("Nevermind. (Close)", 30, function()
						self:Remove()
					end)
					
					if (!IsValid(LocalPlayer().deliveryTruckEnt)) then
						themis.dialogbutton("I'd like to take out a Delivery Van.", 30, function()
							self:Remove()
							net.Start( "delivery_truck" )
							net.SendToServer()
						end)
					else
						themis.dialogbutton("I'd like to return my Delivery Van.", 30, function()
							self:Remove()
							net.Start( "delivery_truck_return" )
							net.SendToServer()
						end)
					end
					
					
					if (!IsValid(LocalPlayer().DeliveryCrate)) then
						themis.dialogbutton("What deliveries need to be made?", 35, function()
							self:Remove()

							self.frame = vgui.Create("WolfFrame")
							self.frame:SetTitle("Deliveries")
							self.frame:SetSize(500,500)
							self.frame:Center()
							self.frame:MakePopup()
							local fr = self.frame
							for k, v in pairs(DeliveryNPCLocations) do
							
								self.button = vgui.Create("WButton", self.frame)
								self.button:SetText(k .. " (" .. nut.currency.get(v.Pay) .. ")")
								self.button:Dock(TOP)
								self.button:SetColorAcc(Color(30,31,33))
								self.button:SetupHover(Color(35,36,38))
								self.button:DockMargin(0, 0, 0, 5)
								self.button:SetTextColor(color_white)
								self.button:SetTall(45)
								self.button.DoClick = function()
									net.Start("delivery_start")
									net.WriteString( k )
									net.SendToServer()
									fr:Remove()
								end
							end
						end)
					else
						themis.dialogbutton("I can't make my delivery", 35, function()
							net.Start("delivery_cancel")
							net.SendToServer()
							self:Remove()
						end)
					end
					
				end)
				themis.dialogbutton("I'd like to resign.", 35, function()
					self:Remove()
					net.Start( "delivery_resign" )
					net.SendToServer()
					nut.util.notify("You have resigned from Speedy Delivery LTD.", 6)
				themis.dialogframe("Timon Seidl", "models/player/suits/male_08_open.mdl", "Manager", "Speedy Delivery")
				themis.dialogtext("You're not joking? Damn, okay. Thanks for the help, come back and speak to me if you ever want to do some more work. We always need people like you.")	
				themis.dialogbutton("(Close)", 30, function()
					self:Remove()	
				end)
				end)
				end)
			end)

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

		drawText("Timon Seidl", x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 0.65)

		--if (desc) then
			drawText("Need some work?", x, y + 16, colorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
		--end
	end
end
