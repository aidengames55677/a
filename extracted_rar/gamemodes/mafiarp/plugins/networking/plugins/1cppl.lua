local PLUGIN = PLUGIN or {}
PLUGIN.name = "1cppl - 1 car per player"
PLUGIN.desc = "Limits car per player"
PLUGIN.author = "It's A Narco (fixed by JayyKashtaCodes)"

if SERVER then
	PLUGIN.carRestrictionPlyCount = 110 --If there's more or equal players to this number. Restrict all cars to 0
	PLUGIN.afkchecktime = 600 --After how much time of inactivity can the vehicle be marked for removal

	PLUGIN.optimizingRestriction = {
		["prop_vehicle_prisoner_pod"] = true, --DO NOT REMOVE
		["drb_chernobyl_bug"] = true --Vehicle class that cannot get removed by optimization
	}

	PLUGIN.restrictionByRank = {
		["admin"] = {
			drb_chernobyl_bug = true
		}
	}

	local function OptimizeVehicles(num)
		local vs = {}
		for k,v in pairs(ents.GetAll()) do
			if v:IsVehicle() then
				if PLUGIN.optimizingRestriction[v:GetClass()] then continue end
				table.insert(vs, v)
			end
		end
		
		--Removing vehicle that are over-limit
		local total = table.Count(vs)
		if total > num then
			local diff = total - num
			for i=1, diff, 1 do
				local vh = vs[i]
				vh:Remove()

				--Notifying
				if vh.vehowner then
					if (vh.vehowner:GetUserGroup() == 'founder') then continue end
					vh.vehowner:notify("Your vehicle has been removed due to max player threshold")
				end
			end
		end
	end

	--Checking if server can optimize vehicles
	timer.Create("CarStatusChecker", 5, 0, function()
		if #player.GetAll() >= PLUGIN.carRestrictionPlyCount then
			OptimizeVehicles(0)
		end
	end)
	
	hook.Add("PlayerSpawnedVehicle", "AssignCarToPlayer", function(ply, ent)
		ply.spveh = true
		ent.vehowner = ply
		
		ent:CallOnRemove("rem1cppl", function (ent)
			local ow = ent.vehowner
			if ow then
				ow.spveh = false
			end
		end)
	end)
	
	hook.Add("PlayerSpawnVehicle", "Checkifplayerisallowedanotherchar", function(ply, model, name, info)
		if ply:IsAdmin() or ply:IsSuperAdmin() then
			return true
		end

		for k,v in pairs(PLUGIN.restrictionByRank) do
			if ply:IsUserGroup(k) then
				if PLUGIN.restrictionByRank[k][name] then
					ply:notify("You are not allowed to spawn this vehicle")
					return false
				end
			end
		end

		if #player.GetAll() >= PLUGIN.carRestrictionPlyCount then
			ply:notify("Cannot spawn a vehicle! There are too many players!")
			return false
		end
		
		if ply.spveh then
			ply:notify("You cannot spawn another vehicle.")
			return false
		end
	end)
	
	concommand.Add("resetotvs", function()
		for k,v in pairs(player.GetAll()) do
			v.spveh = false
		end
	end)
end

