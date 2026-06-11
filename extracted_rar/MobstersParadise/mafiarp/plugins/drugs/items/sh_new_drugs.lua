-- "gamemodes\\mafiarp\\plugins\\drugs\\items\\sh_new_drugs.lua"
-- New drug items for Mobsters Paradise

-- ============ CRACK COCAINE ============
local CRACK = {}
CRACK.name = "Crack Cocaine Rock"
CRACK.desc = "A small, potent rock of crack cocaine. Highly addictive and dangerous."
CRACK.model = "models/props_junk/watermelon01.mdl"
CRACK.width = 1
CRACK.height = 1
CRACK.price = 150
CRACK.category = "Drugs"
CRACK.color = Color(200, 200, 200)
CRACK.useSound = "items/medshot4.wav"

CRACK.functions.use = {
	name = "Use Crack",
	icon = "icon16/cross.png",
	onRun = function(item)
		local client = item.player
		local char = client:getChar()
		
		-- Remove the item
		item:remove()
		
		-- Apply disease
		applyDisease(client, "drug_crack")
		
		-- Notify
		client:notify("You smoke the crack cocaine...")
		client:EmitSound("items/medshot4.wav")
		
		-- Slight damage from smoking it
		client:TakeDamage(3)
		
		nut.log.add(client, "usedDrug", "Crack Cocaine")
		return true
	end,
	onCanRun = function(item)
		return true
	end
}

nut.item.register(CRACK, "drug_crack")

-- ============ DMT ============
local DMT = {}
DMT.name = "DMT Crystals"
DMT.desc = "Crystalline N,N-Dimethyltryptamine. An intense, short-lasting psychedelic."
DMT.model = "models/props_lab/jar01a.mdl"
DMT.width = 1
DMT.height = 1
DMT.price = 200
DMT.category = "Drugs"
DMT.color = Color(150, 100, 150)
DMT.useSound = "items/medshot4.wav"

DMT.functions.use = {
	name = "Smoke DMT",
	icon = "icon16/cross.png",
	onRun = function(item)
		local client = item.player
		local char = client:getChar()
		
		item:remove()
		applyDisease(client, "drug_dmt")
		
		client:notify("You smoke the DMT crystals...")
		client:EmitSound("items/medshot4.wav")
		
		nut.log.add(client, "usedDrug", "DMT")
		return true
	end,
	onCanRun = function(item)
		return true
	end
}

nut.item.register(DMT, "drug_dmt")

-- ============ PCP ============
local PCP = {}
PCP.name = "PCP Powder"
PCP.desc = "Phencyclidine. A dangerous dissociative drug that induces superhuman strength."
PCP.model = "models/props_junk/garbage_bag001a.mdl"
PCP.width = 1
PCP.height = 1
PCP.price = 100
PCP.category = "Drugs"
PCP.color = Color(200, 150, 150)
PCP.useSound = "items/medshot4.wav"

PCP.functions.use = {
	name = "Use PCP",
	icon = "icon16/cross.png",
	onRun = function(item)
		local client = item.player
		local char = client:getChar()
		
		item:remove()
		applyDisease(client, "drug_pcp")
		
		client:notify("You consume the PCP...")
		client:EmitSound("items/medshot4.wav")
		
		nut.log.add(client, "usedDrug", "PCP")
		return true
	end,
	onCanRun = function(item)
		return true
	end
}

nut.item.register(PCP, "drug_pcp")

-- ============ KETAMINE ============
local KETAMINE = {}
KETAMINE.name = "Ketamine"
KETAMINE.desc = "A powerful dissociative anesthetic. Creates a dreamlike, out-of-body experience."
KETAMINE.model = "models/props_junk/garbage_bag001a.mdl"
KETAMINE.width = 1
KETAMINE.height = 1
KETAMINE.price = 120
KETAMINE.category = "Drugs"
KETAMINE.color = Color(200, 200, 150)
KETAMINE.useSound = "items/medshot4.wav"

