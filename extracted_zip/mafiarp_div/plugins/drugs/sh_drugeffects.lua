-- "gamemodes\\mafiarp\\plugins\\drugs\\sh_drugeffects.lua"

local PLUGIN = PLUGIN
//
local DISEASE = {}
DISEASE.uid = "drug_coca"
DISEASE.name = "Cocaine"
DISEASE.category = "Drugs"
DISEASE.duration = 360
DISEASE.phase = {
	"You feel lightheaded.",
	"You feel your every heartbeat.",
	"Your pupils dilate."

}
DISEASE.cure = {
	"You slowly come down from your cocaine high.",
}
DISEASE.effect = function(client, char) --use effect
	--damage is delayed, code in sv_plugin
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
DISEASE.uid = "drug_coca_w"
DISEASE.name = "Cocaine Withdrawal"
DISEASE.category = "Drugs"
DISEASE.phase = {
	"You really need some cocaine right now.",
}
DISEASE.cure = {
	"Your cocaine addiction has subsided.",
}
DISEASE.special = function(client, char)
	if(!client:getChar():getData("drug_coca")) then
		client:notify("You are taking damage due to cocaine withdrawal.")
		client:TakeDamage(1, client)
	end
end

DISEASES:Register( DISEASE )
//
local DISEASE = {}
DISEASE.uid = "drug_hero"
DISEASE.name = "Heroin"
DISEASE.category = "Drugs"
DISEASE.duration = 540
DISEASE.phase = {
	"You feel your troubles slip away.",
	"Most thoughts leave your mind.",
	"Everything feels as though it's slowed down.",
	"You feel yourself letting go.",
	"You feel really heavy.",
	"You feel euphoric."
}
DISEASE.cure = {
	"You slowly come down from your heroin high.",
}
DISEASE.effect = function(client, char) --use effect
	--damage is decreased, code in sv_plugin
	client:SetHealth( math.Clamp(client:Health() + 30, 0, 100) ) --heal for 30
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
DISEASE.uid = "drug_hero_w"
DISEASE.name = "Heroin Withdrawal"
DISEASE.category = "Drugs"
DISEASE.phase = {
	"You really need some heroin right now.",
}
DISEASE.cure = {
	"Your heroin addiction has subsided.",
}
DISEASE.effect = function(client, char) --use effect

end
DISEASE.effectC = function(client, char) --cure effect

end
DISEASE.special = function(client)
	if(!client:getChar():getData("drug_hero")) then
		client:notify("You are taking damage due to heroin withdrawal.")
		client:TakeDamage(5, client)
	end
end

DISEASES:Register( DISEASE )
//
local DISEASE = {}
DISEASE.uid = "drug_weed"
DISEASE.name = "Weed"
DISEASE.category = "Drugs"
DISEASE.duration = 540
DISEASE.phase = {
	"You feel pretty hungry, you could go for a snack.",
	"You feel nice and calm, everything is relaxed.",
	"You feel lightheaded.",
	"You find it harder to focus.",
	"Dude... weed.",
}
DISEASE.cure = {
	"You slowly come down from your weed high.",
}
DISEASE.effect = function(client, char) --purges some other drugs and withdrawal effects
	--client:addHunger(-50) --makes you hungry

	cureDisease(client, "drug_morp")
	cureDisease(client, "drug_morp_w")
	cureDisease(client, "drug_hero")
	cureDisease(client, "drug_hero_w")
	cureDisease(client, "drug_meth")
	cureDisease(client, "drug_meth_w")
	cureDisease(client, "drug_opium")
	cureDisease(client, "drug_opium_w")
end
DISEASE.effectC = function(client, char) --cure effect

end

DISEASES:Register( DISEASE )
//
local DISEASE = {}
DISEASE.uid = "drug_morp"
DISEASE.name = "Methaqualone"
DISEASE.category = "Drugs"
DISEASE.duration = 540
DISEASE.phase = {
	"You feel your sense of touch weaken.",
	"The pain feels as though it's just slipped away.",
	"You feel loopy.",
	"You feel less coordinated.",
	"Your pain subsides."
}
DISEASE.cure = {
	"You slowly come down from your methaqualone high.",
}
DISEASE.effect = function(client, char) --use effect
	--damage is delayed, code in sv_plugin
	client:SetHealth( math.Clamp(client:Health() + 20, 0, 100) ) --heal for 20
