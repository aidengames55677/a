-- "gamemodes\\mafiarp\\schema\\sh_wiretap_FIXED.lua"
-- Fixed Wiretapping System
-- ✓ #2: Memory leak fixed (circular buffer, max 500 messages)
-- ✓ #8: Heat bounded and decays
-- ✓ #9: Heat decreases over time
-- ✓ #13: Indexed for O(1) lookup
-- ✓ #14: Permission checks added
-- ✓ #15: Admin protection added

WIRETAP_SYSTEM = WIRETAP_SYSTEM or {}
WIRETAP_SYSTEM.wiretaps = {}
WIRETAP_SYSTEM.targetIndex = {} -- Fast lookup: playerID -> wiretapID

-- ============ CONFIGURATION ============
local MAX_CONVERSATIONS_PER_WIRETAP = 500 -- MEMORY LIMIT
local MAX_ACTIVE_WIRETAPS = 100 -- Server limit
local HEAT_DISCOVERY_THRESHOLD = 100
local HEAT_DECAY_RATE = 1 -- Per minute
local HEAT_MAX = 150
local WIRETAP_TIMEOUT = 86400 -- 24 hours

-- ============ HELPER FUNCTIONS ============
local function IsValidWiretap(wiretapID)
	return WIRETAP_SYSTEM.wiretaps[wiretapID] ~= nil
end

local function CountActiveWiretaps()
	local count = 0
	for id, wiretap in pairs(WIRETAP_SYSTEM.wiretaps) do
		if wiretap.active then count = count + 1 end
	end
	return count
end

