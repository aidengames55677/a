ITEM.name = "Drug Manufacturing Station"
ITEM.desc = "A sophisticated lab setup for cooking, processing, and refining illegal narcotics. WARNING: Highly dangerous."
ITEM.model = "models/props_wasteland/laundry_basket001.mdl"
ITEM.width = 3
ITEM.height = 3
ITEM.price = 8000
ITEM.category = "Drugs"
ITEM.color = Color(50, 255, 50)
ITEM.requiresElectricity = true
ITEM.requiresVentilation = true

-- ============ DRUG PRODUCTION RECIPES ============
ITEM.recipes = {
	-- Crack Cocaine Production (requires cocaine + baking soda)
	["crack"] = {
		name = "Cook Crack Cocaine",
		inputs = {
			{item = "cocaine", amount = 1},
			{item = "baking_soda", amount = 3},
			{item = "water_jug", amount = 1},
		},
		output = {item = "drug_crack", amount = 10},
		processTime = nut.config.get("crackProductionTime") or 180,
		difficulty = 3, -- 1-5 scale
		dangerLevel = 4, -- Risk of explosion/fire
		requires = {flag = "D", skill = "drugCooking"},
		description = "Converts powder cocaine into crack rocks. Requires extreme care.",
	},
	
	-- DMT Extraction
	["dmt"] = {
		name = "Extract DMT",
		inputs = {
			{item = "acacia_bark", amount = 5},
			{item = "citric_acid", amount = 2},
			{item = "sodium_hydroxide", amount = 2},
			{item = "naphtha", amount = 3},
		},
		output = {item = "drug_dmt", amount = 5},
		processTime = nut.config.get("dmt_productionTime") or 240,
		difficulty = 4,
		dangerLevel = 5, -- HIGHLY TOXIC
		requires = {flag = "D", skill = "chemistry"},
		description = "Complex extraction requiring dangerous chemicals and precise timing.",
	},
	
	-- PCP Production
	["pcp"] = {
		name = "Synthesize PCP",
		inputs = {
			{item = "aniline", amount = 2},
			{item = "cyclohexanone", amount = 2},
			{item = "sodium_cyanide", amount = 1},
			{item = "camp_stove", amount = 1}, -- Consumed
		},
		output = {item = "drug_pcp", amount = 8},
		processTime = 300,
		difficulty = 5,
		dangerLevel = 5, -- EXTREME: Cyanide involved
		requires = {flag = "D", skill = "chemistry"},
		description = "Dangerous synthesis with toxic precursors. High risk of explosion.",
	},
	
	-- Ketamine Production
	["ketamine"] = {
		name = "Produce Ketamine",
		inputs = {
			{item = "aniline", amount = 1},
			{item = "phenylmagnesium_bromide", amount = 2},
			{item = "citric_acid", amount = 1},
		},
		output = {item = "drug_ketamine", amount = 12},
		processTime = 240,
		difficulty = 4,
		dangerLevel = 3,
		requires = {flag = "D", skill = "chemistry"},
		description = "Grignard reaction requiring precise temperature control.",
	},
	
	-- MDMA/Molly Production
	["mdma"] = {
		name = "Synthesize MDMA",
		inputs = {
			{item = "safrole", amount = 3},
			{item = "hydrogen_peroxide", amount = 2},
			{item = "methylamine_hcl", amount = 2},
		},
		output = {item = "drug_molly", amount = 20},
		processTime = 360,
		difficulty = 4,
		dangerLevel = 4,
		requires = {flag = "D", skill = "chemistry"},
		description = "Multi-step synthesis. Requires patience and precision.",
	},
	
	-- Heroin Refining
	["heroin"] = {
		name = "Refine Heroin",
		inputs = {
			{item = "morphine", amount = 5},
			{item = "acetic_anhydride", amount = 3},
			{item = "sodium_carbonate", amount = 2},
		},
		output = {item = "drug_heroin", amount = 10},
		processTime = 300,
		difficulty = 3,
		dangerLevel = 3,
		requires = {flag = "D"},
		description = "Acetylation of morphine. Highly addictive product.",
	},
	
	-- Methamphetamine Production
	["meth"] = {
		name = "Cook Methamphetamine",
		inputs = {
			{item = "pseudoephedrine", amount = 5},
			{item = "red_phosphorus", amount = 2},
			{item = "hydriodic_acid", amount = 3},
			{item = "camp_stove", amount = 1},
		},
		output = {item = "drug_meth", amount = 15},
		processTime = 420,
		difficulty = 4,
		dangerLevel = 5, -- HIGHLY EXPLOSIVE
		requires = {flag = "D", skill = "drugCooking"},
		description = "Dangerous reaction. One mistake causes explosion. High heat required.",
	},
	
	-- LSD Production
	["lsd"] = {
		name = "Synthesize LSD",
		inputs = {
			{item = "lysergic_acid", amount = 1},
			{item = "diethylamine", amount = 2},
			{item = "dccd", amount = 2},
		},
		output = {item = "drug_lsd", amount = 100}, -- Very potent in small amounts
		processTime = 300,
		difficulty = 5,
		dangerLevel = 2, -- Not physically dangerous, but technically complex
		requires = {flag = "D", skill = "chemistry"},
		description = "Most chemically complex synthesis. Requires advanced knowledge.",
	},
}

