PLUGIN.name = "Basic Prop Protection"
PLUGIN.author = "Chessnut"
PLUGIN.desc = "Adds a simple prop protection system."

local globalRanks = {
	eventmanager = true,
	moderator = true,
	administrator = true,
	seasonedadministrator = true,
	senioradministrator = true,
	superadministrator = true,
	headadministrator = true,
	communitymanager = true,
	founder = true,
}

if (SERVER) then
	local function getLogName(entity)
		local class = entity:GetClass():lower()

		if (class:find("prop")) then
			local propType = class:sub(6)

			if (propType == "physics") then
				propType = "prop"
			end

			class = propType.." ("..entity:GetModel()..")"
		end

		return class
	end

	function PLUGIN:PlayerSpawnObject(client, model, skin)
		if ((client.nutNextSpawn or 0) < CurTime()) then
			client.nutNextSpawn = CurTime() + 0.75
		else
			if(client.AdvDupe2 and client.AdvDupe2.Pasting) then
				return true
			end
			
			return false
		end
	end
RestrictedEntityList = {"prop_door_rotating", "func_door_rotating", "func_door", "prop_dynamic", "func_wall_toggle", "func_tracktrain", "nut_vendor", "tb530_shipven", "nut_shipment", "clothing_vendor", "free_bodygroupr", "npc_cardealer", "delivery_npc", "ems_pd", "armory_fbi", "armory_marshall", "payphone", "policecardealer_npc", "police_phone", "armory_police2", "armory_police", "taxi_npc", "help_npc", "garage_public", "worker_npc", "sh_teller", "ballotbox", "wheel_of_luck", "cw_ammo_crate_regular", "tx_writter", "tvsystem6_camera", "tvsystem6_screen_huge", "tvsystem6_screen_large", "tvsystem6_screen_medium", "tvsystem6_radio", "tvsystem6_screen", "tvsystem6_screen_small", "tvsystem6_workstation", "pcasino_blackjack_table", "pcasino_roulette_table", "pcasino_slot_machine", "pcasino_wheel_slot_machine", "pcasino_mystery_wheel", "mediaplayer_tv", "billiard_table", "plasticsurgery_npc", "languages_npc", "func_brush", "jailor_npc", "clothing_vendor_miami", "airport_npc", "bankaccount_npc", "pcasino_blackjack_panel", "clothing_vendor_pendretti", "garage_nypd", "npc_nypdcardealer", "atm", "casinonpc", "advertboard", "atm", "serialnumber_computer", "trader"  }
RestrictedEntityAllowed2 = { "founder", "communitymanager", "headadministrator"}

	function PLUGIN:PhysgunPickup(client, entity)
		if (entity.PhysgunDisabled && !table.HasValue(RestrictedEntityAllowed2, client:GetUserGroup())) then
			return false
		end
		if (entity:GetCreator() == client or globalRanks[client:GetUserGroup()] and !table.HasValue(RestrictedEntityList, entity:GetClass())) then
			return true
		end
		if (table.HasValue(RestrictedEntityList, entity:GetClass()) && !table.HasValue(RestrictedEntityAllowed2, client:GetUserGroup())) then
			return false
		end
	end

	function PLUGIN:CanProperty(client, property, entity)
		if (entity.PhysgunDisabled && !table.HasValue(RestrictedEntityAllowed2, client:GetUserGroup())) then
			return false
		end
		if (entity:GetCreator() == client and (property == "remover" or property == "collision") or globalRanks[client:GetUserGroup()] and !table.HasValue(RestrictedEntityList, entity:GetClass())) then
			return true
		end
		if (table.HasValue(RestrictedEntityList, entity:GetClass()) && !table.HasValue(RestrictedEntityAllowed2, client:GetUserGroup())) then
			return false
		end
	end

	function PLUGIN:CanTool(client, trace, tool)
		local entity = trace.Entity
		if (entity.PhysgunDisabled && !table.HasValue(RestrictedEntityAllowed2, client:GetUserGroup())) then
			return false
		end
		if (IsValid(entity) and entity:GetCreator() == client or IsValid(entity) and globalRanks[client:GetUserGroup()] and !table.HasValue(RestrictedEntityList, entity:GetClass())) then
			return true
		end
		if (table.HasValue(RestrictedEntityList, entity:GetClass()) && !table.HasValue(RestrictedEntityAllowed2, client:GetUserGroup()) or (!table.HasValue(RestrictedEntityAllowed2, client:GetUserGroup()) and (IsValid(entity) and entity:GetCreator() != client))) then
			return false
		end
	end

	function PLUGIN:PlayerSpawnedEntity(client, entity)
		entity:SetCreator(client)
		entity:SetNW2Entity("Creator", client)
	end

	function PLUGIN:PlayerSpawnedProp(client, model, entity)
		hook.Run("PlayerSpawnedEntity", client, entity)
	end

	PLUGIN.PlayerSpawnedEffect = PLUGIN.PlayerSpawnedProp
	PLUGIN.PlayerSpawnedRagdoll = PLUGIN.PlayerSpawnedProp

	function PLUGIN:PlayerSpawnedNPC(client, entity)
		hook.Run("PlayerSpawnedEntity", client, entity)
	end

	PLUGIN.PlayerSpawnedSENT = PLUGIN.PlayerSpawnedNPC
	PLUGIN.PlayerSpawnedVehicle = PLUGIN.PlayerSpawnedNPC
	
	function PLUGIN:CanPlayerUnfreeze(ply, ent, phys)
		if !globalRanks[ply:GetUserGroup()] and ent:GetCreator() != ply then return false end

		if (table.HasValue(RestrictedEntityList, ent:GetClass()) && !table.HasValue(RestrictedEntityAllowed2, ply:GetUserGroup())) then
			return false
		end
	end
end
