-- "gamemodes\\mafiarp\\schema\\sh_addiction.lua"
-- Addiction Management System - Mobsters Paradise

-- ============ GLOBAL ADDICTION SYSTEM ============
ADDICTION_SYSTEM = ADDICTION_SYSTEM or {}

-- Addiction levels and their effects
ADDICTION_SYSTEM.levels = {
	[0] = {name = "None", damage = 0},
	[1] = {name = "Mild", damage = 1},
	[2] = {name = "Moderate", damage = 3},
	[3] = {name = "Severe", damage = 5},
	[4] = {name = "Critical", damage = 10},
}

-- Drug addiction potential (how much addiction is gained per use)
ADDICTION_SYSTEM.drugAddictionRates = {
	["cocaine"] = 15,
	["crack"] = 25,
	["heroin"] = 20,
	["meth"] = 22,
	["opium"] = 18,
	["pcp"] = 18,
	["mdma"] = 12,
	["ketamine"] = 8,
	["weed"] = 5,
	["lsd"] = 4,
	["dmt"] = 2,
	["shrooms"] = 3,
	["ayahuasca"] = 1,
}

-- ============ HELPER FUNCTIONS ============
function ADDON_GetAddictionLevel(client)
	local char = client:getChar()
	if not char then return 0 end
	
	local addictions = char:getData("drugAddictions") or {}
	local highestAddiction = 0
	
	for drug, intensity in pairs(addictions) do
		if intensity > highestAddiction then
			highestAddiction = intensity
		end
	end
	
	return highestAddiction
end

function ADDON_GetAddictionStatus(client)
	local level = ADDON_GetAddictionLevel(client)
	
	if level < 10 then return ADDICTION_SYSTEM.levels[0] end
	if level < 25 then return ADDICTION_SYSTEM.levels[1] end
	if level < 50 then return ADDICTION_SYSTEM.levels[2] end
	if level < 75 then return ADDICTION_SYSTEM.levels[3] end
	return ADDICTION_SYSTEM.levels[4]
end

function ADDON_GetAddicatedDrugs(client)
	local char = client:getChar()
	if not char then return {} end
	
	local addictions = char:getData("drugAddictions") or {}
	local addictedDrugs = {}
	
	for drug, intensity in pairs(addictions) do
		if intensity > 10 then
			table.insert(addictedDrugs, {drug = drug, intensity = intensity})
		end
	end
	
	return addictedDrugs
end

function ADDON_ClearAllAddictions(client)
	local char = client:getChar()
	if not char then return false end
	
	char:setData("drugAddictions", {})
	
	-- Cure all withdrawal diseases
	cureDisease(client, "drug_cocaine_w")
	cureDisease(client, "drug_crack_w")
	cureDisease(client, "drug_heroin_w")
	cureDisease(client, "drug_meth_w")
	cureDisease(client, "drug_pcp_w")
	cureDisease(client, "drug_opium_w")
	
	return true
end

function ADDON_ClearSpecificAddiction(client, drugID)
	local char = client:getChar()
	if not char then return false end
	
	local addictions = char:getData("drugAddictions") or {}
	addictions[drugID] = nil
	char:setData("drugAddictions", addictions)
	
	-- Cure specific withdrawal
	local withdrawalID = "drug_"..string.lower(drugID).."_w"
	cureDisease(client, withdrawalID)
	
	return true
end

function ADDON_ReduceAddiction(client, amount)
	local char = client:getChar()
	if not char then return end
	
	local addictions = char:getData("drugAddictions") or {}
	
	for drug, intensity in pairs(addictions) do
		addictions[drug] = math.max(0, intensity - amount)
	end
	
	char:setData("drugAddictions", addictions)
end