-- ============ PRODUCTION SYSTEM ============
ITEM.functions.StartProduction = {
	name = "Begin Production",
	icon = "icon16/cog.png",
	sound = "buttons/lightswitch2.wav",
	onRun = function(item)
		local client = item.player
		local inventory = client:getChar():getInv()
		
		if not IsValid(item.entity) then
			client:notify("The manufacturing station must be on the ground.")
			return false
		end
		
		if item.entity:WaterLevel() > 1 then
			client:notify("Equipment must be kept dry!")
			return false
		end
		
		-- Prevent multiple simultaneous operations
		local steam64 = client:SteamID64()
		KTDrugCounter[steam64] = KTDrugCounter[steam64] or {}
		KTDrugCounter[steam64].labs = KTDrugCounter[steam64].labs or {}
		
		local activeCount = 0
		for k, v in pairs(KTDrugCounter[steam64].labs) do
			if IsValid(v) and nut.item.instances[v.id] and nut.item.instances[v.id] == v then
				activeCount = activeCount + 1
			else
				KTDrugCounter[steam64].labs[k] = nil
			end
		end
		
		if activeCount >= 2 then
			client:notify("You can only operate 2 stations simultaneously. You're at max capacity.")
			return false
		end
		
		-- Show production menu
		-- In a real implementation, this would open a custom menu
		-- For now, we'll show available recipes
		client:notify("Production recipes available. Choose one:")
		for recipe, data in pairs(ITEM.recipes) do
			client:notify("- "..data.name.." (Difficulty: "..data.difficulty.."/5, Danger: "..data.dangerLevel.."/5)")
		end
		
		return false
	end,
	onCanRun = function(item)
		if not IsValid(item.entity) then
			return false
		end
		
		if item.entity:WaterLevel() > 1 then
			return false
		end
		
		return not item:getData("isProducing")
	end
}

-- ============ ADVANCED FEATURES ============
ITEM.functions.SafetyCheck = {
	name = "Check Safety Systems",
	icon = "icon16/heart.png",
	onRun = function(item)
		local client = item.player
		
		if not IsValid(item.entity) then
			client:notify("Cannot check systems on an item in inventory.")
			return false
		end
		
		local ventilation = item:getData("ventilation") or 0
		local electricity = item:getData("electricity") or 0
		local cleanliness = item:getData("cleanliness") or 100
		
		client:notify("=== SYSTEM STATUS ===")
		client:notify("Ventilation: "..ventilation.."%")
		client:notify("Power: "..(electricity > 0 and "STABLE" or "OFFLINE").."")
		client:notify("Cleanliness: "..cleanliness.."%")
		
		if ventilation < 50 then
			client:notify("⚠️ WARNING: Poor ventilation - toxic fumes building up!")
		end
		
		if cleanliness < 30 then
			client:notify("⚠️ WARNING: Equipment contaminated - risk of bad batch!")
		end
		
		return false
	end,
	onCanRun = function(item)
		return IsValid(item.entity)
	end
}

-- ============ EXPLOSION SYSTEM ============
function ITEM:onRemoved()
	if self:getData("isProducing") then
		-- Lab explosion if removed while active
		if IsValid(self.entity) then
			local pos = self.entity:GetPos()
			
			if SERVER then
				local explosion = ents.Create("env_explosion")
				explosion:SetPos(pos)
				explosion:SetKeyValue("iMagnitude", "200")
				explosion:Spawn()
				
				-- Damage nearby players
				local ents_in_range = ents.FindInSphere(pos, 500)
				for _, ent in ipairs(ents_in_range) do
					if ent:IsPlayer() then
						ent:TakeDamage(50)
					end
				end
				
				-- Fire
				local fire = ents.Create("env_fire")
				fire:SetPos(pos)
				fire:Spawn()
				
				print("[EXPLOSION] Drug lab explosion at "..tostring(pos))
			end
		end
	end
	
	local item = self
	if item.lastUser and KTDrugCounter[item.lastUser] and KTDrugCounter[item.lastUser].labs then
		for k, v in pairs(KTDrugCounter[item.lastUser].labs) do
			if v == self then
				KTDrugCounter[item.lastUser].labs[k] = nil
				break
			end
		end
	end
end

function ITEM:getDesc()
	local desc = self.desc
	
	if self:getData("isProducing") then
		local recipe = self:getData("currentRecipe")
		local timeRemaining = (self:getData("productionEnd") or 0) - CurTime()
		
		if timeRemaining > 0 then
			desc = desc .. "\n\n⚠️ CURRENTLY PRODUCING: "..recipe
			desc = desc .. "\nTime remaining: "..math.ceil(timeRemaining).." seconds"
		end
	end
	
	local danger = self:getData("dangerLevel") or 0
	if danger > 3 then
		desc = desc .. "\n\n🔴 HIGH DANGER - Explosion risk!"
	end
	
	return Format(desc)
end

print("[Mobsters Paradise] Enhanced drug lab loaded!")
