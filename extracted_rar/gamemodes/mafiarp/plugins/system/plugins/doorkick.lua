PLUGIN.name = "Door Kick"
PLUGIN.author = "Thadah Denyse"
PLUGIN.desc = "Allows Combine to kick doors open."
-- This plugin only works on models that have 'kickdoorbaton' animation (Basically, you must have a 'Combine' male model. (Like police.mdl)
-- If the model hasn't got that animation, it'll disappear when the command is issued.
if (SERVER) then 
	util.AddNetworkString("DoorKickView")
end

nut.command.add("doorkick", {
	syntax = "",
	onRun = function(client)
		local blockedDoors = {
		
			["rp_city8_spanish"] = {},
			["rp_typhon_berlin_v5"] = {112, 113, 1313, 1326, 1344, 1345, 1899, 27, 1886, 1661, 1651, 317, 1364, 1368, 1369, 2175, 2174, 2209, 83, 84, 947, 949, 113, 112, 1309, 1310, 1803, 1804, 1802, 128, 129, 2003, 2002, 2001, 2005, 1997, 360, 1439, 340, 1337, 295, 296, 1139, 1143, 1145, 1149, 1151, 1153, 2253, 2254, 1338, 1347, 1340, 1349, 1350, 1335, 1336, 1352, 1354, 1356, 1299, 1296, 2262, 862, 1845, 1842, 1829, 1079, 325, 328, 1914, 1824, 1826, 1825, 1322, 1323, 1326, 1327},
			["rp_typhon_berlin_v8"] = {961, 962, 958, 957, 845, 1917, 1032, 1033, 1043, 1042, 1037, 1036, 1044, 1045, 1046, 1047, 1048, 1049, 1050, 1051, 1052, 1053, 1054, 1055, 483, 504, 1034, 1358, 1363, 1361, 1388, 1390, 1759, 1761, 184, 183, 239, 240, 1475, 1345, 954, 1060},
		}
		
		local char = client:getChar()
		if (!char) then return end
		
		if (char:getFaction() == FACTION_CITIZEN || char:getFaction() == FACTION_daf || char:getFaction() == FACTION_ataxi || char:getFaction() == FACTION_prisoners) then
			
			client:notify("You are too weak to kick this door in!");
			return
			
		end
		
		if !client.isKickingDoor then
			local ent = client:GetEyeTraceNoCursor().Entity
			if IsValid(ent) and ent:isDoor() then
				if (ent.IsApartment && ent:IsApartment()) then
					local aptData = ApartmentSystem.Apartments[ent.Apartment]
					local ownerSteam
					local ownerChar
					if (aptData.Owner && aptData.Owner != "") then
						local ownerData = string.Explode(aptData.Owner, "|")
						if (#ownerData == 2) then
							ownerSteam = ownerData[1]
							ownerChar = ownerData[2]
						end
					end
					
					if (ownerSteam && ownerChar) then
						local pl = player.GetBySteamID(ownerSteam)
						if (pl && IsValid(pl) && pl:getChar() && pl:getChar():getID() == ownerChar) then
							if (SearchWarrants && (!SearchWarrants[ownerSteam] || SysTime() > SearchWarrants[ownerSteam])) then
								client:notify("This is private property. You need a warrant to kick this door down.")
								return
							end
						end
					end
				end
				local dist = ent:GetPos():Distance( client:GetPos() )
				if dist > 60 and dist < 80 then
					
					local blocked = blockedDoors[game.GetMap()]
					if (!blocked or !table.HasValue(blocked, ent:EntIndex())) and (!ent:getNetVar("faction") or ent:getNetVar("faction") != FACTION_STAFF) then
						client:Freeze(true)
						client.isKickingDoor = true
						net.Start("DoorKickView")
						net.Send(client)
						timer.Simple(0.5, function()
							timer.Simple( 0.9, function() 
							
								if IsValid( client ) then
							
									client:Freeze(false) 
									client.isKickingDoor = false 
								
								end	
							end)	
							
							if IsValid(ent) then
								ent:Fire("unlock")
								ent:Fire("open")
								local door = ents.Create("prop_physics")
								door:SetPos(ent:GetPos())
								door:SetAngles(ent:GetAngles())
								door:SetModel(ent:GetModel())
								door:SetSkin(ent:GetSkin())
								door:Spawn()
								door:GetPhysicsObject():SetVelocity((door:GetPos() - client:GetPos()) * 8)
									
								door:EmitSound( string.format( "physics/wood/wood_plank_break%d.wav", math.random(1, 4)))
									
								ent:SetNoDraw(true)
								ent:SetNotSolid(true)
								
								timer.Simple(30, function()						
									if IsValid(ent) then			
										ent:SetNoDraw(false )
										ent:SetNotSolid(false)		
									end
								
									if IsValid(door) then door:Remove() end				
								end)	
							end
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
	end
})


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
			local angles = (pos - origin):Angle()
		
			local view = {
				["origin"] = origin,
				["angles"] = angles
			}	
			return view	
		end
	end
	hook.Add("CalcView", "doorkick_view", KickView)
end