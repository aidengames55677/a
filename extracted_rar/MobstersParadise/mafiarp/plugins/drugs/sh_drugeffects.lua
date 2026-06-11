-- "gamemodes\\mafiarp\\plugins\\drugs\\sh_drugeffects.lua"
-- Enhanced Drug Effects System with Addiction & Overdose for Mobsters Paradise

local PLUGIN = PLUGIN

-- ============ HELPER FUNCTIONS ============
local function addAddiction(client, drugID, intensity)
	local char = client:getChar()
	if not char then return end
	
	local addictions = char:getData("drugAddictions") or {}
	addictions[drugID] = (addictions[drugID] or 0) + intensity
	addictions[drugID] = math.Clamp(addictions[drugID], 0, 100)
	char:setData("drugAddictions", addictions)
end

local function getAddictionLevel(client, drugID)
	local char = client:getChar()
	if not char then return 0 end
	local addictions = char:getData("drugAddictions") or {}
	return addictions[drugID] or 0
end

local function removeAddiction(client, drugID)
	local char = client:getChar()
	if not char then return end
	local addictions = char:getData("drugAddictions") or {}
	addictions[drugID] = nil
	char:setData("drugAddictions", addictions)
end

local function getWithdrawalDamage(intensity)
	return math.ceil(intensity / 10) -- 0-10 damage based on addiction level
end

-- ============ COCAINE ============
local DISEASE = {}
DISEASE.uid = "drug_cocaine"
DISEASE.name = "Cocaine"
DISEASE.category = "Drugs"
DISEASE.duration = 300
DISEASE.phase = {
	"You feel lightheaded and euphoric.",
	"Your heart races intensely.",
	"Your pupils dilate dramatically.",
	"Every nerve feels alive.",
	"You feel invincible.",
}
DISEASE.cure = {
	"The cocaine high wears off gradually.",
}
DISEASE.effect = function(client, char)
	client:SetRunSpeed(nut.config.get("runSpeed") + 150)
	client:SetWalkSpeed(nut.config.get("walkSpeed") + 100)
	addAddiction(client, "cocaine", 15)
end
DISEASE.effectC = function(client, char)
	client:SetRunSpeed(nut.config.get("runSpeed"))
	client:SetWalkSpeed(nut.config.get("walkSpeed"))
	
	local addiction = getAddictionLevel(client, "cocaine")
	if addiction > 20 then
		client:getChar():setData("withdrawing_cocaine", true)
		client:notify("You're starting to feel the withdrawal...")
	end
end
DISEASES:Register(DISEASE)

-- ============ COCAINE WITHDRAWAL ============
local DISEASE = {}
DISEASE.uid = "drug_cocaine_w"
DISEASE.name = "Cocaine Withdrawal"
DISEASE.category = "Drugs"
DISEASE.duration = 600
DISEASE.phase = {
	"You desperately crave cocaine.",
	"Your body aches.",
	"You feel anxious and depressed.",
	"Your hands shake uncontrollably.",
	"You can barely focus on anything else.",
}
DISEASE.cure = {
	"Your cocaine cravings finally subside.",
}
DISEASE.special = function(client, char)
	local addiction = getAddictionLevel(client, "cocaine")
	if addiction > 0 and not char:getData("drug_cocaine") then
		local damage = getWithdrawalDamage(addiction)
		client:TakeDamage(damage)
		client:notify("Withdrawal damage: "..damage.."HP")
	end
end
DISEASES:Register(DISEASE)

-- ============ CRACK COCAINE ============
local DISEASE = {}
DISEASE.uid = "drug_crack"
DISEASE.name = "Crack Cocaine"
DISEASE.category = "Drugs"
DISEASE.duration = 240
DISEASE.phase = {
	"RUSH! Intense euphoria floods your body!",
	"Your heart pumps like a jackhammer.",
	"Everything feels sharp and vivid.",
	"Pure bliss and energy!",
}
DISEASE.cure = {
	"The intense high crashes down.",
}
DISEASE.effect = function(client, char)
	client:SetRunSpeed(nut.config.get("runSpeed") + 200)
	client:SetWalkSpeed(nut.config.get("walkSpeed") + 150)
	addAddiction(client, "crack", 25) -- Higher addiction potential
	client:SetHealth(math.Clamp(client:Health() + 15, 0, 100))
end
DISEASE.effectC = function(client, char)
	client:SetRunSpeed(nut.config.get("runSpeed"))
	client:SetWalkSpeed(nut.config.get("walkSpeed"))
	
	local addiction = getAddictionLevel(client, "crack")
	if addiction > 30 then
		client:getChar():setData("withdrawing_crack", true)
	end
end
DISEASES:Register(DISEASE)