end
DISEASE.effectC = function(client, char) --cure effect

end
--Temporary heal
--Delayed damage
--Have it heal a little

DISEASES:Register( DISEASE )
//
local DISEASE = {}
DISEASE.uid = "drug_morp_w"
DISEASE.name = "Methaqualone Withdrawal"
DISEASE.category = "Drugs"
DISEASE.phase = {
	"You really need some methaqualone right now.",
}
DISEASE.cure = {
	"Your methaqualone addiction has subsided.",
}
DISEASE.special = function(client, char)
	if(!client:getChar():getData("drug_morp")) then
		client:notify("You are taking damage due to methaqualone withdrawal.")
		client:TakeDamage(3, client)
	end
end

DISEASES:Register( DISEASE )
//
local DISEASE = {}
DISEASE.uid = "drug_meth"
DISEASE.name = "Meth"
DISEASE.category = "Drugs"
DISEASE.duration = 540
DISEASE.phase = {
	"You can feel your teeth pressing together.",
	"Your jaw clenches uncontrollably.",
	"You notice a lack of hunger.",
	"Your heart beats uncontrollably."

}
DISEASE.cure = {
	"You slowly come down from your meth high.",
}
DISEASE.effect = function(client, char) --use effect
	--client:addHunger(1000) --loss of apetite
	client:setLocalVar("stm", 100) --replenishes stamina
	--damage is increased, code in sv_plugin
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
	"You really need some meth right now.",
	"You have a strong urge to do meth.",
}
DISEASE.cure = {
	"Your meth addiction has subsided.",
}
DISEASE.special = function(client, char)
	if(!client:getChar():getData("drug_meth")) then
		client:notify("You are taking damage due to meth withdrawal.")
		client:TakeDamage(2, client)
	end
end

DISEASES:Register( DISEASE )
//
local DISEASE = {}
DISEASE.uid = "drug_opium"
DISEASE.name = "Opium"
DISEASE.category = "Drugs"
DISEASE.duration = 540
DISEASE.phase = {
	"You feel your troubles slip away.",
	"Most thoughts leave your mind.",
	"Everything feels as though it's slowed down.",
	"You feel yourself letting go.",
	"You feel really heavy.",
	"You feel euphoric."
}
DISEASE.cure = {
	"You slowly come down from your opium high.",
}
DISEASE.effect = function(client, char) --use effect
	--damage is decreased, code in sv_plugin
	client:SetHealth( math.Clamp(client:Health() + 25, 0, 100) ) --heal for 25
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
DISEASE.uid = "drug_opium_w"
DISEASE.name = "Opium Withdrawal"
DISEASE.category = "Drugs"
DISEASE.phase = {
	"You really need some opium right now.",
}
DISEASE.cure = {
	"Your opium addiction has subsided.",
}
DISEASE.effect = function(client, char) --use effect

end
DISEASE.effectC = function(client, char) --cure effect

end
DISEASE.special = function(client)
	if(!client:getChar():getData("drug_hero")) then
		client:notify("You are taking damage due to opium withdrawal.")
		client:TakeDamage(5, client)
	end
end

DISEASES:Register( DISEASE )
//
local DISEASE = {}
DISEASE.uid = "drug_lsd"
DISEASE.name = "LSD"
DISEASE.category = "Drugs"
DISEASE.duration = 720
DISEASE.phase = {
	"Reality distorts itself, surfaces seem to be breathing.",
	"You feel content, nothing troubles you.",
	"You feel a rush of inner energy.",
	"You feel your body heating up.",
	"You close your eyes, and see unreal fractal shapes.",
	"Bro... swirling colors.",
}
DISEASE.cure = {
	"You slowly come down from your LSD high.",
}
DISEASE.effect = function(client, char) --purges some other drugs and withdrawal effects
	--client:addHunger(-50) --makes you hungry
	client:setLocalVar("stm", 100) --replenishes stamina
	cureDisease(client, "drug_morp")
	cureDisease(client, "drug_morp_w")
	cureDisease(client, "drug_hero")
	cureDisease(client, "drug_hero_w")
	cureDisease(client, "drug_coca")
	cureDisease(client, "drug_coca_w")
	cureDisease(client, "drug_meth")
	cureDisease(client, "drug_meth_w")
	cureDisease(client, "drug_opium")
	cureDisease(client, "drug_opium_w")