KETAMINE.functions.use = {
	name = "Use Ketamine",
	icon = "icon16/cross.png",
	onRun = function(item)
		local client = item.player
		local char = client:getChar()
		
		item:remove()
		applyDisease(client, "drug_ketamine")
		
		client:notify("You consume the Ketamine...")
		client:EmitSound("items/medshot4.wav")
		
		nut.log.add(client, "usedDrug", "Ketamine")
		return true
	end,
	onCanRun = function(item)
		return true
	end
}

nut.item.register(KETAMINE, "drug_ketamine")

-- ============ AYAHUASCA ============
local AYAHUASCA = {}
AYAHUASCA.name = "Ayahuasca Brew"
AYAHUASCA.desc = "A powerful plant medicine from the Amazon. Induces profound spiritual experiences and healing."
AYAHUASCA.model = "models/props_junk/garbage_plasticbottle001a.mdl"
AYAHUASCA.width = 2
AYAHUASCA.height = 2
AYAHUASCA.price = 300
AYAHUASCA.category = "Drugs"
AYAHUASCA.color = Color(100, 150, 100)
AYAHUASCA.useSound = "items/medshot4.wav"

AYAHUASCA.functions.use = {
	name = "Drink Ayahuasca",
	icon = "icon16/cross.png",
	onRun = function(item)
		local client = item.player
		local char = client:getChar()
		
		item:remove()
		applyDisease(client, "drug_ayahuasca")
		
		client:notify("You drink the sacred brew...")
		client:EmitSound("items/medshot4.wav")
		
		nut.log.add(client, "usedDrug", "Ayahuasca")
		return true
	end,
	onCanRun = function(item)
		return true
	end
}

nut.item.register(AYAHUASCA, "drug_ayahuasca")

-- ============ MOLLY / ECSTASY (MDMA variant) ============
local MOLLY = {}
MOLLY.name = "Molly"
MOLLY.desc = "Pure MDMA crystals. Powerful empathogenic properties."
MOLLY.model = "models/props_lab/jar01a.mdl"
MOLLY.width = 1
MOLLY.height = 1
MOLLY.price = 80
MOLLY.category = "Drugs"
MOLLY.color = Color(200, 100, 200)
MOLLY.useSound = "items/medshot4.wav"

MOLLY.functions.use = {
	name = "Take Molly",
	icon = "icon16/cross.png",
	onRun = function(item)
		local client = item.player
		local char = client:getChar()
		
		item:remove()
		applyDisease(client, "drug_mdma")
		
		client:notify("You take the Molly...")
		client:EmitSound("items/medshot4.wav")
		
		nut.log.add(client, "usedDrug", "Molly")
		return true
	end,
	onCanRun = function(item)
		return true
	end
}

nut.item.register(MOLLY, "drug_molly")

-- ============ BULK DRUG ITEMS FOR PRODUCTION ============

-- Bulk Crack
local BULK_CRACK = {}
BULK_CRACK.name = "Bulk Crack Cocaine"
BULK_CRACK.desc = "Raw crack cocaine ready for processing."
BULK_CRACK.model = "models/props_junk/cardboard_box001a.mdl"
BULK_CRACK.width = 2
BULK_CRACK.height = 2
BULK_CRACK.category = "Drugs"
BULK_CRACK.color = Color(200, 200, 200)
nut.item.register(BULK_CRACK, "bulk_crack")

-- Bulk DMT
local BULK_DMT = {}
BULK_DMT.name = "Bulk DMT Extract"
BULK_DMT.desc = "Raw DMT ready for crystallization."
BULK_DMT.model = "models/props_junk/cardboard_box001a.mdl"
BULK_DMT.width = 2
BULK_DMT.height = 2
BULK_DMT.category = "Drugs"
BULK_DMT.color = Color(150, 100, 150)
nut.item.register(BULK_DMT, "bulk_dmt")

