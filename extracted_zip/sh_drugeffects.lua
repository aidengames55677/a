-- "gamemodes\\mafiarp\\plugins\\drugs\\sh_drugeffects_FIXED.lua"
-- Fixed Drug Effects System
-- ✓ #4: Null pointer checks added
-- ✓ #18: Disease system validation
-- ✓ Safe effect functions

-- Verify disease system exists
if not DISEASES then
	print("[DRUG EFFECTS] WARNING: Disease system not found!")
	print("[DRUG EFFECTS] Make sure Nutscript disease framework is loaded")
	return false
end

print("[DRUG EFFECTS] Initializing with disease system validation...")

local PLUGIN = PLUGIN

-- ============ HELPER FUNCTIONS ============
local function SafeApplyEffect(client, effectFn)
	if not IsValid(client) then return end
	
	local char = client:getChar()
	if not char then return end
	
	pcall(function()
		effectFn(client, char)
	end)
end

local function SafeSetSpeed(client, runSpeed, walkSpeed)
	if not IsValid(client) then return end
	if client:Health() <= 0 then return end -- Dead players
	
	pcall(function()
		client:SetRunSpeed(runSpeed)
		client:SetWalkSpeed(walkSpeed)
	end)
end

local function SafeTakeDamage(client, damage)
	if not IsValid(client) then return end
	if client:Health() <= 0 then return end
	
	pcall(function()
		client:TakeDamage(damage, client)
	end)
end

local function SafeSetHealth(client, health)
	if not IsValid(client) then return end
	if client:Health() <= 0 then return end
	
	pcall(function()
		client:SetHealth(math.Clamp(health, 1, client:GetMaxHealth()))
	end)
end

-- ============ COCAINE ============
local COCAINE = {}
COCAINE.uid = "drug_cocaine"
COCAINE.name = "Cocaine"
COCAINE.category = "Drugs"
COCAINE.duration = 300
COCAINE.phase = {
	"You feel lightheaded and euphoric.",
	"Your heart races intensely.",
	"Your pupils dilate dramatically.",
}
COCAINE.cure = {
	"The cocaine high wears off gradually.",
}
COCAINE.effect = function(client, char)
	SafeSetSpeed(client, 
		(nut.config.get("runSpeed") or 285) + 150,
		(nut.config.get("walkSpeed") or 135) + 100
	)
end
COCAINE.effectC = function(client, char)
	SafeSetSpeed(client,
		nut.config.get("runSpeed") or 285,
		nut.config.get("walkSpeed") or 135
	)
end

if DISEASES then DISEASES:Register(COCAINE) end

-- ============ CRACK COCAINE ============
local CRACK = {}
CRACK.uid = "drug_crack"
CRACK.name = "Crack Cocaine"
CRACK.category = "Drugs"
CRACK.duration = 240
CRACK.phase = {
	"RUSH! Intense euphoria floods your body!",
	"Your heart pumps like a jackhammer.",
}
CRACK.cure = {
	"The intense high crashes down.",
}
CRACK.effect = function(client, char)
	SafeSetSpeed(client,
		(nut.config.get("runSpeed") or 285) + 200,
		(nut.config.get("walkSpeed") or 135) + 150
	)
	SafeSetHealth(client, client:Health() + 15)
end
CRACK.effectC = function(client, char)
	SafeSetSpeed(client,
		nut.config.get("runSpeed") or 285,
		nut.config.get("walkSpeed") or 135
	)
end

if DISEASES then DISEASES:Register(CRACK) end

-- ============ HEROIN ============
local HEROIN = {}
HEROIN.uid = "drug_heroin"
HEROIN.name = "Heroin"
HEROIN.category = "Drugs"
HEROIN.duration = 480
HEROIN.phase = {
	"You feel your troubles slip away.",
	"Warmth spreads through your body.",
	"Everything feels perfect.",
}
HEROIN.cure = {
	"The heroin high gradually fades.",
}
HEROIN.effect = function(client, char)
	SafeSetHealth(client, client:Health() + 40)
	SafeSetSpeed(client,
		(nut.config.get("runSpeed") or 285) - 80,
		(nut.config.get("walkSpeed") or 135) - 80
	)