-- ============ HEROIN ============
local DISEASE = {}
DISEASE.uid = "drug_heroin"
DISEASE.name = "Heroin"
DISEASE.category = "Drugs"
DISEASE.duration = 480
DISEASE.phase = {
	"You feel your troubles slip away.",
	"Warmth spreads through your body.",
	"Everything feels perfect.",
	"You feel really heavy and relaxed.",
	"Pure euphoria and numbness.",
}
DISEASE.cure = {
	"The heroin high gradually fades.",
}
DISEASE.effect = function(client, char)
	client:SetHealth(math.Clamp(client:Health() + 40, 0, 100))
	client:SetRunSpeed(nut.config.get("runSpeed") - 80)
	client:SetWalkSpeed(nut.config.get("walkSpeed") - 80)
	addAddiction(client, "heroin", 20)
end
DISEASE.effectC = function(client, char)
	client:SetRunSpeed(nut.config.get("runSpeed"))
	client:SetWalkSpeed(nut.config.get("walkSpeed"))
	
	local addiction = getAddictionLevel(client, "heroin")
	if addiction > 25 then
		client:getChar():setData("withdrawing_heroin", true)
	end
end
DISEASES:Register(DISEASE)

-- ============ HEROIN WITHDRAWAL ============
local DISEASE = {}
DISEASE.uid = "drug_heroin_w"
DISEASE.name = "Heroin Withdrawal"
DISEASE.category = "Drugs"
DISEASE.duration = 900
DISEASE.phase = {
	"You desperately need heroin.",
	"Your body aches everywhere.",
	"Cold sweats drench your body.",
	"Intense cravings consume your mind.",
	"You feel like you're dying.",
}
DISEASE.cure = {
	"Your heroin addiction finally releases its grip.",
}
DISEASE.special = function(client, char)
	local addiction = getAddictionLevel(client, "heroin")
	if addiction > 0 and not char:getData("drug_heroin") then
		local damage = getWithdrawalDamage(addiction)
		client:TakeDamage(damage)
	end
end
DISEASES:Register(DISEASE)

-- ============ MARIJUANA ============
local DISEASE = {}
DISEASE.uid = "drug_weed"
DISEASE.name = "Marijuana"
DISEASE.category = "Drugs"
DISEASE.duration = 420
DISEASE.phase = {
	"You feel relaxed and calm.",
	"Giggles start to bubble up.",
	"Everything feels funny.",
	"Munchies hitting hard...",
	"Pure zen vibes.",
}
DISEASE.cure = {
	"Your high gradually comes down.",
}
DISEASE.effect = function(client, char)
	addAddiction(client, "weed", 5) -- Low addiction potential
	-- Weed reduces other withdrawal symptoms
	cureDisease(client, "drug_cocaine_w")
	cureDisease(client, "drug_heroin_w")
	cureDisease(client, "drug_meth_w")
end
DISEASE.effectC = function(client, char)
end
DISEASES:Register(DISEASE)

-- ============ METH ============
local DISEASE = {}
DISEASE.uid = "drug_meth"
DISEASE.name = "Methamphetamine"
DISEASE.category = "Drugs"
DISEASE.duration = 540
DISEASE.phase = {
	"Your jaw clenches intensely.",
	"You feel like you can do ANYTHING.",
	"Energy surges through your veins.",
	"Your heart races wildly.",
	"You feel like a god.",
}
DISEASE.cure = {
	"The meth high wears off.",
}
DISEASE.effect = function(client, char)
	client:SetRunSpeed(nut.config.get("runSpeed") + 180)
	client:SetWalkSpeed(nut.config.get("walkSpeed") + 120)
	client:setLocalVar("stm", 100)
	addAddiction(client, "meth", 22)
end
DISEASE.effectC = function(client, char)
	client:SetRunSpeed(nut.config.get("runSpeed"))
	client:SetWalkSpeed(nut.config.get("walkSpeed"))
	
	local addiction = getAddictionLevel(client, "meth")
	if addiction > 25 then
		client:getChar():setData("withdrawing_meth", true)
	end
end
DISEASES:Register(DISEASE)

-- ============ METH WITHDRAWAL ============
local DISEASE = {}
DISEASE.uid = "drug_meth_w"
DISEASE.name = "Meth Withdrawal"
DISEASE.category = "Drugs"
DISEASE.duration = 720
DISEASE.phase = {
	"You desperately need meth.",
	"Your body is wrecked.",
	"Intense depression sets in.",
	"You can't sleep or focus.",
	"This is unbearable.",
}
DISEASE.cure = {
	"Your meth addiction finally releases.",
}
DISEASE.special = function(client, char)
	local addiction = getAddictionLevel(client, "meth")
	if addiction > 0 and not char:getData("drug_meth") then
		local damage = getWithdrawalDamage(addiction)
		client:TakeDamage(damage)
	end
