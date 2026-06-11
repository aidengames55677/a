PLUGIN.name = "Car Claimer"
PLUGIN.desc = "Auto claims cars so their owners can lock/unlock them"
PLUGIN.author = "Robert Bearson (fixed by JayyKashtaCodes)"

if SERVER then
	local timeToEnter = 1
	hook.Add("PlayerSpawnedVehicle", "autoVehicleClaimer", function(ply, ent)
		if ent:IsVehicle() then
			print(ply:Nick() .. " Spawned a car, auto claiming!")
			function ent:CPPIGetOwner()
				return ply
			end

			if simfphys and simfphys.IsCar(ent) then
				function ent:Use(client)
					if self.IsLocked then return end
					client:setAction("Entering Vehicle...", timeToEnter, function()
						ent:SetPassenger(client)
					end)
				end
			end
		end
	end)
end