-- "gamemodes\\1942rp\\plugins\\drugs\\sh_drugeffects.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PLUGIN = PLUGIN
//
local DISEASE = {}
DISEASE.uid = "cocaine"
DISEASE.name = "Cocaine"
DISEASE.category = "Drugs"
DISEASE.duration = 7200
DISEASE.phase = {
	"You feel light headed.",
	"You feel your every heart beat.",
	"Your pupils dilate."

}
DISEASE.cure = {
	"Your cocaine high slowly goes away.",
}
DISEASE.effect = function(client, char) --use effect
	--damage is delayed, code in sh_plugin
	client:SetRunSpeed( nut.config.get("runSpeed") + 100 )
	client:SetWalkSpeed( nut.config.get("walkSpeed") + 50 )
end
DISEASE.effectC = function(client, char) --cure effect
	client:SetRunSpeed( nut.config.get("runSpeed") )
	client:SetWalkSpeed( nut.config.get("walkSpeed") )
end


--Increased stamina
--Delayed damage
--Jittery (forced movement? Might be too annoying)
--Move faster for sure
--Decreased max stamina

DISEASES:Register( DISEASE )
//
local DISEASE = {}
DISEASE.uid = "cocaine"
DISEASE.name = "Cocaine Withdrawal"
DISEASE.category = "Drugs"
DISEASE.phase = {
	"You could really go for some cocaine right now.",
}
DISEASE.cure = {
	"Your cocaine addiction has subsided.",
}
DISEASE.special = function(client, char)
	if(!char:getData("drug_coca")) then
		client:notify("You are taking damage due to cocaine withdrawal.")
		client:TakeDamage(1, client)
	end
end

DISEASES:Register( DISEASE )
//
local DISEASE = {}
DISEASE.uid = "heroinchemical"
DISEASE.name = "Heroin"
DISEASE.category = "Drugs"
DISEASE.duration = 7200
DISEASE.phase = {
	"You feel your troubles slip away.",
	"Most thoughts leave your mind.",
	"Everything feels as though it's slowed down.",
	"You feel yourself let go.",
	"You feel real heavy.",
	"You feel euphoric."
}
DISEASE.cure = {
	"Your heroin high slowly goes away.",
}
DISEASE.effect = function(client, char) --use effect
	--damage is decreased, code in sh_plugin
	client:SetRunSpeed( nut.config.get("runSpeed") - 50 )
	client:SetWalkSpeed( nut.config.get("walkSpeed") - 50 )
end
DISEASE.effectC = function(client, char) --cure effect
	client:SetRunSpeed( nut.config.get("runSpeed") )
	client:SetWalkSpeed( nut.config.get("walkSpeed") )
end

--Sleepy

DISEASES:Register( DISEASE )
//
local DISEASE = {}
DISEASE.uid = "heroinchemical"
DISEASE.name = "Heroin Withdrawal"
DISEASE.category = "Drugs"
DISEASE.phase = {
	"You could really go for some heroin, like right now, please.",
}
DISEASE.cure = {
	"Your heroin addiction has subsided.",
}
DISEASE.effect = function(client, char) --use effect

end
DISEASE.effectC = function(client, char) --cure effect

end
DISEASE.special = function(client, char)
	if(!char:getData("drug_hero")) then
		client:notify("You are taking damage due to heroin withdrawal.")
		client:TakeDamage(5, client)
	end
end

DISEASES:Register( DISEASE )
//
local DISEASE = {}
DISEASE.uid = "opium"
DISEASE.name = "Opium"
DISEASE.category = "Drugs"
DISEASE.duration = 7200
DISEASE.phase = {
	"You feel pretty hungry, you could go for a snack.",
	"You feel nice and calm, everything is nice.",
	"You feel light headed.",
	"You find it harder to focus.",
	"Dude... Opium.",
}
DISEASE.cure = {
	"Your opium high slowly goes away.",
}
DISEASE.effect = function(client, char) --purges other drugs and withdrawal effects
	--client:addHunger(-50) --makes you hungry
	
	--cures everything, weed fixes everything.
	cureDisease(client, "drug_morp")
	cureDisease(client, "drug_morp_w")
	cureDisease(client, "drug_hero")
	cureDisease(client, "drug_hero_w")
	cureDisease(client, "drug_coca")
	cureDisease(client, "drug_coca_w")
	cureDisease(client, "drug_meth")
	cureDisease(client, "drug_meth_w")
end
DISEASE.effectC = function(client, char) --cure effect

end

DISEASES:Register( DISEASE )
//
local DISEASE = {}
DISEASE.uid = "morphine"
DISEASE.name = "Morphine"
DISEASE.category = "Drugs"
DISEASE.duration = 7200
DISEASE.phase = {
	"You feel your sense of touch weaken.",
	"The pain feels as though it's just slipped away.",
	"You feel loopy.",
	"You feel less coordinated.",
	"Pain subsides."
}
DISEASE.cure = {
	"Your high slowly goes away.",
}
DISEASE.effect = function(client, char) --use effect
	--damage is delayed, code in sh_plugin
	client:SetHealth( math.Clamp(client:Health() + 30, 0, 100) ) --heal for 30
end
DISEASE.effectC = function(client, char) --cure effect

end
--Temporary heal
--Delayed damage
--Have it heal a little

DISEASES:Register( DISEASE )
//
local DISEASE = {}
DISEASE.uid = "morphine"
DISEASE.name = "Morphine Withdrawal"
DISEASE.category = "Drugs"
DISEASE.phase = {
	"You really need some morphine, or heroin, right now.",
}
DISEASE.cure = {
	"Your addiction has subsided.",
}
DISEASE.special = function(client, char)
	if(!char:getData("drug_morp")) then
		client:notify("You are taking damage due to morphine withdrawal.")
		client:TakeDamage(3, client)
	end
end

DISEASES:Register( DISEASE )
//
local DISEASE = {}
DISEASE.uid = "drug_meth"
DISEASE.name = "Meth"
DISEASE.category = "Drugs"
DISEASE.duration = 7200
DISEASE.phase = {
	 "You can feel your teeth.",
	"Your jaw clenches uncontrollably.",
	"You notice a lack of hunger.",
	"Your heart beats uncontrollably."

}
DISEASE.cure = {
	"Your meth high goes away.",
}
DISEASE.effect = function(client, char) --use effect
	--client:addHunger(1000) --loss of apetite
	client:setLocalVar("stm", 100) --replenishes stamina
	--damage is increased, code in sh_plugin
end
DISEASE.effectC = function(client, char) --cure effect

end

--Decreased stamina
--Increased stamina drain

DISEASES:Register( DISEASE )
//
local DISEASE = {}
DISEASE.uid = "drug_meth_w"
DISEASE.name = "Meth Withdrawal"
DISEASE.category = "Drugs"
DISEASE.phase = {
	"You could really go for some meth right now.",
	"You have a strong urge to take meth.",
}
DISEASE.cure = {
	"Your meth addiction has subsided.",
}
DISEASE.special = function(client, char)
	if(!char:getData("drug_meth")) then
		client:notify("You are taking damage due to morphine withdrawal.")
		client:TakeDamage(2, client)
	end
end

DISEASES:Register( DISEASE )
