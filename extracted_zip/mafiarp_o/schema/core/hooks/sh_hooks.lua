-----------------------------------------------------------------------------------------------
--[[
--these hooks are for tfa
--i guess a way to go around this is by using the TFA_GetStat hook, idk
--itd just be if statements for each stat, all the ones in the att
-- ply:getImplantRes() to get implant specific adds to this, but do GetArmorResists instead just in case
--Hook_ModifyRecoil normal hook, var is tbl of Recoil, RecoilSide, VisualRecoilMul
hook.Add("GetKickUpStat", "MainS", function(wep, stat)
	return stat * nut.traits.getMod(wep:GetOwner(), "wepreceff", wep.Type or "")
end)

hook.Add("GetKickDownStat", "MainS", function(wep, stat)
	return stat-- * nut.traits.getMod(wep:GetOwner(), "wepreceff", wep.Type or "")
end)

hook.Add("GetKickHorizontalStat", "MainS", function(wep, stat)
	return stat * nut.traits.getMod(wep:GetOwner(), "wepreceff", wep.Type or "")
end)

hook.Add("GetStaticRecoilFactorStat", "MainS", function(wep, stat)

end)
--Damage
hook.Add("GetDamageStat", "MainS", function(wep, stat)
	return stat * nut.traits.getMod(wep:GetOwner(), "wepdmgeff", wep.Type or "")
end)
--accuracymoa or Mult_HipDispersion?
hook.Add("GetSpreadStat", "MainS", function(wep, stat)
	return stat * nut.traits.getMod(wep:GetOwner(), "wepspreff", wep.Type or "")
end)
--SightsDispersion?
hook.Add("GetIronAccuracyStat", "MainS", function(wep, stat)
	local res = wep:GetOwner():GetArmorResists()

	return stat * (res["ironacc"] or 1)
end)

hook.Add("GetIronRecoilMultiStat", "MainS", function(wep, stat)
	local res = wep:GetOwner():GetArmorResists()
	return stat * (res["ironrecoil"] or 1) * nut.traits.getMod(wep:GetOwner(), "wepireceff", wep.Type or "")
end)

hook.Add("GetCrouchAccuracyMultiStat", "MainS", function(wep, stat)

end)
--SightTime
hook.Add("GetIronSightsTimeStat", "MainS", function(wep, stat)
	local res = wep:GetOwner():GetArmorResists()
	local qk = wep:GetOwner():getChar():getAttrib("qkn", 0)
	local qkn = 1+((qk/30)*0.15)

	return stat * (res["irontime"] or 1) * qkn * nut.traits.getMod(wep:GetOwner(), "wepireff", wep.Type or "")
end)

hook.Add("GetWeaponMoveSpeedMulti", "MainS", function(wep, stat)

end)
--SightedSpeedMult
hook.Add("GetIronSightsMoveSpeedMulti", "MainS", function(wep, stat)
	local res = wep:GetOwner():GetArmorResists()
	return stat * (res["ironms"] or 1)
end)
--this should be a way to speed up reloads
--Mult_ReloadTime
hook.Add("TFA_AnimationRate", "MainS", function(wep, anim, rate)
	--i think these are all of them
	if(!IsValid(wep) or !IsValid(wep:GetOwner()) or !wep:GetOwner():getChar()) then return end

	--todo move this to a table probably
	if(anim == ACT_VM_RELOAD or anim == ACT_VM_RELOAD_EMPTY or anim == ACT_VM_RELOAD_INSERT or anim == ACT_VM_RELOAD_INSERT_PULL or anim == ACT_VM_RELOAD_END or anim == ACT_VM_RELOAD_END_EMPTY or anim == ACT_VM_RELOAD_INSERT_EMPTY or anim == ACT_SHOTGUN_RELOAD_START or anim == ACT_SHOTGUN_RELOAD_FINISH or anim == 2105 or anim == 2150 or anim == 2151 or anim == 2094 or anim == 2095) then
		local qk = wep:GetOwner():getChar():getAttrib("qkn", 0)
		local qkn = 1+((qk/30)*0.16)
		
		qkn = qkn * nut.traits.getMod(wep:GetOwner(), "wepreloadeff", wep.Type or "")


		return rate * qkn
	end
end)
]]
-----------------------------------------------------------------------------------------------
function SCHEMA:CanPlayerUseChar(client, char)
	if(!client) then return end
	if(client:InVehicle()) then
		return false, "You cannot switch characters while in a vehicle or sitting!"
	end
	if(client:getNetVar("restricted")) then
		return false, "You cannot switch characters while tied!"
	end
end
-----------------------------------------------------------------------------------------------
--restrict business menu to people with the flags for it
function SCHEMA:BuildBusinessMenu(panel)
	local char = LocalPlayer():getChar()
	if(char:hasFlags("U")) then
		return true
	else
		return false
	end
end

-----------------------------------------------------------------------------------------------
--restrict organization menu to people with the flags for it
function SCHEMA:BuildOrganizationMenu(panel)
	local char = LocalPlayer():getChar()
	if(char:hasFlags("O")) then
		return true
	else
		return false
	end
end
-----------------------------------------------------------------------------------------------
function SCHEMA:CanPlayerSitAnywhere(client)
	if (client:isArrested()) then
		return false
	end
end
-----------------------------------------------------------------------------------------------
--[[ Create a variable to track whether the player's hands are up
local handsUp = false

-- Listen for the key press event
hook.Add("Think", "HandsUpHotkey", function()
    -- Check if the F6 key is down
    if input.IsKeyDown(KEY_F6) then
        -- If the key is down and handsUp is false, make the player raise their hands
        if not handsUp then
            LocalPlayer():DoAnimationEvent(ACT_GMOD_GESTURE_SURRENDER)
            handsUp = true
        end
    else
        -- If the key is not down and handsUp is true, make the player lower their hands
        if handsUp then
            LocalPlayer():DoAnimationEvent(ACT_GMOD_GESTURE_SURRENDER, true)
            handsUp = false
        end
    end
end)]]
-----------------------------------------------------------------------------------------------