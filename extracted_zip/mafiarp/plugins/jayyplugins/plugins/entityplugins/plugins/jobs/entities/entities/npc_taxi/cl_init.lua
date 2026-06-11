include( "shared.lua" )

if (CLIENT) then
	net.Receive("taxi_sendtruck_cl", function()
		LocalPlayer().taxiEnt = net.ReadEntity()
	end)
end
if (CLIENT) then

	net.Receive("taxi_job", taxi_jobReceived)
	net.Receive("ui_taxi_npc",function()
		cooldown = net.ReadBool()

	    themis.dialog("Niclas Weisz", "models/odessa.mdl", "Manager", "Berlin Taxis", function(ply)
	    	themis.dialogframe("Niclas Weisz", "models/odessa.mdl", "Manager", "Berlin Taxis")

	    	themis.dialogtext("What can I do for you?")
	    	themis.dialogbutton("Nevermind. (Close)", 40, function()
	    		self:Remove()
			end)
	    	themis.dialogbutton("What do you do?", 40, function()
	    		self:Remove()	
			themis.dialogframe("Niclas Weisz", "models/odessa.mdl", "Manager", "Berlin Taxis")
			themis.dialogtext("We're Berlin's largest taxi firm! We transport thousands of people a day to and from wherever they need!")	
	    	themis.dialogbutton("Alright. (Close)", 40, function()
	    		self:Remove()	
	    	end)
	    	end)
	    	themis.dialogbutton("I'm interested in a position here.", 40, function()
	    		self:Remove()	
			themis.dialogframe("Niclas Weisz", "models/odessa.mdl", "Manager", "Berlin Taxis")
			themis.dialogtext("Okay, just sign here and you can get started.")	
	    	themis.dialogbutton("Nevermind. (Close)", 40, function()
	    		self:Remove()	
	    	end)
	    	themis.dialogbutton("Sign paperwork. (Become Taxi Driver)", 40, function()
				if team.GetName( LocalPlayer():Team() ) != "Citizens of Berlin" then
					nut.util.notify("You already have a job!", 2)
					self:Remove()
					return
				end
			net.Start( "taxi_job" )
			net.SendToServer()
			self:Remove()
			themis.dialogframe("Niclas Weisz", "models/odessa.mdl", "Manager", "Berlin Taxis")
			themis.dialogtext("Welcome to Berlin Taxis, let me know when you want to start and we can get you a car.")
	    	themis.dialogbutton("Got it. (Close)", 40, function()
	    		self:Remove()	
	    	end)
			end)
	    	end)
		end)
	end)
	
	
	net.Receive("taxi_resign", taxi_resignReceived)
	net.Receive("taxi_take", taxi_takeReceived)
	net.Receive("taxi_return", taxi_returnReceived)
	net.Receive("ui_taxi_hired_npc",function()
		cooldown = net.ReadBool()

	    themis.dialog("Niclas Weisz", "models/odessa.mdl", "Manager", "Berlin Taxis", function(ply)
	    	themis.dialogframe("Niclas Weisz", "models/odessa.mdl", "Manager", "Berlin Taxis")

	    	themis.dialogtext("What's up?")
	    	themis.dialogbutton("Nevermind. (Close)", 35, function()
	    		self:Remove()
			end)
			if (!IsValid(LocalPlayer().taxiEnt)) then
				themis.dialogbutton("I'd like to take out a Taxi.", 30, function()
						self:Remove()
						net.Start( "taxi_take" )
						net.SendToServer()
					end)
			else
				themis.dialogbutton("I'd like to return my Taxi.", 30, function()
						self:Remove()
						net.Start( "taxi_return" )
						net.SendToServer()
					end)
			end

	    	themis.dialogbutton("I'd like to resign.", 35, function()
	    		self:Remove()
				nut.util.notify("You have resigned from Berlin Taxis.")
				net.Start( "taxi_resign" )
				net.SendToServer()
			themis.dialogframe("Niclas Weisz", "models/odessa.mdl", "Manager", "Berlin Taxis")
			themis.dialogtext("Okay, let me know if you need another job. We're always in need of Drivers. Look after yourself.")	
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

		drawText("Niclas Weisz", x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 0.65)

		--if (desc) then
			drawText("Need some work?", x, y + 16, colorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
		--end
	end
end