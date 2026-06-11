-- "gamemodes\\mafiarp\\schema\\sh_wiretap_FIXED.lua"
-- Fixed Wiretapping System
-- FIXES APPLIED:
--   [C3] removed counter now incremented in expire loop
--   [C5] Target stored by SteamID64 (not UserID) – survives reconnects
--   [M6] targetPlayer raw entity replaced with steamID string + safe name cache
--   [m4] Circular buffer transcript now reads in chronological order
--   [m5] Long transcripts split into pages (notify has char limits)
--   [X3] nut.log calls wrapped with nil guard

WIRETAP_SYSTEM              = WIRETAP_SYSTEM              or {}
WIRETAP_SYSTEM.wiretaps     = WIRETAP_SYSTEM.wiretaps     or {}
WIRETAP_SYSTEM.targetIndex  = WIRETAP_SYSTEM.targetIndex  or {} -- SteamID64 → wiretapID

-- ============ CONFIGURATION ============
local MAX_CONVERSATIONS_PER_WIRETAP = 500
local MAX_ACTIVE_WIRETAPS           = 100
local HEAT_DISCOVERY_THRESHOLD      = 100
local HEAT_DECAY_RATE               = 1   -- per minute
local HEAT_MAX                      = 150
local WIRETAP_TIMEOUT               = 86400 -- 24 hours

-- ============ HELPERS ============
local function IsValidWiretap(id)
	return WIRETAP_SYSTEM.wiretaps[id] ~= nil
end

local function CountActiveWiretaps()
	local count = 0
	for _, w in pairs(WIRETAP_SYSTEM.wiretaps) do
		if w.active then count = count + 1 end
	end
	return count
end

-- [FIX X3] Safe logging wrapper – nut.log may be nil if the logging plugin is broken
local function SafeLog(ply, ...)
	if nut.log and nut.log.add then
		nut.log.add(ply, ...)
	end
end