end
DISEASES:Register(DISEASE)

-- ============ MDMA / ECSTASY / MOLLY ============
local DISEASE = {}
DISEASE.uid = "drug_mdma"
DISEASE.name = "MDMA"
DISEASE.category = "Drugs"
DISEASE.duration = 480
DISEASE.phase = {
	"You feel an overwhelming sense of euphoria.",
	"Your jaw clenches with energy.",
	"Love and peace flood your mind.",
	"You feel connected to everything.",
	"Pure happiness and bliss.",
}
DISEASE.cure = {
	"The MDMA high wears off.",
}
DISEASE.effect = function(client, char)
	client:SetRunSpeed(nut.config.get("runSpeed") + 100)
	client:SetWalkSpeed(nut.config.get("walkSpeed") + 50)
	client:setLocalVar("stm", 100)
	addAddiction(client, "mdma", 12)
	cureDisease(client, "drug_heroin_w")
	cureDisease(client, "drug_cocaine_w")
end
DISEASE.effectC = function(client, char)
	client:SetRunSpeed(nut.config.get("runSpeed"))
	client:SetWalkSpeed(nut.config.get("walkSpeed"))
end
DISEASES:Register(DISEASE)

-- ============ PSILOCYBIN MUSHROOMS ============
local DISEASE = {}
DISEASE.uid = "drug_shrooms"
DISEASE.name = "Magic Mushrooms"
DISEASE.category = "Drugs"
DISEASE.duration = 720
DISEASE.phase = {
	"Reality begins to shimmer and shift.",
	"Colors become more vivid and alive.",
	"Time feels strange and fluid.",
	"You sense the interconnectedness of everything.",
	"Visual hallucinations dance before your eyes.",
}
DISEASE.cure = {
	"The psilocybin experience gradually fades.",
}
DISEASE.effect = function(client, char)
	client:SetHealth(math.Clamp(client:Health() + 30, 0, 100))
	addAddiction(client, "shrooms", 3) -- Very low addiction
	-- Cures many withdrawal symptoms
	cureDisease(client, "drug_cocaine_w")
	cureDisease(client, "drug_heroin_w")
	cureDisease(client, "drug_meth_w")
	cureDisease(client, "drug_crack_w")
end
DISEASE.effectC = function(client, char)
end
DISEASES:Register(DISEASE)

-- ============ DMT ============
local DISEASE = {}
DISEASE.uid = "drug_dmt"
DISEASE.name = "DMT"
DISEASE.category = "Drugs"
DISEASE.duration = 300
DISEASE.phase = {
	"Your consciousness expands infinitely.",
	"Otherworldly entities surround you.",
	"You enter hyperspace.",
	"Reality completely dissolves.",
	"You touch the divine.",
}
DISEASE.cure = {
	"You return to baseline consciousness.",
}
DISEASE.effect = function(client, char)
	client:SetHealth(math.Clamp(client:Health() + 25, 0, 100))
	client:SetRunSpeed(nut.config.get("runSpeed") - 50)
	client:SetWalkSpeed(nut.config.get("walkSpeed") - 50)
	addAddiction(client, "dmt", 2) -- Almost no addiction
end
DISEASE.effectC = function(client, char)
	client:SetRunSpeed(nut.config.get("runSpeed"))
	client:SetWalkSpeed(nut.config.get("walkSpeed"))
end
DISEASES:Register(DISEASE)

-- ============ AYAHUASCA ============
local DISEASE = {}
DISEASE.uid = "drug_ayahuasca"
DISEASE.name = "Ayahuasca"
DISEASE.category = "Drugs"
DISEASE.duration = 900
DISEASE.phase = {
	"Sacred visions begin to unfold.",
	"You feel a deep spiritual connection.",
	"Ancestral wisdom speaks to you.",
	"Your soul feels purified and aligned.",
	"Pure transcendence and understanding.",
}
DISEASE.cure = {
	"The ayahuasca journey gently concludes.",
}
DISEASE.effect = function(client, char)
	client:SetHealth(math.Clamp(client:Health() + 35, 0, 100))
	addAddiction(client, "ayahuasca", 1) -- No addiction
	-- Powerful withdrawal cure
	local addictions = char:getData("drugAddictions") or {}
	addictions["cocaine"] = math.max(0, (addictions["cocaine"] or 0) - 20)
	addictions["heroin"] = math.max(0, (addictions["heroin"] or 0) - 20)
	addictions["meth"] = math.max(0, (addictions["meth"] or 0) - 20)
	char:setData("drugAddictions", addictions)
	cureDisease(client, "drug_cocaine_w")
	cureDisease(client, "drug_heroin_w")
	cureDisease(client, "drug_meth_w")
