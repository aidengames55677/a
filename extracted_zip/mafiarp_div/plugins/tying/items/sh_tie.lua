-- "gamemodes\\mafiarp\\plugins\\tying\\items\\sh_tie.lua"

ITEM.name = "Restraints"
ITEM.desc = "A pair of ties used in the process of restraining individuals by binding their hands."
ITEM.price = 1000
ITEM.noBusiness = true
ITEM.model = "models/items/crossbowrounds.mdl"
ITEM.functions.Use = {
	onRun = function(item)
		if (item.beingUsed) then
			return false
		end

		local client = item.player
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector()*96
			data.filter = client
		local target = util.TraceLine(data).Entity
		
		if IsValid(target) && target:IsPlayer() && !target:IsBot() && !EventServer then
			if (target.DLastKeyPress or 0) <= SysTime() - 150 then 
				client:notify("This player is AFK, you cannot tie them!")
				return false
			end
		end
		
		if IsValid(target) && target:IsPlayer() && target:Team() == FACTION_STAFF then
			target:notify("You were just attempted to be restrained by "..client:Name()..".")
			client:notify("You can't tie a staff member!")
			return false
		end

		if (IsValid(target) and target:IsPlayer() and target:getChar() and !target:getNetVar("tying") and !target:getNetVar("restricted")) then
			item.beingUsed = true

			client:EmitSound("physics/plastic/plastic_barrel_strain"..math.random(1, 3)..".wav")
			client:setAction("@tying", 3)
			client:doStaredAction(target, function()
				item:remove()
				
				for _, v in pairs(target:getChar():getInv():getItems()) do
					local itemTable = nut.item.instances[v.id]
					if (itemTable.isWeapon && itemTable:getData("equip")) then
						itemTable:interact("EquipUn", target)
					end
					if (itemTable:getData("power")) then
						itemTable:interact("toggle", target)
					end
					if (itemTable:getData("enabled")) then
						if target:GetNW2Int("IsPhoneCall", 0) > 0 then
							itemTable:interact("cancelcall", target)
							itemTable:interact("disable", target)
						else
							itemTable:interact("disable", target)
						end
					end 
				end
				
				target:setRestricted(true)
				target:setNetVar("tying")
				SAdmin:AddLog("Tying", client:Nick().." tied "..target:Nick().. " "..target:SteamID(), client:SteamID())
				SAdmin:AddLog("Tying", target:Nick().." was tied by "..client:Nick().. " "..client:SteamID(), target:SteamID())
							
				for k,v in pairs(POLICE.Cuffed) do
					local bone = target:LookupBone(k)
					if bone then
						target:ManipulateBoneAngles(bone, v)
					end
				end


				client:EmitSound("npc/barnacle/neck_snap1.wav", 100, 140)
			end, 3, function()
				client:setAction()

				target:setAction()
				target:setNetVar("tying")

				item.beingUsed = false
			end)

			target:setNetVar("tying", true)
			target:setAction("@beingTied", 3)
		else
			item.player:notifyLocalized("plyNotValid")
		end

		return false
	end,
	onCanRun = function(item)
		return !IsValid(item.entity)
	end
}


if (CLIENT) then
	hook.Add( "PlayerBindPress", "DisableFeaturesWhileTied", function(ply, bind, pressed)
		if (string.find( bind, "+speed") and (ply:getNetVar("restricted")) or (string.find( bind, "gm_showhelp") and 
		(ply:getNetVar("restricted"))) or (string.find( bind, "+jump") and (ply:getNetVar("restricted")) and !IsValid(ply.nutRagdoll)) or (string.find( bind, "+walk") and (ply:getNetVar("restricted"))) or  
		(string.find( bind, "+use") and (ply:getNetVar("restricted")))) then 
			return true 
		end
	end)
	
	hook.Add( "PlayerBindPress", "DisableFeaturesWhileTied1", function(ply, bind, pressed)
		if (string.find(bind, "gm_showhelp") and (IsValid(ply.nutRagdoll))) then 
			return true 
		end
	end)
end


function ITEM:onCanBeTransfered(inventory, newInventory)
	return !self.beingUsed
end