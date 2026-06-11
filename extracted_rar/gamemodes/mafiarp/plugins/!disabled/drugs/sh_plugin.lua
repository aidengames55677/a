PLUGIN.name = "Drugs"
PLUGIN.author = "Chancer"
PLUGIN.desc = "Simple drugs."

nut.util.include("sh_drugeffects.lua")

if(SERVER) then
	function PLUGIN:EntityTakeDamage(target, dmginfo)
		if(target:IsPlayer() and dmginfo:GetAttacker() != target) then
			local char = target:getChar()
			if(char) then
				if(char:getData("drug_meth")) then --meth
					dmginfo:ScaleDamage(1.2) --increases damage taken
				end
				
				if(char:getData("drug_morp")) then --morphine
					local dmg = dmginfo:GetDamage()
					dmginfo:ScaleDamage(0.6)
					
					timer.Simple(45, function() --delayed damage
						if(target and target:Alive()) then
							target:TakeDamage(dmg * 0.25, target)
						end
					end)
				end
				
				if(char:getData("drug_hero")) then --heroin
					dmginfo:ScaleDamage(0.7) --decreases damage taken
				end
				
				if(char:getData("cocaine")) then --cocaine
					local dmg = dmginfo:GetDamage()
					dmginfo:ScaleDamage(0.5)
					
					timer.Simple(6, function() --delayed damage
						if(target and target:Alive()) then
							target:TakeDamage(dmg * 0.75, target)
						end
					end)
				end
				
			if ( dmginfo:IsBulletDamage() ) then
				local trace = {}
				local attacker = dmginfo:GetAttacker()
				if(attacker) then
					trace.start = attacker:GetShootPos()
						
					trace.endpos = trace.start + ( ( dmginfo:GetDamagePosition() - trace.start ) * 2 )  
					trace.mask = MASK_SHOT
					trace.filter = attacker
						
					local tr = util.TraceLine( trace )
					hitgroup = tr.HitGroup
								
					if hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
						target:EmitSound("physics/body/body_medium_break"..math.random(2,4)..".wav", 70)
						char:setData("leg_injury", CurTime())
						DISEASES.diseases["leg_injury"].effect(target, char) --runs the drugs start function
					end
				end
			end				
				
			end
		end
	end
	
	function PLUGIN:PlayerDeath(victim, inflictor, attacker)
		cureDisease(victim, "drug_morp")
		cureDisease(victim, "drug_morp_w")
		cureDisease(victim, "drug_hero")
		cureDisease(victim, "drug_hero_w")
		cureDisease(victim, "drug_coca")
		cureDisease(victim, "drug_coca_w")
		cureDisease(victim, "drug_meth")
		cureDisease(victim, "drug_meth_w")
		cureDisease(victim, "drug_weed")
	end
end