end
DISEASE.effectC = function(client, char)
end
DISEASES:Register(DISEASE)

-- ============ PCP ============
local DISEASE = {}
DISEASE.uid = "drug_pcp"
DISEASE.name = "PCP"
DISEASE.category = "Drugs"
DISEASE.duration = 600
DISEASE.phase = {
	"You feel detached from your body.",
	"You feel unnaturally strong.",
	"Reality feels distorted and dreamlike.",
	"You feel invincible and fearless.",
	"Extreme euphoria and dissociation.",
}
DISEASE.cure = {
	"Your PCP high finally subsides.",
}
DISEASE.effect = function(client, char)
	client:SetRunSpeed(nut.config.get("runSpeed") + 120)
	client:SetWalkSpeed(nut.config.get("walkSpeed") + 80)
	client:SetHealth(math.Clamp(client:Health() + 20, 0, 100))
	addAddiction(client, "pcp", 18)
end
DISEASE.effectC = function(client, char)
	client:SetRunSpeed(nut.config.get("runSpeed"))
	client:SetWalkSpeed(nut.config.get("walkSpeed"))
	
	local addiction = getAddictionLevel(client, "pcp")
	if addiction > 20 then
		client:getChar():setData("withdrawing_pcp", true)
	end
end
DISEASES:Register(DISEASE)

-- ============ KETAMINE ============
local DISEASE = {}
DISEASE.uid = "drug_ketamine"
DISEASE.name = "Ketamine"
DISEASE.category = "Drugs"
DISEASE.duration = 360
DISEASE.phase = {
	"You feel your body becoming lighter.",
	"You enter a dissociative state.",
	"Everything feels dreamlike and ethereal.",
	"You're floating in a void.",
	"Pure dissociation and numbness.",
}
DISEASE.cure = {
	"You gradually return to baseline.",
}
DISEASE.effect = function(client, char)
	client:SetHealth(math.Clamp(client:Health() + 20, 0, 100))
	client:SetRunSpeed(nut.config.get("runSpeed") - 60)
	client:SetWalkSpeed(nut.config.get("walkSpeed") - 60)
	addAddiction(client, "ketamine", 8)
end
DISEASE.effectC = function(client, char)
	client:SetRunSpeed(nut.config.get("runSpeed"))
	client:SetWalkSpeed(nut.config.get("walkSpeed"))
end
DISEASES:Register(DISEASE)

-- ============ OPIUM ============
local DISEASE = {}
DISEASE.uid = "drug_opium"
DISEASE.name = "Opium"
DISEASE.category = "Drugs"
DISEASE.duration = 540
DISEASE.phase = {
	"You feel your troubles drift away.",
	"A warm blanket of numbness settles over you.",
	"You feel deeply relaxed.",
	"Everything feels perfect and peaceful.",
	"Pure euphoria and peace.",
}
DISEASE.cure = {
	"The opium high gradually wears off.",
}
DISEASE.effect = function(client, char)
	client:SetHealth(math.Clamp(client:Health() + 35, 0, 100))
	client:SetRunSpeed(nut.config.get("runSpeed") - 70)
	client:SetWalkSpeed(nut.config.get("walkSpeed") - 70)
	addAddiction(client, "opium", 18)
end
DISEASE.effectC = function(client, char)
	client:SetRunSpeed(nut.config.get("runSpeed"))
	client:SetWalkSpeed(nut.config.get("walkSpeed"))
	
	local addiction = getAddictionLevel(client, "opium")
	if addiction > 20 then
		client:getChar():setData("withdrawing_opium", true)
	end
end
DISEASES:Register(DISEASE)

-- ============ LSD ============
local DISEASE = {}
DISEASE.uid = "drug_lsd"
DISEASE.name = "LSD"
DISEASE.category = "Drugs"
DISEASE.duration = 720
DISEASE.phase = {
	"Surfaces begin to breathe and ripple.",
	"Colors bloom with impossible vibrancy.",
	"Time becomes elastic and strange.",
	"You feel profoundly connected to the universe.",
	"Fractal patterns and cosmic visions.",
}
DISEASE.cure = {
	"Your LSD trip gradually comes to an end.",
}
DISEASE.effect = function(client, char)
	client:setLocalVar("stm", 100)
	addAddiction(client, "lsd", 4) -- Very low addiction
	-- LSD cures many withdrawal states
	cureDisease(client, "drug_cocaine_w")
	cureDisease(client, "drug_heroin_w")
	cureDisease(client, "drug_meth_w")
	cureDisease(client, "drug_crack_w")
end
DISEASE.effectC = function(client, char)
end
DISEASES:Register(DISEASE)

print("[Mobsters Paradise] Enhanced drug effects loaded!")