end
HEROIN.effectC = function(client, char)
	SafeSetSpeed(client,
		nut.config.get("runSpeed") or 285,
		nut.config.get("walkSpeed") or 135
	)
end

if DISEASES then DISEASES:Register(HEROIN) end

-- ============ METHAMPHETAMINE ============
local METH = {}
METH.uid = "drug_meth"
METH.name = "Methamphetamine"
METH.category = "Drugs"
METH.duration = 540
METH.phase = {
	"Your jaw clenches intensely.",
	"You feel like you can do ANYTHING.",
	"Energy surges through your veins.",
}
METH.cure = {
	"The meth high wears off.",
}
METH.effect = function(client, char)
	SafeSetSpeed(client,
		(nut.config.get("runSpeed") or 285) + 180,
		(nut.config.get("walkSpeed") or 135) + 120
	)
	if client.setLocalVar then
		client:setLocalVar("stm", 100)
	end
end
METH.effectC = function(client, char)
	SafeSetSpeed(client,
		nut.config.get("runSpeed") or 285,
		nut.config.get("walkSpeed") or 135
	)
end

if DISEASES then DISEASES:Register(METH) end

-- ============ MDMA / MOLLY ============
local MDMA = {}
MDMA.uid = "drug_mdma"
MDMA.name = "MDMA/Molly"
MDMA.category = "Drugs"
MDMA.duration = 480
MDMA.phase = {
	"You feel an overwhelming sense of euphoria.",
	"Love and peace flood your mind.",
	"Pure happiness and bliss.",
}
MDMA.cure = {
	"The MDMA high wears off.",
}
MDMA.effect = function(client, char)
	SafeSetSpeed(client,
		(nut.config.get("runSpeed") or 285) + 100,
		(nut.config.get("walkSpeed") or 135) + 50
	)
	if client.setLocalVar then
		client:setLocalVar("stm", 100)
	end
end
MDMA.effectC = function(client, char)
	SafeSetSpeed(client,
		nut.config.get("runSpeed") or 285,
		nut.config.get("walkSpeed") or 135
	)
end

if DISEASES then DISEASES:Register(MDMA) end

-- ============ PCP ============
local PCP = {}
PCP.uid = "drug_pcp"
PCP.name = "PCP"
PCP.category = "Drugs"
PCP.duration = 600
PCP.phase = {
	"You feel detached from your body.",
	"You feel unnaturally strong.",
	"Reality feels distorted.",
}
PCP.cure = {
	"Your PCP high finally subsides.",
}
PCP.effect = function(client, char)
	SafeSetSpeed(client,
		(nut.config.get("runSpeed") or 285) + 120,
		(nut.config.get("walkSpeed") or 135) + 80
	)
	SafeSetHealth(client, client:Health() + 20)
end
PCP.effectC = function(client, char)
	SafeSetSpeed(client,
		nut.config.get("runSpeed") or 285,
		nut.config.get("walkSpeed") or 135
	)
end

if DISEASES then DISEASES:Register(PCP) end

-- ============ KETAMINE ============
local KETAMINE = {}
KETAMINE.uid = "drug_ketamine"
KETAMINE.name = "Ketamine"
KETAMINE.category = "Drugs"
KETAMINE.duration = 360
KETAMINE.phase = {
	"You feel your body becoming lighter.",
	"You enter a dissociative state.",
	"Everything feels dreamlike.",
}
KETAMINE.cure = {
	"You gradually return to baseline.",
}
KETAMINE.effect = function(client, char)
	SafeSetHealth(client, client:Health() + 20)
	SafeSetSpeed(client,
		(nut.config.get("runSpeed") or 285) - 60,
		(nut.config.get("walkSpeed") or 135) - 60
	)
end
KETAMINE.effectC = function(client, char)
	SafeSetSpeed(client,
		nut.config.get("runSpeed") or 285,
		nut.config.get("walkSpeed") or 135
	)
end

if DISEASES then DISEASES:Register(KETAMINE) end