-- Bulk PCP
local BULK_PCP = {}
BULK_PCP.name = "Bulk PCP"
BULK_PCP.desc = "Raw PCP ready for processing."
BULK_PCP.model = "models/props_junk/cardboard_box001a.mdl"
BULK_PCP.width = 2
BULK_PCP.height = 2
BULK_PCP.category = "Drugs"
BULK_PCP.color = Color(200, 150, 150)
nut.item.register(BULK_PCP, "bulk_pcp")

-- Bulk Ketamine
local BULK_KETAMINE = {}
BULK_KETAMINE.name = "Bulk Ketamine"
BULK_KETAMINE.desc = "Raw Ketamine ready for processing."
BULK_KETAMINE.model = "models/props_junk/cardboard_box001a.mdl"
BULK_KETAMINE.width = 2
BULK_KETAMINE.height = 2
BULK_KETAMINE.category = "Drugs"
BULK_KETAMINE.color = Color(200, 200, 150)
nut.item.register(BULK_KETAMINE, "bulk_ketamine")

-- Bulk Ayahuasca
local BULK_AYAHUASCA = {}
BULK_AYAHUASCA.name = "Bulk Ayahuasca Plants"
BULK_AYAHUASCA.desc = "Raw plant material for brewing."
BULK_AYAHUASCA.model = "models/props_junk/cardboard_box001a.mdl"
BULK_AYAHUASCA.width = 2
BULK_AYAHUASCA.height = 2
BULK_AYAHUASCA.category = "Drugs"
BULK_AYAHUASCA.color = Color(100, 150, 100)
nut.item.register(BULK_AYAHUASCA, "bulk_ayahuasca")

-- ============ PRODUCTION ITEMS ============

-- Precursor chemicals for crack production
local BAKING_SODA_ENHANCED = {}
BAKING_SODA_ENHANCED.name = "Baking Soda"
BAKING_SODA_ENHANCED.desc = "Used in crack cocaine production."
BAKING_SODA_ENHANCED.model = "models/props_junk/garbage_bag001a.mdl"
BAKING_SODA_ENHANCED.width = 1
BAKING_SODA_ENHANCED.height = 1
BAKING_SODA_ENHANCED.price = 25
BAKING_SODA_ENHANCED.category = "Drugs"
nut.item.register(BAKING_SODA_ENHANCED, "baking_soda")

-- Citric Acid
local CITRIC_ACID = {}
CITRIC_ACID.name = "Citric Acid"
CITRIC_ACID.desc = "Chemical precursor used in various drug syntheses."
CITRIC_ACID.model = "models/props_junk/garbage_plasticbottle001a.mdl"
CITRIC_ACID.width = 1
CITRIC_ACID.height = 1
CITRIC_ACID.price = 40
CITRIC_ACID.category = "Drugs"
nut.item.register(CITRIC_ACID, "citric_acid")

-- Sodium Hydroxide
local SODIUM_HYDROXIDE = {}
SODIUM_HYDROXIDE.name = "Sodium Hydroxide"
SODIUM_HYDROXIDE.desc = "Caustic chemical used in drug production."
SODIUM_HYDROXIDE.model = "models/props_junk/garbage_plasticbottle002a.mdl"
SODIUM_HYDROXIDE.width = 1
SODIUM_HYDROXIDE.height = 1
SODIUM_HYDROXIDE.price = 50
SODIUM_HYDROXIDE.category = "Drugs"
nut.item.register(SODIUM_HYDROXIDE, "sodium_hydroxide")

-- Heat source
local CAMP_STOVE = {}
CAMP_STOVE.name = "Portable Burner"
CAMP_STOVE.desc = "For heating solutions during drug production."
CAMP_STOVE.model = "models/props_junk/wood_pile02a.mdl"
CAMP_STOVE.width = 2
CAMP_STOVE.height = 2
CAMP_STOVE.price = 200
CAMP_STOVE.category = "Drugs"
nut.item.register(CAMP_STOVE, "camp_stove")

print("[Mobsters Paradise] New drug items loaded!")