end
DISEASE.effectC = function(client, char) --cure effect

end

DISEASES:Register( DISEASE )
//
local DISEASE = {}
DISEASE.uid = "drug_mdma"
DISEASE.name = "MDMA"
DISEASE.category = "Drugs"
DISEASE.duration = 540
DISEASE.phase = {
	"You feel a great urge to run around and dance.",
	"You can feel your teeth pressing together.",
	"Your jaw clenches.",
	"You feel a rush of energy.",
	"You feel your body heating up.",
	"You notice a lack of hunger",
	"Your heart beats faster.",
	"Bro... I feel so happy.",
}
DISEASE.cure = {
	"You slowly come down from your MDMA high.",
}
DISEASE.effect = function(client, char) --purges some other drugs and withdrawal effects
	--client:addHunger(-50) --makes you hungry
	client:setLocalVar("stm", 100) --replenishes stamina
	cureDisease(client, "drug_morp")
	cureDisease(client, "drug_morp_w")
	cureDisease(client, "drug_hero")
	cureDisease(client, "drug_hero_w")
	cureDisease(client, "drug_opium")
	cureDisease(client, "drug_opium_w")
end
DISEASE.effectC = function(client, char) --cure effect

end

DISEASES:Register( DISEASE )
//
local DISEASE = {}
DISEASE.uid = "drug_shrooms"
DISEASE.name = "Magic Mushrooms"
DISEASE.category = "Drugs"
DISEASE.duration = 720
DISEASE.phase = {
	"You become aware of the complexity of reality.",
	"You feel happy and giggly.",
	"You talk to the tree, and the tree talks back to you.",
	"You feel your body buzzing.",
	"You see strange and interesting shapes in everything around you.",
}
DISEASE.cure = {
	"You slowly come down from your magic mushroom high.",
}
DISEASE.effect = function(client, char) --purges some other drugs and withdrawal effects
	--client:addHunger(-50) --makes you hungry
	client:SetHealth( math.Clamp(client:Health() + 40, 0, 100) ) --heal for 40
	--client:setLocalVar("stm", 100) --replenishes stamina
	cureDisease(client, "drug_morp")
	cureDisease(client, "drug_morp_w")
	cureDisease(client, "drug_hero")
	cureDisease(client, "drug_hero_w")
	cureDisease(client, "drug_coca")
	cureDisease(client, "drug_coca_w")
	cureDisease(client, "drug_meth")
	cureDisease(client, "drug_meth_w")
	cureDisease(client, "drug_opium")
	cureDisease(client, "drug_opium_w")
end
DISEASE.effectC = function(client, char) --cure effect

end

DISEASES:Register( DISEASE )
//
local DISEASE = {}
DISEASE.uid = "drug_sanpedro"
DISEASE.name = "San Pedro"
DISEASE.category = "Drugs"
DISEASE.duration = 720
DISEASE.phase = {
	"Your vision is filled with whirlpools of colored light.",
	"Reality seems like a giant kaleidoscope.",
	"You feel as if the gates of heaven open, and Saint Peter welcomes you.",
	"You sense electricity in your veins.",
	"Your thoughts flow like water.",
	"You feel relaxed and in control, even with all the visual effects.",
}
DISEASE.cure = {
	"You slowly come down from your San Pedro high.",
}
DISEASE.effect = function(client, char) --purges some other drugs and withdrawal effects
	--client:addHunger(-50) --makes you hungry
	client:SetHealth( math.Clamp(client:Health() + 40, 0, 100) ) --heal for 40
	--client:setLocalVar("stm", 100) --replenishes stamina
	cureDisease(client, "drug_morp")
	cureDisease(client, "drug_morp_w")
	cureDisease(client, "drug_hero")
	cureDisease(client, "drug_hero_w")
	cureDisease(client, "drug_coca")
	cureDisease(client, "drug_coca_w")
	cureDisease(client, "drug_meth")
	cureDisease(client, "drug_meth_w")
	cureDisease(client, "drug_opium")
	cureDisease(client, "drug_opium_w")
end
DISEASE.effectC = function(client, char) --cure effect

end

DISEASES:Register( DISEASE )