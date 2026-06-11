PLUGIN.name = "Durability"

PLUGIN.author = "Logan"

PLUGIN.desc = "Weapons Got Durability"

if (SERVER) then

	function PLUGIN:EntityFireBullets(entity)

	

		if entity:IsPlayer() and entity:IsValid() then

		

			local char = entity:getChar()

			local inventory = char:getInv()

			local curWeapon = entity:GetActiveWeapon():GetClass()

			

			for k, v in pairs(inventory:getItems()) do

				

				if v.class == curWeapon and v:getData("equip", nil) then

					if v.noDurability == true then return end -- Alows to opt-out certain guns from using this shit

					

					local curHealth = v:getData("health", v.defaultHealth) or v.defaultHealth

					

					if math.random(1, v.damageChance) == 1 then

						v:setData("health", math.max(0, curHealth - math.max(0, math.random(0,10))))

					end



					if curHealth == 0 then

						v:setData("equip", nil)

						entity.carryWeapons = entity.carryWeapons or {}

	

						local weapon = entity.carryWeapons[v.weaponCategory]

						if (!IsValid(weapon)) then

							weapon = entity:GetWeapon(v.class)

						end

			

						if (IsValid(weapon)) then

							v:setData("ammo", weapon:Clip1())

	

							entity:StripWeapon(v.class)

							entity.carryWeapons[v.weaponCategory] = nil

							entity:EmitSound("items/ammo_pickup.wav", 80)

							

						end

					end

					-- I can add bullet shit here if I want (update: i don't want)

				end

			end

		end

	end



--[[ Use this if ammo checking doesn't work]]

--[[ if (key == IN_ATTACK and ply:GetActiveWeapon():GetClass() == "weapon_crowbar") then]]



	function PLUGIN:KeyPress(ply, key)

		-- If weapon doesn't have an ammo type, it's a melee weapon.

		if (key == IN_ATTACK and ply:GetActiveWeapon():GetPrimaryAmmoType()) then



			if !IsFirstTimePredicted() then

				return

			end



			if ply:IsPlayer() and ply:IsValid() then



				local char = ply:getChar()

				local inventory = char:getInv()

				local curWeapon = ply:GetActiveWeapon():GetClass()

				for k, v in pairs(inventory:getItems()) do

				

					if v.class == curWeapon and v:getData("equip", nil) then

						if v.noDurability == true then return end -- Alows to opt-out certain guns from using this shit

						

						local curHealth = v:getData("health", v.defaultHealth) or v.defaultHealth



						local shootPosition = ply:GetShootPos()

						local endShootPosition = shootPosition + ply:GetAimVector() * 70

						local tmin = Vector(1,1,1) * -10

						local tmax = Vector(1,1,1) * 10



						-- Sends a 20x20 box.

						local trace = util.TraceHull(( {

							start = shootPosition,

							endpos = endShootPosition,

							filter = entity,

							mask = MASK_SHOT_HULL,

							mins = tmin,

							maxs = tmax

						}))



						local entity = trace.Entity



						-- Sends a single line out.

						if(!IsValid(trace.Entity)) then

							trace = util.TraceLine( {

								start = shootpos,

								endpos = endShootPosition,

								filter = enttity,

								mask = MASK_SHOT_HULL

							})

						end



						if(IsValid(ply) && (ply:IsPlayer() || ply:IsNPC())) then

							if (math.random(1, v.damageChance) == 1) then

								v:setData("health", math.max(0, curHealth - math.max(0, math.random(0,10))))

							end

						end

	

						if curHealth == 0 then

							v:setData("equip", nil)

							entity.carryWeapons = entity.carryWeapons or {}

		

							local weapon = entity.carryWeapons[v.weaponCategory]

							if (!IsValid(weapon)) then

								weapon = entity:GetWeapon(v.class)

							end

				

							if (IsValid(weapon)) then

								v:setData("ammo", weapon:Clip1())

		

								entity:StripWeapon(v.class)

								entity.carryWeapons[v.weaponCategory] = nil

								entity:EmitSound("items/ammo_pickup.wav", 80)

								

							end

						end

						-- If checking health, check here.

					end

				end

			end

		end

	end

end--my suffering