-- ============ SERVER-SIDE ============
if SERVER then

	-- Heat decay every minute
	timer.Create("WiretapHeatDecay", 60, 0, function()
		for _, wiretap in pairs(WIRETAP_SYSTEM.wiretaps) do
			if wiretap.active and wiretap.heat > 0 then
				wiretap.heat = math.max(0, wiretap.heat - HEAT_DECAY_RATE)
			end
		end
	end)

	-- Auto-expire old wiretaps
	timer.Create("WiretapExpire", 3600, 0, function()
		local now     = CurTime()
		local removed = 0 -- [FIX C3] counter now used

		for id, wiretap in pairs(WIRETAP_SYSTEM.wiretaps) do
			if now - wiretap.placedTime > WIRETAP_TIMEOUT then
				WIRETAP_SYSTEM:RemoveWiretap(id)
				removed = removed + 1 -- [FIX C3]
			end
		end

		if removed > 0 then
			print("[WIRETAP] Auto-removed " .. removed .. " expired wiretaps")
		end
	end)

	-- Place a wiretap on a target player
	function WIRETAP_SYSTEM:PlaceWiretap(position, placedBy, targetPlayer)
		if not IsValid(placedBy) or not IsValid(targetPlayer) then
			return nil, "Invalid player"
		end

		-- Permission check
		if not (placedBy:HasFlag("W") or placedBy:IsSuperAdmin()) then
			return nil, "Insufficient permissions"
		end

		-- Admin protection
		if targetPlayer:IsSuperAdmin() or targetPlayer:IsAdmin() then
			placedBy:notify("Cannot wiretap administrators")
			SafeLog(placedBy, "wiretapAttemptOnAdmin", targetPlayer:Nick())
			return nil, "Admin protected"
		end

		-- Server limit
		if CountActiveWiretaps() >= MAX_ACTIVE_WIRETAPS then
			return nil, "Too many active wiretaps"
		end

		-- [FIX C5] Use SteamID64 instead of UserID – survives player reconnects
		local targetSteamID = targetPlayer:SteamID64()
		if WIRETAP_SYSTEM.targetIndex[targetSteamID] then
			return nil, "Target already wiretapped"
		end

		local wiretapID = "wiretap_" .. CurTime() .. "_" .. math.random(10000, 99999)

		self.wiretaps[wiretapID] = {
			id           = wiretapID,
			position     = position,
			placedBy     = placedBy:SteamID64(),
			placedByName = placedBy:Nick(),
			-- [FIX M6] Store only immutable/safe data – no raw entity reference
			targetSteamID = targetSteamID,
			targetName    = targetPlayer:Nick(),
			placedTime    = CurTime(),
			active        = true,
			conversations = {},    -- circular buffer entries
			convCount     = 0,     -- total messages ever written
			convIndex     = 0,     -- current write position (1-based)
			discovered    = false,
			discoveredBy  = nil,
			heat          = 0,
		}

		-- [FIX C5] Index by SteamID64
		WIRETAP_SYSTEM.targetIndex[targetSteamID] = wiretapID

		print("[WIRETAP] Placed on " .. targetPlayer:Nick() .. " by " .. placedBy:Nick())
		SafeLog(placedBy, "placedWiretap", targetPlayer:Nick(), 1)

		return wiretapID
	end

	-- Intercept player chat
	hook.Add("PlayerSay", "WiretapInterceptChat", function(ply, text, teamOnly)
		-- [FIX C5] Look up by SteamID64
		local targetSteamID = ply:SteamID64()
		local wiretapID     = WIRETAP_SYSTEM.targetIndex[targetSteamID]
		if not wiretapID then return end

		local wiretap = WIRETAP_SYSTEM.wiretaps[wiretapID]
		if not wiretap or not wiretap.active then return end

		-- Write to circular buffer
		wiretap.convIndex = (wiretap.convIndex % MAX_CONVERSATIONS_PER_WIRETAP) + 1
		wiretap.convCount = wiretap.convCount + 1

		wiretap.conversations[wiretap.convIndex] = {
			speaker   = ply:Nick(),
			message   = text,
			time      = os.date("%H:%M:%S"),
			timestamp = CurTime(),
			seq       = wiretap.convCount, -- for chronological sorting
		}

		wiretap.heat = math.min(wiretap.heat + 1, HEAT_MAX)

		-- Discovery check
		if wiretap.heat > HEAT_DISCOVERY_THRESHOLD then
			if math.random(1, 100) <= 10 then
				wiretap.discovered = true
				if IsValid(ply) then
					ply:notify("⚠️ WARNING: You suspect you are being monitored!")
				end
			end
		end

		-- Notify listening officers
		for _, officer in ipairs(player.GetAll()) do
			if IsValid(officer) and officer:HasFlag("W") then
				officer:notify("[TAP #" .. string.sub(wiretapID, 1, 8) .. "] " .. ply:Nick() .. ": " .. text)
			end
		end
	end)

	-- Remove a wiretap
	function WIRETAP_SYSTEM:RemoveWiretap(wiretapID)
		if not IsValidWiretap(wiretapID) then return false end

		local wiretap = self.wiretaps[wiretapID]

		-- [FIX C5] Clear by SteamID64 key
		self.targetIndex[wiretap.targetSteamID] = nil

		wiretap.conversations = {}
		wiretap.active        = false

		timer.Simple(1, function()
			self.wiretaps[wiretapID] = nil
		end)

		return true
	end

	-- Get transcript with correct chronological order from circular buffer
	-- [FIX m4] Previously used ipairs(conversations) which gave wrong order after buffer wraps.
	-- Now reads from (convIndex+1) mod MAX forward, which is oldest-to-newest.
	function WIRETAP_SYSTEM:GetWiretapTranscript(wiretapID, maxLines)
		maxLines = math.min(maxLines or 50, 50) -- Hard cap at 50 per page for notify safety

		if not IsValidWiretap(wiretapID) then return nil end

		local wiretap  = self.wiretaps[wiretapID]
		local bufSize  = math.min(wiretap.convCount, MAX_CONVERSATIONS_PER_WIRETAP)
		local lines    = {}

		-- If buffer hasn't wrapped yet, iterate 1..convIndex in order.
		-- If wrapped, start from (convIndex % MAX)+1 for chronological output.
		local startIdx
		if wiretap.convCount <= MAX_CONVERSATIONS_PER_WIRETAP then
			startIdx = 1
		else
			startIdx = (wiretap.convIndex % MAX_CONVERSATIONS_PER_WIRETAP) + 1
		end

		for i = 0, bufSize - 1 do
			local idx   = ((startIdx - 1 + i) % MAX_CONVERSATIONS_PER_WIRETAP) + 1
			local entry = wiretap.conversations[idx]
			if entry then
				table.insert(lines, "[" .. entry.time .. "] " .. entry.speaker .. ": " .. entry.message)
			end
		end

		-- Return the last maxLines entries
		local result = {}
		local startLine = math.max(1, #lines - maxLines + 1)
		for i = startLine, #lines do
			table.insert(result, lines[i])
		end

		return {
			header = "=== WIRETAP #" .. string.sub(wiretapID, 1, 12) ..
			         " | TARGET: " .. wiretap.targetName ..
			         " | HEAT: " .. wiretap.heat .. "/" .. HEAT_MAX .. " ===",
			lines  = result,
		}
	end

	-- [FIX m5] Helper to send transcript in safe-sized chunks
	local function SendTranscriptToPlayer(ply, wiretapID, maxLines)
		local t = WIRETAP_SYSTEM:GetWiretapTranscript(wiretapID, maxLines)
		if not t then
			ply:notify("Wiretap not found.")
			return
		end

		ply:notify(t.header)
		for _, line in ipairs(t.lines) do
			ply:notify(line)
		end
		ply:notify("--- End of transcript (" .. #t.lines .. " lines) ---")
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
			if string.find(string.lower(p:Nick()), string.lower(targetName), 1, true) then
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
				ply:notify("[" .. string.sub(id, 1, 8) .. "] " .. wiretap.targetName ..
				           " | HEAT: " .. wiretap.heat .. "/" .. HEAT_MAX)
				count = count + 1
			end
		end
		ply:notify("Active: " .. count .. "/" .. MAX_ACTIVE_WIRETAPS)
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
		local maxLines  = math.min(tonumber(args[2]) or 50, 50)

		if not wiretapID then
			ply:notify("Usage: mp_wiretap_transcript <wiretap_id> [max_lines]")
			return
		end

		SendTranscriptToPlayer(ply, wiretapID, maxLines)
	end)

elseif CLIENT then
	-- Client-side placeholder for future wiretap HUD
	hook.Add("HUDPaint", "WiretapWarningClient", function()
		-- Populated by server net message if player is flagged as tapped
	end)
end

print("[WIRETAP] System loaded – SteamID64 tracking, memory safe, heat decay, admin protected")
