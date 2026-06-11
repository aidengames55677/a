AddCSLuaFile();
ENT.Type = "anim"
ENT.PrintName	= "Help NPC"
ENT.Author	= "Themis Networks"
ENT.Category = "Themis Networks"

ENT.Spawnable	= true
ENT.AdminOnly	= true


function ENT:Initialize()
	if (SERVER) then
		self:SetModel( "models/stahl/humans/female/female_10.mdl" )
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

function ENT:setAnim()
	for k, v in ipairs(self:GetSequenceList()) do
		if (v:lower():find("idle") and v ~= "idlenoise") then
			return self:ResetSequence(k)
		end
	end

	self:ResetSequence(4)
end


if (SERVER) then

	util.AddNetworkString("ui_help_npc")

	function ENT:OnTakeDamage()
	    return false
	end 

	function ENT:AcceptInput( Name, Activator, Caller )    
	    if Name == "Use" and Caller:IsPlayer() then
		    net.Start("ui_help_npc")
		    net.Send(Caller)
	    end
	end
end

if (CLIENT) then

	jobs_government = {}
	jobs_civy_locations = {}

	vector = Vector(-2460.412842, 6512.143555, 7399.985352)
	jobs_civy_locations[ "taxi" ] = {
	name = "Berlin Taxis",
	coordsx = vector.x, coordsy = vector.y, coordsz = vector.z,
	}	
	
	vector = Vector(-2142.895264, 5861.764160, 7401.340820)
	jobs_civy_locations[ "delivery" ] = {
	name = "Delivery Driver",
	coordsx = vector.x, coordsy = vector.y, coordsz = vector.z,
	}
	
	vector = Vector(-11988.910156, 5655.202148, 7455.813477)
	jobs_government[ "ICC" ] = {
	name = "Inner City Compound",
	coordsx = vector.x, coordsy = vector.y, coordsz = vector.z,
	}	
	
	vector = Vector(-6533.100586, 8397.660156, 7629.066406)
	jobs_government[ "Reichstag" ] = {
	name = "Reichstag",
	coordsx = vector.x, coordsy = vector.y, coordsz = vector.z,
	}
	
	vector = Vector(-4358.155762, 9400.105469, 7469.590820)
	jobs_government[ "Polizei Station" ] = {
	name = "Polizei Station",
	coordsx = vector.x, coordsy = vector.y, coordsz = vector.z,
	}	
	
	vector = Vector(-2261.088379, 11669.701172, 7454.508789)
	jobs_government[ "SS-Head Quarters" ] = {
	name = "SS-Head Quarters",
	coordsx = vector.x, coordsy = vector.y, coordsz = vector.z,
	}
	
	vector = Vector(3374.700684, -3750.653320, 7496.926270)
	jobs_government[ "Outer City Compound" ] = {
	name = "Outer City Compound",
	coordsx = vector.x, coordsy = vector.y, coordsz = vector.z,
	}	
	
	vector = Vector(4640.182129, 11348.427734, 7437.641113)
	jobs_government[ "Luftwaffe Airfield" ] = {
	name = "Luftwaffe Airfield",
	coordsx = vector.x, coordsy = vector.y, coordsz = vector.z,
	}
	
	vector = Vector(-12032.221680, -5142.431152, 7861.087402)
	jobs_government[ "OKM Base" ] = {
	name = "OKM Base",
	coordsx = vector.x, coordsy = vector.y, coordsz = vector.z,
	}	
	
	vector = Vector(-8472.103516, 7348.211914, 7455.915039)
	jobs_government[ "Bendler Block" ] = {
	name = "Bendlerblock",
	coordsx = vector.x, coordsy = vector.y, coordsz = vector.z,
	}
	
	vector = Vector(-6537.129395, 5807.530273, 7461.087402)
	jobs_civy_locations[ "Bank" ] = {
	name = "Bank",
	coordsx = vector.x, coordsy = vector.y, coordsz = vector.z,
	}	
	
	vector = Vector(-5855.647461, 5905.104980, 7467.645508)
	jobs_civy_locations[ "General Store" ] = {
	name = "General Store",
	coordsx = vector.x, coordsy = vector.y, coordsz = vector.z,
	}
	
	vector = Vector(-3940.101807, 648.160095, 7379.183105)
	jobs_civy_locations[ "Forest NPC - Sell wood, ore and Craft!" ] = {
	name = "Forest NPC - Sell wood, ore and Craft!",
	coordsx = vector.x, coordsy = vector.y, coordsz = vector.z,
	}	
	
	vector = Vector(-6904.987793, 761.622925, 7407.437500)
	jobs_civy_locations[ "Fishing" ] = {
	name = "Fishing",
	coordsx = vector.x, coordsy = vector.y, coordsz = vector.z,
	}
	

	net.Receive("ui_help_npc",function()
		cooldown = net.ReadBool()

	    themis.dialog("Martina Kohl", "models/stahl/humans/female/female_01.mdl", "Help", "Themis Networks", function(ply)
	    	themis.dialogframe("Martina Kohl", "models/stahl/humans/female/female_01.mdl", "Help", "Themis Networks")

	    	themis.dialogtext("Welcome to Themis Networks, how may I help you today?")

	    	themis.dialogbutton("I'm seeing errors (Content)", 40, function()
			gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=2223725129")
	    		self:Remove()
	    	end)
			
			if (hook.GetTable()["HUDPaint"] && hook.GetTable()["HUDPaint"]["WeighPoint"]) then
				themis.dialogbutton("Remove my waypoints.", 40, function()
					hook.Remove("HUDPaint", "WeighPoint")
					self:Remove()
				end)
			end
	    	themis.dialogbutton("I'm looking for a job.", 40, function()
	    		self:Remove()
				
			themis.dialogframe("Martina Kohl", "models/stahl/humans/female/female_01.mdl", "Help", "Themis Networks")
			themis.dialogtext("There are a few places around the city that are hiring. Local bars and restaurants especially! Ask around and I'm sure you'll find something. I also have a list of other jobs and locations you may be interested in if you'd like to take a look.")	
	    	themis.dialogbutton("Nevermind, thank you anyway. (Close)", 35, function()
				self:Remove()
				end)
	    	themis.dialogbutton("Sure! Look below for useful civilian locations.", 35, function()
				self:Remove()

				self.frame = vgui.Create("WolfFrame")
				self.frame:SetTitle("List of jobs and locations:")
				self.frame:SetSize(500,500)
				self.frame:Center()
				self.frame:MakePopup()
				local wow = self.frame

				for k, v in pairs(jobs_civy_locations) do
					self.button = vgui.Create("WButton", self.frame)
					self.button:SetText(v.name)
					self.button:Dock(TOP)
					self.button:SetColorAcc(Color(30,31,33))
					self.button:SetupHover(Color(35,36,38))
					self.button:DockMargin(0, 0, 0, 5)
					self.button:SetTextColor(color_white)
					self.button:SetTall(45)
					self.button.DoClick = function()
						wow:Remove()
						LocalPlayer():notify(v.name.. " has been marked on your screen. Follow the waypoint to get to the destination. ")
							LocalPlayer():SetWeighPoint(v.name, Vector(v.coordsx,v.coordsy,v.coordsz), function()
								LocalPlayer():notify("You have arrived.")
							end)
					end
				end
		    end)
			themis.dialogbutton("Sure! Look below for useful government locations.", 35, function()
				self:Remove()

				self.frame = vgui.Create("WolfFrame")
				self.frame:SetTitle("List of jobs and locations:")
				self.frame:SetSize(500,500)
				self.frame:Center()
				self.frame:MakePopup()
				local wow = self.frame

				for k, v in pairs(jobs_government) do
					self.button = vgui.Create("WButton", self.frame)
					self.button:SetText(v.name)
					self.button:Dock(TOP)
					self.button:SetColorAcc(Color(30,31,33))
					self.button:SetupHover(Color(35,36,38))
					self.button:DockMargin(0, 0, 0, 5)
					self.button:SetTextColor(color_white)
					self.button:SetTall(45)
					self.button.DoClick = function()
						wow:Remove()
						LocalPlayer():notify(v.name.. " has been marked on your screen. Follow the waypoint to get to the destination. ")
							LocalPlayer():SetWeighPoint(v.name, Vector(v.coordsx,v.coordsy,v.coordsz), function()
								LocalPlayer():notify("You have arrived.")
							end)
					end
				end
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

		drawText("Martina Kohl", x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 0.65)

		--if (desc) then
			drawText("Need anything?", x, y + 16, colorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
		--end
	end
end