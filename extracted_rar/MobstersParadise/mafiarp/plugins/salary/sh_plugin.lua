local PLUGIN = PLUGIN
PLUGIN.name = "Salaries"
PLUGIN.author = "Chancer & Baid"
PLUGIN.desc = "An NPC that gives you money when you deserve it."
PLUGIN.nextPayment = 0

if SERVER then
	local rankModels = { --the models and what payment people receive for having them
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male02.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male03.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male04.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male05.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male06.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male07.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male08.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male09.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyguard_male01.mdl"] = 70,
		["models/player/pa/compiled 0.34/panavyguard_male02.mdl"] = 70,
		["models/player/pa/compiled 0.34/panavyguard_male03.mdl"] = 70,
		["models/player/pa/compiled 0.34/panavyguard_male04.mdl"] = 70,
		["models/player/pa/compiled 0.34/panavyguard_male05.mdl"] = 70,
		["models/player/pa/compiled 0.34/panavyguard_male06.mdl"] = 70,
		["models/player/pa/compiled 0.34/panavyguard_male07.mdl"] = 70,
		["models/player/pa/compiled 0.34/panavyguard_male08.mdl"] = 70,
		["models/player/pa/compiled 0.34/panavyguard_male09.mdl"] = 70,
		["models/player/pa/compiled 0.34/panavymedic_male01.mdl"] = 70,
		["models/player/pa/compiled 0.34/panavymedic_male02.mdl"] = 70,
		["models/player/pa/compiled 0.34/panavymedic_male03.mdl"] = 70,
		["models/player/pa/compiled 0.34/panavymedic_male04.mdl"] = 70,
		["models/player/pa/compiled 0.34/panavymedic_male05.mdl"] = 70,
		["models/player/pa/compiled 0.34/panavymedic_male06.mdl"] = 70,
		["models/player/pa/compiled 0.34/panavymedic_male07.mdl"] = 70,
		["models/player/pa/compiled 0.34/panavymedic_male08.mdl"] = 70,
		["models/player/pa/compiled 0.34/panavymedic_male09.mdl"] = 70,
		["models/player/pa/compiled 0.34/panavysailor_male01.mdl"] = 70,
		["models/player/pa/compiled 0.34/panavysailor_male02.mdl"] = 70,
		["models/player/pa/compiled 0.34/panavysailor_male03.mdl"] = 70,
		["models/player/pa/compiled 0.34/panavysailor_male04.mdl"] = 70,
		["models/player/pa/compiled 0.34/panavysailor_male05.mdl"] = 70,
		["models/player/pa/compiled 0.34/panavysailor_male06.mdl"] = 70,
		["models/player/pa/compiled 0.34/panavysailor_male07.mdl"] = 70,
		["models/player/pa/compiled 0.34/panavysailor_male08.mdl"] = 70,
		["models/player/pa/compiled 0.34/panavysailor_male09.mdl"] = 70,
		["models/bloocobalt/science/navy_09.mdl"] = 150,
		["models/player/portal/male_02_fireman.mdl"] = 70,
		["models/player/portal/male_04_fireman.mdl"] = 70,
		["models/player/portal/male_05_fireman.mdl"] = 70,
		["models/player/portal/male_06_fireman.mdl"] = 70,
		["models/player/portal/male_07_fireman.mdl"] = 70,
		["models/player/portal/male_08_fireman.mdl"] = 70,
		["models/player/portal/male_09_fireman.mdl"] = 70,
		["models/kerry/detective/male_01.mdl"] = 80,
		["models/kerry/detective/male_02.mdl"] = 80,
		["models/kerry/detective/male_03.mdl"] = 80,
		["models/kerry/detective/male_04.mdl"] = 80,
		["models/kerry/detective/male_05.mdl"] = 80,
		["models/kerry/detective/male_06.mdl"] = 80,
		["models/kerry/detective/male_07.mdl"] = 80,
		["models/kerry/detective/male_08.mdl"] = 80,
		["models/kerry/detective/male_09.mdl"] = 80,
		["models/kerry/ag_player/swat.mdl"] = 100,
		["models/kerry/ag_player/male_01.mdl"] = 75,
		["models/kerry/ag_player/male_02.mdl"] = 75,
		["models/kerry/ag_player/male_03.mdl"] = 75,
		["models/kerry/ag_player/male_04.mdl"] = 75,
		["models/kerry/ag_player/male_05.mdl"] = 75,
		["models/kerry/ag_player/male_06.mdl"] = 75,
		["models/kerry/ag_player/male_07.mdl"] = 75,
		["models/kerry/ag_player/male_08.mdl"] = 75,
		["models/kerry/ag_player/male_09.mdl"] = 75,
		["models/kerry/ag_player/male_01_cheff.mdl"] = 100,
		["models/kerry/ag_player/male_02_cheff.mdl"] = 100,
		["models/kerry/ag_player/male_04_cheff.mdl"] = 100,
		["models/kerry/ag_player/male_05_cheff.mdl"] = 100,
		["models/kerry/ag_player/male_06_cheff.mdl"] = 100,
		["models/kerry/ag_player/male_07_cheff.mdl"] = 100,
		["models/kerry/ag_player/male_08_cheff.mdl"] = 100,
		["models/kerry/ag_player/male_09_cheff.mdl"] = 100,
		["models/portal/nypd/nypdmale_03.mdl"] = 75,
		["models/portal/nypd/nypdmale_03_arm.mdl"] = 75,
		["models/portal/nypd/nypdmale_03_b.mdl"] = 75,
		["models/portal/nypd/nypdmale_04.mdl"] = 75,
		["models/portal/nypd/nypdmale_04_arm.mdl"] = 75,
		["models/portal/nypd/nypdmale_04_b.mdl"] = 75,
		["models/portal/nypd/nypdmale_05.mdl"] = 75,
		["models/portal/nypd/nypdmale_05_arm.mdl"] = 75,
		["models/portal/nypd/nypdmale_05_b.mdl"] = 75,
		["models/portal/nypd/nypdmale_06.mdl"] = 75,
		["models/portal/nypd/nypdmale_06_arm.mdl"] = 75,
		["models/portal/nypd/nypdmale_06_b.mdl"] = 75,
		["models/portal/nypd/nypdmale_07.mdl"] = 75,
		["models/portal/nypd/nypdmale_07_arm.mdl"] = 75,
		["models/portal/nypd/nypdmale_07_b.mdl"] = 75,
		["models/sd/players/[dbs_brawler]-head_brawler_dbs.mdl"] = 10,
		["models/sd/players/[dbs_brawler_2]-head_brawler_dbs.mdl"] = 10,
		["models/sd/players/[dbs_grappler].mdl"] = 10,
		["models/sd/players/[dbs_grappler_2].mdl"] = 10,
		["models/sd/players/[dbs_quick]-head_quick_dbs.mdl"] = 10,
		["models/sd/players/[dbs_quick]-head_quick_dbs_2.mdl"] = 10,
		["models/sd/players/[dbs_quick]-head_striker_dbs.mdl"] = 10,
		["models/sd/players/[dbs_striker]-head_quick_dbs.mdl"] = 10,
		["models/sd/players/[dbs_striker]-head_quick_dbs_2.mdl"] = 10,
		["models/sd/players/[dbs_striker]-head_striker_dbs.mdl"] = 10,
		["models/sd/players/[soy_brawler]-head_brawler_dbs.mdl"] = 10,
		["models/sd/players/[soy_grappler].mdl"] = 10,
		["models/sd/players/[soy_quick]-head_quick_soy.mdl"] = 10,
		["models/sd/players/[soy_striker]-head_striker_soy.mdl"] = 10,
		["models/humans/adaster/male_01.mdl"] = 10,
		["models/humans/adaster/male_02.mdl"] = 10,
		["models/humans/adaster/male_03.mdl"] = 10,
		["models/humans/adaster/male_04.mdl"] = 10,
		["models/humans/adaster/male_05.mdl"] = 10,
		["models/humans/adaster/male_06.mdl"] = 10,
		["models/humans/adaster/male_07.mdl"] = 10,
		["models/humans/adaster/male_08.mdl"] = 10,
		["models/humans/adaster/male_09.mdl"] = 10,
		["models/stahl/humans/female/female_01.mdl"] = 10,
		["models/stahl/humans/female/female_02.mdl"] = 10,
		["models/stahl/humans/female/female_04.mdl"] = 10,
		["models/stahl/humans/female/female_06.mdl"] = 10,
		["models/humans/modern/female_01.mdl"] = 10,
		["models/humans/modern/female_02.mdl"] = 10,
		["models/humans/modern/female_04.mdl"] = 10,
		["models/humans/modern/female_06.mdl"] = 10,
		["models/player/suits/male_01_closed_tie.mdl"] = 10,
		["models/player/suits/male_01_open.mdl"] = 10,
		["models/player/suits/male_01_open_tie.mdl"] = 10,
		["models/player/suits/male_01_open_waistcoat.mdl"] = 10,
		["models/player/suits/male_01_shirt.mdl"] = 10,
		["models/player/suits/male_01_shirt_tie.mdl"] = 10,
		["models/player/suits/male_02_closed_coat_tie.mdl"] = 10,
		["models/player/suits/male_02_closed_tie.mdl"] = 10,
		["models/player/suits/male_02_open.mdl"] = 10,
		["models/player/suits/male_02_open_tie.mdl"] = 10,
		["models/player/suits/male_02_open_waistcoat.mdl"] = 10,
		["models/player/suits/male_02_shirt.mdl"] = 10,
		["models/player/suits/male_02_shirt_tie.mdl"] = 10,
		["models/player/suits/male_03_closed_coat_tie.mdl"] = 10,
		["models/player/suits/male_03_closed_tie.mdl"] = 10,
		["models/player/suits/male_03_open.mdl"] = 10,
		["models/player/suits/male_03_open_tie.mdl"] = 10,
		["models/player/suits/male_03_open_waistcoat.mdl"] = 10,
		["models/player/suits/male_03_shirt.mdl"] = 10,
		["models/player/suits/male_03_shirt_tie.mdl"] = 10,
		["models/player/suits/male_04_closed_coat_tie.mdl"] = 10,
		["models/player/suits/male_04_closed_tie.mdl"] = 10,
		["models/player/suits/male_04_open.mdl"] = 10,
		["models/player/suits/male_04_open_tie.mdl"] = 10,
		["models/player/suits/male_04_open_waistcoat.mdl"] = 10,
		["models/player/suits/male_04_shirt.mdl"] = 10,
		["models/player/suits/male_04_shirt_tie.mdl"] = 10,
		["models/player/suits/male_05_closed_coat_tie.mdl"] = 10,
		["models/player/suits/male_05_closed_tie.mdl"] = 10,
		["models/player/suits/male_05_open.mdl"] = 10,
		["models/player/suits/male_05_open_tie.mdl"] = 10,
		["models/player/suits/male_05_open_waistcoat.mdl"] = 10,
		["models/player/suits/male_05_shirt_tie.mdl"] = 10,
		["models/player/suits/male_06_closed_coat_tie.mdl"] = 10,
		["models/player/suits/male_06_closed_tie.mdl"] = 10,
		["models/player/suits/male_06_open.mdl"] = 10,
		["models/player/suits/male_06_open_tie.mdl"] = 10,
		["models/player/suits/male_06_open_waistcoat.mdl"] = 10,
		["models/player/suits/male_06_shirt.mdl"] = 10,
		["models/player/suits/male_06_shirt_tie.mdl"] = 10,
		["models/player/suits/male_07_closed_coat_tie.mdl"] = 10,
		["models/player/suits/male_07_closed_tie.mdl"] = 10,
		["models/player/suits/male_07_open.mdl"] = 10,
		["models/player/suits/male_07_open_tie.mdl"] = 10,
		["models/player/suits/male_07_open_waistcoat.mdl"] = 10,
		["models/player/suits/male_07_shirt.mdl"] = 10,
		["models/player/suits/male_07_shirt_tie.mdl"] = 10,
		["models/player/suits/male_08_closed_coat_tie.mdl"] = 10,
		["models/player/suits/male_08_closed_tie.mdl"] = 10,
		["models/player/suits/male_08_open.mdl"] = 10,
		["models/player/suits/male_08_open_tie.mdl"] = 10,
		["models/player/suits/male_08_open_waistcoat.mdl"] = 10,
		["models/player/suits/male_08_shirt.mdl"] = 10,
		["models/player/suits/male_08_shirt_tie.mdl"] = 10,
		["models/player/suits/male_09_closed_coat_tie.mdl"] = 10,
		["models/player/suits/male_09_closed_tie.mdl"] = 10,
		["models/player/suits/male_09_open.mdl"] = 10,
		["models/player/suits/male_09_open_tie.mdl"] = 10,
		["models/player/suits/male_09_open_waistcoat.mdl"] = 10,
		["models/player/suits/male_09_shirt.mdl"] = 10,
		["models/player/suits/male_09_shirt_tie.mdl"] = 10,
	}
	
	

	function PLUGIN:Think()
		if CurTime() > self.nextPayment then
			for _, v in pairs(player.GetAll()) do
				if IsValid(v) and v:getChar() then
					local char = v:getChar()
					local modelValue = rankModels[v:GetModel()]
					
					local amount = (modelValue or 0)
					
					char:setData("earnings", char:getData("earnings", 0) + amount)
					if modelValue then
						v:notify("You have been paid " .. amount .. " Dollars. Go to the bank to retrieve it.")
					end
				end
			end
			
			self.nextPayment = CurTime() + 600
		end
	end

	function PLUGIN:SaveData()
		local data = {}
			for k, v in ipairs(ents.FindByClass("nut_salary")) do
				data[#data + 1] = {
					name = v:getNetVar("name"),
					desc = v:getNetVar("desc"),
					pos = v:GetPos(),
					angles = v:GetAngles(),
					model = v:GetModel(),
					material = v:GetMaterial()
				}
			end
		self:setData(data)
	end

	function PLUGIN:LoadData()
		for k, v in ipairs(ents.FindByClass("nut_salary")) do
			v:Remove()
		end	
		for k, v in ipairs(self:getData() or {}) do
			local entity = ents.Create("nut_salary")
			entity:SetPos(v.pos)
			entity:SetAngles(v.angles)
			entity:Spawn()
			entity:SetModel(v.model)
			entity:SetMaterial(v.material)
		end
	end
end