-- ============ PSILOCYBIN MUSHROOMS ============
local SHROOMS = {}
SHROOMS.uid = "drug_shrooms"
SHROOMS.name = "Magic Mushrooms"
SHROOMS.category = "Drugs"
SHROOMS.duration = 720
SHROOMS.phase = {
	"Reality begins to shimmer and shift.",
	"Colors become more vivid.",
	"You sense interconnectedness.",
}
SHROOMS.cure = {
	"The psilocybin experience fades.",
}
SHROOMS.effect = function(client, char)
	SafeSetHealth(client, client:Health() + 30)
end
SHROOMS.effectC = function(client, char)
	-- No cleanup needed
end

if DISEASES then DISEASES:Register(SHROOMS) end

-- ============ DMT ============
local DMT = {}
DMT.uid = "drug_dmt"
DMT.name = "DMT"
DMT.category = "Drugs"
DMT.duration = 300
DMT.phase = {
	"Your consciousness expands infinitely.",
	"Otherworldly entities surround you.",
	"You enter hyperspace.",
}
DMT.cure = {
	"You return to baseline consciousness.",
}
DMT.effect = function(client, char)
	SafeSetHealth(client, client:Health() + 25)
	SafeSetSpeed(client,
		(nut.config.get("runSpeed") or 285) - 50,
		(nut.config.get("walkSpeed") or 135) - 50
	)
end
DMT.effectC = function(client, char)
	SafeSetSpeed(client,
		nut.config.get("runSpeed") or 285,
		nut.config.get("walkSpeed") or 135
	)
end

if DISEASES then DISEASES:Register(DMT) end

-- ============ AYAHUASCA ============
local AYAHUASCA = {}
AYAHUASCA.uid = "drug_ayahuasca"
AYAHUASCA.name = "Ayahuasca"
AYAHUASCA.category = "Drugs"
AYAHUASCA.duration = 900
AYAHUASCA.phase = {
	"Sacred visions begin to unfold.",
	"You feel a deep spiritual connection.",
	"Pure transcendence and understanding.",
}
AYAHUASCA.cure = {
	"The ayahuasca journey concludes.",
}
AYAHUASCA.effect = function(client, char)
	SafeSetHealth(client, client:Health() + 35)
end
AYAHUASCA.effectC = function(client, char)
	-- No cleanup
end

if DISEASES then DISEASES:Register(AYAHUASCA) end

-- ============ LSD ============
local LSD = {}
LSD.uid = "drug_lsd"
LSD.name = "LSD"
LSD.category = "Drugs"
LSD.duration = 720
LSD.phase = {
	"Surfaces begin to breathe and ripple.",
	"Colors bloom with impossible vibrancy.",
	"Time becomes elastic and strange.",
}
LSD.cure = {
	"Your LSD trip gradually ends.",
}
LSD.effect = function(client, char)
	if client.setLocalVar then
		client:setLocalVar("stm", 100)
	end
end
LSD.effectC = function(client, char)
	-- No cleanup
end

if DISEASES then DISEASES:Register(LSD) end

-- ============ OPIUM ============
local OPIUM = {}
OPIUM.uid = "drug_opium"
OPIUM.name = "Opium"
OPIUM.category = "Drugs"
OPIUM.duration = 540
OPIUM.phase = {
	"You feel your troubles drift away.",
	"A warm blanket of numbness settles.",
	"Everything feels perfect and peaceful.",
}
OPIUM.cure = {
	"The opium high gradually wears off.",
}
OPIUM.effect = function(client, char)
	SafeSetHealth(client, client:Health() + 35)
	SafeSetSpeed(client,
		(nut.config.get("runSpeed") or 285) - 70,
		(nut.config.get("walkSpeed") or 135) - 70
	)
end
OPIUM.effectC = function(client, char)
	SafeSetSpeed(client,
		nut.config.get("runSpeed") or 285,
		nut.config.get("walkSpeed") or 135
	)
end

if DISEASES then DISEASES:Register(OPIUM) end

print("[DRUG EFFECTS] ✅ All drug effects registered and validated")