-- ============ SERVER-SIDE WIRETAP MANAGEMENT ============
if SERVER then
	-- Heat decay system
	timer.Create("WiretapHeatDecay", 60, 0, function()
		for id, wiretap in pairs(WIRETAP_SYSTEM.wiretaps) do
			if wiretap.active and wiretap.heat > 0 then
				wiretap.heat = math.max(0, wiretap.heat - HEAT_DECAY_RATE)
			end
		end
	end)
	
	-- Auto-expire old wiretaps
	timer.Create("WiretapExpire", 3600, 0, function()
		local now = CurTime()
		local removed = 0
		
		for id, wiretap in pairs(WIRETAP_SYSTEM.wiretaps) do
			if now - wiretap.placedTime > WIRETAP_TIMEOUT then
				WIRETAP_SYSTEM:RemoveWiretap(id)
			end
		end
		
		if removed > 0 then
			print("[WIRETAP] Auto-removed " .. removed .. " expired wiretaps")
		end
	end)
	
	-- Place wiretap with safety checks
	function WIRETAP_SYSTEM:PlaceWiretap(position, placedBy, targetPlayer)
		if not IsValid(placedBy) or not IsValid(targetPlayer) then
			return nil, "Invalid player"
		end
		
		-- PERMISSION CHECK
		if not (placedBy:HasFlag("W") or placedBy:IsSuperAdmin()) then
			return nil, "Insufficient permissions"
		end
		
		-- ADMIN PROTECTION
		if targetPlayer:IsSuperAdmin() or targetPlayer:IsAdmin() then
			placedBy:notify("Cannot wiretap administrators")
			nut.log.add(placedBy, "wiretapAttemptOnAdmin", targetPlayer:Nick())
			return nil, "Admin protected"
		end
		
		-- Server limit check
		if CountActiveWiretaps() >= MAX_ACTIVE_WIRETAPS then
			return nil, "Too many active wiretaps"
		end
		
		-- Check if already tapped
		if WIRETAP_SYSTEM.targetIndex[targetPlayer:UserID()] then
			return nil, "Target already wiretapped"
		end
		
		local wiretapID = "wiretap_" .. CurTime() .. "_" .. math.random(10000, 99999)
		
		self.wiretaps[wiretapID] = {
			id = wiretapID,
			position = position,
			placedBy = placedBy:SteamID64(),
			placedByName = placedBy:Nick(),
			targetPlayer = targetPlayer,
			targetID = targetPlayer:UserID(),
			targetName = targetPlayer:Nick(),
			placedTime = CurTime(),
			active = true,
			conversations = {}, -- Circular buffer
			convIndex = 0, -- Current position in buffer
			discovered = false,
			discoveredBy = nil,
			heat = 0,
		}
		
		-- Add to index for fast lookup
		WIRETAP_SYSTEM.targetIndex[targetPlayer:UserID()] = wiretapID
		
		print("[WIRETAP] Placed on " .. targetPlayer:Nick() .. " by " .. placedBy:Nick())
		nut.log.add(placedBy, "placedWiretap", targetPlayer:Nick(), 1)
		
		return wiretapID
	end
	
	-- Intercept player communications
	hook.Add("PlayerSay", "WiretapInterceptChat", function(ply, text, teamOnly)
		local userID = ply:UserID()
		local wiretapID = WIRETAP_SYSTEM.targetIndex[userID]
		
		if not wiretapID then return end
		
		local wiretap = WIRETAP_SYSTEM.wiretaps[wiretapID]
		if not wiretap or not wiretap.active then return end
		
		-- CIRCULAR BUFFER: Keep only last 500 messages
		wiretap.convIndex = (wiretap.convIndex % MAX_CONVERSATIONS_PER_WIRETAP) + 1
		
		wiretap.conversations[wiretap.convIndex] = {
			speaker = ply:Nick(),
			message = text,
			time = os.date("%H:%M:%S"),
			timestamp = CurTime(),
		}
		
		-- Heat increases by 1 (capped at HEAT_MAX)
		wiretap.heat = math.min(wiretap.heat + 1, HEAT_MAX)
		
		-- Discovery check (random chance, not deterministic)
		if wiretap.heat > HEAT_DISCOVERY_THRESHOLD then
			if math.random(1, 100) <= 10 then -- 10% chance per message when over threshold
				wiretap.discovered = true
				
				if IsValid(ply) then
					ply:notify("⚠️ WARNING: You suspect you are being monitored!")
				end
			end
		end
		
		-- Notify law enforcement listening
		for _, officer in ipairs(player.GetAll()) do
			if IsValid(officer) and officer:HasFlag("W") then
				officer:notify("[TAP #" .. string.sub(wiretapID, 1, 8) .. "] " .. ply:Nick() .. ": " .. text)
			end
		end
	end)
	
	-- Remove wiretap (law enforcement)
	function WIRETAP_SYSTEM:RemoveWiretap(wiretapID)
		if not IsValidWiretap(wiretapID) then return false end
		
		local wiretap = self.wiretaps[wiretapID]
		
		-- Clear target index
		self.targetIndex[wiretap.targetID] = nil
		
		-- Clear conversations (prevent memory leak)
		wiretap.conversations = {}
		
		-- Mark inactive
		wiretap.active = false
		
		-- Delete after short delay
		timer.Simple(1, function()
			self.wiretaps[wiretapID] = nil
		end)
		
		return true
	end
	
	-- Get wiretap transcript (LIMITED)
	function WIRETAP_SYSTEM:GetWiretapTranscript(wiretapID, maxLines)
		maxLines = maxLines or 100 -- LIMIT: Max 100 lines per transcript
		
		if not IsValidWiretap(wiretapID) then return nil end
		
		local wiretap = self.wiretaps[wiretapID]
		local transcript = "=== WIRETAP #" .. string.sub(wiretapID, 1, 12) .. " ===\n"
		transcript = transcript .. "TARGET: " .. wiretap.targetName .. "\n"
		transcript = transcript .. "HEAT: " .. wiretap.heat .. "/" .. HEAT_MAX .. "\n"
		transcript = transcript .. "=== CONVERSATIONS (Last " .. math.min(maxLines, #wiretap.conversations) .. ") ===\n"
		
		local count = 0
		for _, conv in ipairs(wiretap.conversations) do
			if count >= maxLines then break end
			transcript = transcript .. "\n[" .. conv.time .. "] " .. conv.speaker .. ": " .. conv.message
			count = count + 1
		end
		
		return transcript
	end
	
	-- Commands
	concommand.Add("mp_place_wiretap", function(ply, cmd, args)
		if not (ply:HasFlag("W") or ply:IsSuperAdmin()) then
			ply:notify("You lack authorization.")
			return
		end
		
		local targetName = args[1]
		if not targetName then
			ply:notify("Usage: mp_place_wiretap <player_name>")
			return
		end
		
		local target = nil
		for _, p in ipairs(player.GetAll()) do
			if string.find(string.lower(p:Nick()), string.lower(targetName)) then
				target = p
				break
			end
		end
		
		if not target then
			ply:notify("Player not found.")
			return
		end
		
		local wiretapID, err = WIRETAP_SYSTEM:PlaceWiretap(target:GetPos(), ply, target)
		if not wiretapID then
			ply:notify("Failed: " .. err)
			return
		end
		
		ply:notify("Wiretap placed: #" .. string.sub(wiretapID, 1, 12))
	end)
	
	concommand.Add("mp_wiretaps", function(ply, cmd, args)
		if not (ply:HasFlag("W") or ply:IsSuperAdmin()) then return end
		
		local count = 0
		for id, wiretap in pairs(WIRETAP_SYSTEM.wiretaps) do
			if wiretap.active then
				ply:notify("[" .. string.sub(id, 1, 8) .. "] " .. wiretap.targetName .. " | HEAT: " .. wiretap.heat .. "/" .. HEAT_MAX)
				count = count + 1
			end
		end
		
		ply:notify("Total active: " .. count .. "/" .. MAX_ACTIVE_WIRETAPS)
	end)
	
	concommand.Add("mp_remove_wiretap", function(ply, cmd, args)
		if not (ply:HasFlag("W") or ply:IsSuperAdmin()) then return end
		
		local wiretapID = args[1]
		if not wiretapID then
			ply:notify("Usage: mp_remove_wiretap <wiretap_id>")
			return
		end
		
		if WIRETAP_SYSTEM:RemoveWiretap(wiretapID) then
			ply:notify("Wiretap removed.")
		else
			ply:notify("Wiretap not found.")
		end
	end)
	
	concommand.Add("mp_wiretap_transcript", function(ply, cmd, args)
		if not (ply:HasFlag("W") or ply:IsSuperAdmin()) then return end
		
		local wiretapID = args[1]
		local maxLines = tonumber(args[2]) or 100
		
		local transcript = WIRETAP_SYSTEM:GetWiretapTranscript(wiretapID, maxLines)
		if transcript then
			ply:notify(transcript)
		else
			ply:notify("Wiretap not found.")
		end
	end)

-- ============ CLIENT-SIDE WARNING ============
elseif CLIENT then
	hook.Add("HUDPaint", "WiretapWarningClient", function()
		-- Client can't directly detect wiretaps
		-- Would need server to send notification
	end)
end

print("[WIRETAP] System loaded - Memory safe, heat decay enabled, admin protected")
