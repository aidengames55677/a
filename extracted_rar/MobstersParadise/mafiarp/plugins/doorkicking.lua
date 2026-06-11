-- "gamemodes\\mafiarp\\plugins\\doorkicking.lua"

PLUGIN.name = "Door Kick"
PLUGIN.author = "Thadah Denyse"
PLUGIN.desc = "Allows Combine to kick doors open."

local blockedDoors = {		
	["rp_city8_spanish"] = {},
}

if (SERVER) then 
	util.AddNetworkString("DoorKickView")
	nut.command.add("doorkick", {
		syntax = "",
		onRun = function(client)
			local char = client:getChar()
			if (char:getFaction() != FACTION_POLICE && char:getFaction() != FACTION_GOVERNMENTSTATE) then
				client:notify("You are too weak to kick this door in!")
				return
			end

			if (client.lastDoorKick or 0) > CurTime() - 5 then
				client:notify("You can only use this command every 5 seconds!")
				return
			end

			local ent = client:GetEyeTraceNoCursor().Entity
			if ent.IsSimfphyscar then
				local driver = ent:GetDriver()
				if ent:GetPos():Distance(client:GetPos()) < 175 and driver != NULL then
					local speed = ent:GetVelocity():Length()
					speed = math.Round(speed * 0.0568182,0)
					if speed < 14 then
						client.lastDoorKick = CurTime()
						driver:ExitVehicle()
					else
						client:notify("This vehicle is going too fast or you are too far to remove the driver from it!")
					end
					return
				end
			end

			if IsValid(ent) and ent:isDoor() then
				local dist = ent:GetPos():Distance( client:GetPos() )
				if dist > 60 and dist < 80 then
					
					local blocked = blockedDoors[game.GetMap()]
					if (!blocked or !table.HasValue(blocked, ent:EntIndex())) and (!ent:getNetVar("faction") or ent:getNetVar("faction") != FACTION_STAFF) then
						client:Freeze(true)
						net.Start("DoorKickView")
						net.Send(client)
						timer.Simple(0.5, function()
							if IsValid(ent) then
								ent:Fire("unlock")
								ent:Fire("open")															
							end
							timer.Simple(0.9, function() 						
								client:Freeze(false)					
							end)	
						end)			
					else					
						client:notify("This door can not be kicked in!")					
					end				
				elseif dist < 60 then			
					client:notify("You are too close to kick the door down!")		
				elseif dist > 80 then			
					client:notify("You are too far to kick the door down!")			
				end
			else
				client:notify("You are looking at an invalid door")
			end
		end
	})
end

if (CLIENT) then
	net.Receive("DoorKickView", function()
		LocalPlayer().KickingInDoor = true
		timer.Simple(1.4, function()
			LocalPlayer().KickingInDoor = false
		end)
	end)
	
	local function KickView(client, pos, ang)
		if client.KickingInDoor then
			local origin = pos + client:GetAngles():Forward() * -10
			return {
				origin = origin,
				angles = (pos - origin):Angle()
			}
		end
	end
	hook.Add("CalcView", "doorkick_view", KickView)
end
