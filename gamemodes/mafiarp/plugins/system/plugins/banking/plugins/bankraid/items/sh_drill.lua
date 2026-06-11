ITEM.name = "Dynamite"
ITEM.uniqueID = "wdrill"
ITEM.category = "Banking"
ITEM.model = Model("models/dav0r/tnt/tnttimed.mdl")
ITEM.desc = "Dynamite Used In Bank Robberies"
ITEM.drillspeed = 10

ITEM.functions = {}
ITEM.functions.Place = {
	alias = "Place Dynamite",
	icon = "icon16/tag_blue_edit.png",
	menuOnly = true,
	onRun = function(item)
		if (SERVER) then
			local client = item.player
			local raytrace = client:GetEyeTraceNoCursor()
			local door = raytrace.Entity
			
			if (IsValid(door)) then
				if (door:GetPos():Distance(client:GetPos()) <= 128) then
					if (!IsValid(door.combinelock)) then
						if (door:GetClass() == "prop_door_rotating") then
							local angs = raytrace.HitNormal:Angle() + Angle(0, 0, 0)
							local pos = raytrace.HitPos + (raytrace.HitNormal * 1) + Vector(5, 5, 0)

							local drill = ents.Create("nut_drill")
							drill:SetPos(pos)
							drill:SetAngles(angs)
							drill:SetParent(door)
							drill:SetAmount("DrillTime", item.drillspeed)
							drill:Spawn()

							-- Start the 10-second timer
							timer.Simple(item.drillspeed, function()
								door:Fire("Unlock", 0)
								door:Fire("Open", 0)

								-- Play the sound effect at the end of the timer
								door:EmitSound("ambient/explosions/explode_4.wav", 100, 100)
							end)
						elseif (door:GetClass() == "nut_vault" and door:GetDTBool(2) != true) then
							door:SetAmount("DrillTime", item.drillspeed)
							door:drillIntoVault()

							-- Start the 10-second timer
							timer.Simple(item.drillspeed, function()
								-- Add code to handle what happens after the drill is complete for the vault

								-- Play the sound effect at the end of the timer
								door:EmitSound("ambient/explosions/explode_4.wav", 100, 100)
							end)
						end
					end
				end
			end
		end
	end
}