-- ============ SERVER-SIDE FUNCTIONS ============
if SERVER then
	-- Withdrawal damage system
	hook.Add("Think", "ProcessWithdrawalDamage", function()
		for _, ply in ipairs(player.GetAll()) do
			if not IsValid(ply) or not ply:getChar() then continue end
			
			local char = ply:getChar()
			local addictions = char:getData("drugAddictions") or {}
			
			for drug, intensity in pairs(addictions) do
				if intensity > 20 then -- Only damage if addiction is significant
					-- Check if player is currently high on the drug
					local isHigh = char:getData("drug_"..drug)
					
					if not isHigh and (CurTime() % 5 < 0.1) then -- Every 5 seconds
						local damage = math.ceil(intensity / 20)
						ply:TakeDamage(damage)
						
						-- Random withdrawal messages
						local messages = {
							"You feel withdrawal symptoms...",
							"Your body aches for drugs...",
							"The cravings are overwhelming...",
							"You feel sick without it...",
							"Your hands shake uncontrollably...",
						}
						
						if math.random(1, 3) == 1 then
							ply:notify(messages[math.random(1, #messages)])
						end
					end
				end
			end
		end
	end)
	
	-- Hospital NPC interaction
	hook.Add("InitPostEntity", "RegisterAddictionNPC", function()
		-- Create doctor NPC at hospital for addiction treatment
		-- This would be spawned in your map with a special class
	end)
	
	-- Command for clearing addiction (admin only, for testing)
	concommand.Add("mp_clear_addiction", function(ply, cmd, args)
		if not ply:IsSuperAdmin() then
			ply:notify("You don't have permission to use this command.")
			return
		end
		
		local target = args[1]
		if not target then
			ADDON_ClearAllAddictions(ply)
			ply:notify("Your addictions have been cleared.")
			return
		end
		
		-- Find player by name/SteamID
		local foundPlayer = nil
		for _, p in ipairs(player.GetAll()) do
			if string.find(string.lower(p:Nick()), string.lower(target)) or p:SteamID() == target then
				foundPlayer = p
				break
			end
		end
		
		if foundPlayer then
			ADDON_ClearAllAddictions(foundPlayer)
			ply:notify("Cleared "..foundPlayer:Nick().."'s addictions.")
			foundPlayer:notify("Your addictions have been cleared by an administrator.")
		else
			ply:notify("Player not found.")
		end
	end)
end

-- ============ CLIENT-SIDE HUD ============
if CLIENT then
	hook.Add("HUDPaint", "DrawAddictionStatus", function()
		local ply = LocalPlayer()
		if not IsValid(ply) or not ply:getChar() then return end
		
		local addictions = ply:getChar():getData("drugAddictions") or {}
		if table.Count(addictions) == 0 then return end
		
		local y = 100
		local x = ScrW() - 300
		
		draw.RoundedBox(4, x, y, 280, 20, Color(50, 50, 50, 200))
		draw.SimpleText("DRUG ADDICTIONS", "HUDNumber5", x + 140, y + 2, Color(255, 50, 50), TEXT_ALIGN_CENTER)
		
		y = y + 30
		
		for drug, intensity in pairs(addictions) do
			if intensity > 10 then
				local levelName = ADDICTION_SYSTEM.levels[math.Clamp(math.ceil(intensity / 25), 0, 4)].name
				
				draw.SimpleText(string.upper(drug).." - "..levelName, "HUDNumber4", x + 10, y, Color(255, 100, 100))
				
				-- Draw intensity bar
				draw.RoundedBox(2, x + 10, y + 20, 260, 12, Color(30, 30, 30, 200))
				local barWidth = math.Clamp((intensity / 100) * 260, 0, 260)
				local barColor = Color(255 - (intensity * 2.55), 255 - (intensity * 2.55), 100)
				draw.RoundedBox(2, x + 10, y + 20, barWidth, 12, barColor)
				
				y = y + 40
			end
		end
	end)
end

-- ============ HOSPITAL NPC SYSTEM ============
-- This creates an NPC doctor that can treat addiction
if SERVER then
	local function CreateAddictionDoctor(x, y, z)
		local npc = ents.Create("npc_combine_s")
		npc:SetPos(Vector(x, y, z))
		npc:SetModel("models/humans/adaster/male_03.mdl")
		npc:Spawn()
		
		-- Make it passive
		npc:SetNPCState(NPC_STATE_IDLE)
		npc:CapabilitiesAdd(bits.CAP_TURN_HEAD)
		npc:CapabilitiesAdd(bits.CAP_ANIMATEDTURN)
		
		-- Store special data
		npc:SetKeyValue("name", "HospitalDoctor")
		npc:SetKeyValue("target_name", "hospital_doctor")
		
		-- Make NPC interactive
		npc.addictionDoctor = true
		
		return npc
	end
	
	-- Register command for hospital interaction
	concommand.Add("mp_treat_addiction", function(ply, cmd, args)
		-- This would be called when player uses "E" on the doctor
		local char = ply:getChar()
		if not char then return end
		
		-- Check if player is near a hospital location
		-- This is a simplified version - in real implementation you'd check proximity
		
		local cost = 500 -- $500 to treat addiction
		
		if char:getMoney() < cost then
			ply:notify("You can't afford addiction treatment ($"..cost..").")
			return
		end
		
		-- Charge the player
		char:giveMoney(-cost)
		
		-- Clear addictions
		ADDON_ClearAllAddictions(ply)
		
		ply:notify("Your addictions have been treated. (-$"..cost..")")
		nut.log.add(ply, "treatedAddiction", cost)
	end)
end

print("[Mobsters Paradise] Addiction system loaded!")
