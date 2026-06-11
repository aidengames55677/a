-- "gamemodes\\mafiarp\\plugins\\lockpicking\\items\\sh_lockpick.lua"

ITEM.name = "Lockpick"
ITEM.desc = "A device used to bypass door locks."
ITEM.price = 50
ITEM.exRender = true
ITEM.model = "models/weapons/w_crowbar.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(348.43951416016, 293.08743286133, 213.71182250977),
	ang = Angle(25, 220, 10),
	fov = 2.75,
}
ITEM.noBusiness = true
ITEM.category = "Tools"

ITEM.functions.Use = {
	onRun = function(item)
		if (item.beingUsed) then
			return false
		end

		local ply = item.player
		local target = ply:GetEyeTrace().Entity

		if (target:getNetVar("cuffed") and IsValid(target)) then
			item.beingUsed = true
			local timerID = "Lockpicksnd"..ply:SteamID()
			timer.Create(timerID, 1, 15, function()
				if (!ply || !ply:getNetVar("isPicking")) then
					timer.Remove(timerID)
				else
					local snd = {1,3,4}
					ply:EmitSound("weapons/357/357_reload".. tostring(snd[math.random(1, #snd)]) ..".wav", 75, 100)
				end
			end)

			ply:setNetVar("isPicking", true)
			ply:setAction("Lockpicking", 15)
			ply:doStaredAction(target, function()
				item:remove()
				ply:EmitSound("doors/door_latch3.wav")
				ply:setNetVar("isPicking")
				timer.Remove(timerID)

				target:setNetVar("cuffed")
				target:setRestricted(false)
				ResetPlyAnims(target)

				-- untie

			end, 15, function()
				ply:setNetVar("isPicking")
				ply:setAction()
				item.beingUsed = false
				timer.Remove(timerID)
			end)
		elseif (!ply:getNetVar("restricted") && IsValid(target) or target:IsVehicle() && target:isLocked()) then
			item.beingUsed = true
			local timerID = "Lockpicksnd"..ply:SteamID()
			timer.Create(timerID, 1, 15, function()
				if (!ply || !ply:getNetVar("isPicking")) then
					timer.Remove(timerID)
				else
					local snd = {1,3,4}
					ply:EmitSound("weapons/357/357_reload".. tostring(snd[math.random(1, #snd)]) ..".wav", 75, 100)
				end
			end)

			if target.IsSimfphyscar && target:GetNW2Int("VehicleID") then
				local plugin = nut.plugin.list.cardealer
				local vehicle = plugin.loaded_vehicles[target:GetNW2Int("VehicleID")]

				if vehicle:getData("alarm") && !target.alarm then
					target:EmitSound("car_alarm.ogg", 100)
					
					target.alarm = true
					timer.Simple(14, function()
						if IsValid(target) then
							target.alarm = nil
						end
					end)
				end
			end
			ply:setNetVar("isPicking", true)
			ply:setAction("Lockpicking", 15)
			ply:doStaredAction(target, function()
				item:remove()
				ply:EmitSound("doors/door_latch3.wav")
				target:Fire("unlock")
				if (target:IsVehicle() && target.IsSimfphyscar) then
					target.IsLocked = false
				end
				ply:setNetVar("isPicking")
				timer.Remove(timerID)
			end, 15, function()
				ply:setNetVar("isPicking")
				ply:setAction()
				item.beingUsed = false
				timer.Remove(timerID)
			end)
		else
			item.player:notifyLocalized("Target is already unlocked.")
		end

		return false
	end,
	onCanRun = function(item)
		return !IsValid(item.entity)
	end
}

if CLIENT then
	hook.Add( "PlayerBindPress", "DisablePickinglol", function(ply, bind, pressed)
		if (string.find( bind, "+use") and (ply:getNetVar("isPicking")) or string.find( bind, "+attack" or string.find( bind, "+attack2") and (ply:getNetVar("isPicking"))) and (ply:getNetVar("isPicking"))) then 
			return true 
		end
	end)
end

function ITEM:onCanBeTransfered(inventory, newInventory)
	return !self.beingUsed
end