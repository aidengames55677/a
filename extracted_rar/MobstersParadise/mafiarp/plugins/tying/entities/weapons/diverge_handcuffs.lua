-- "gamemodes\\mafiarp\\plugins\\tying\\entities\\weapons\\diverge_handcuffs.lua"

local PLUGIN = PLUGIN

SWEP.PrintName      = "Handcuffs"
SWEP.Category       = "Diverge Networks"		
SWEP.Slot   		= 3
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false

SWEP.Weight 		= 5
SWEP.AutoSwitchTo	= false
SWEP.AutoSwitchFrom	= false

SWEP.Author 			= ""
SWEP.Contact			= ""
SWEP.Purpose			= ""
SWEP.Instructions		= ""
 
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
 
SWEP.ViewModel			= "models/weapons/spy/handcuffs.mdl"
SWEP.WorldModel 		= "models/weapons/spy/w_handcuffs.mdl"
 
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo   		= "none"
 
SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo 		= "none"

function SWEP:GetTarget()
    local client = self:GetOwner()
    local data = {}
        data.start = client:GetShootPos()
        data.endpos = data.start + client:GetAimVector()*96
        data.filter = client
    return util.TraceLine(data).Entity
end

function SWEP:PrimaryAttack()
    local client = self:GetOwner()
    local target = self:GetTarget()

    if not SERVER then return end
    if not IsValid(target) then return end
    if not target:IsPlayer() then return end
    if not target:getChar() then return end

    
    --if !target:IsBot() && !EventServer then
    --    if (target.DLastKeyPress or 0) <= SysTime() - 150 then 
    --        client:notify("This player is AFK, you cannot tie them!")
    --        return false
    --    end
    --end
    
    if target:Team() == FACTION_STAFF then
        target:notify("You were just attempted to be restrained by "..client:Name()..".")
        client:notify("You can't tie a staff member!")
        return false
    end

    if (!target:getNetVar("tying") and !target:getNetVar("restricted")) then
        client:EmitSound("physics/plastic/plastic_barrel_strain"..math.random(1, 3)..".wav")
        client:setAction("Cuffing...", 2)
        client:doStaredAction(target, function()
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
            target:setNetVar("cuffed", true) -- var to check against if cuffs have been used.

            SAdmin:AddLog("Cuffing", client:Nick().." cuffed "..target:Nick().. " "..target:SteamID(), client:SteamID())
            SAdmin:AddLog("Cuffing", target:Nick().." was cuffed by "..client:Nick().. " "..client:SteamID(), target:SteamID())
            for k,v in pairs(POLICE.Cuffed) do
                local bone = target:LookupBone(k)
                if bone then
                    target:ManipulateBoneAngles(bone, v)
                end
            end


            client:EmitSound("npc/barnacle/neck_snap1.wav", 100, 140)
        end, 2, function()
            client:setAction()

            target:setAction()
            target:setNetVar("tying")
        end)

        target:setNetVar("tying", true)
        target:setAction("@beingTied", 2)
    else
        client:notifyLocalized("plyNotValid")
    end


end

function SWEP:SecondaryAttack()
    local client = self:GetOwner()
    local target = self:GetTarget()

    if not SERVER then return end
    if not IsValid(target) then return end
    if not target:IsPlayer() then return end
    if not target:getChar() then return end

    if target:getNetVar("restricted") and target:getNetVar("cuffed") then
        client:EmitSound("physics/plastic/plastic_barrel_strain"..math.random(1, 3)..".wav")
        client:setAction("Uncuffing...", .35)
        client:doStaredAction(target, function()
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
            
            target:setNetVar("cuffed")
            target:setRestricted(false)
            target:SendLua([[hook.Remove( "RenderScreenspaceEffects", "BlindFold"..LocalPlayer():UserID())]])
			local dragging = client:GetNW2Entity("Dragging", nil)
			if IsValid(dragging) then 
                SetDrag(target, nil)
            end

            ResetPlyAnims(target)

            client:EmitSound("npc/roller/blade_in.wav")

            SAdmin:AddLog("Cuffing", client:Nick().." uncuffed "..target:Nick().. " "..target:SteamID(), client:SteamID())
            SAdmin:AddLog("Cuffing", target:Nick().." was uncuffed by "..client:Nick().. " "..client:SteamID(), target:SteamID())
            client:EmitSound("npc/barnacle/neck_snap1.wav", 100, 140)
        end, .35, function()
            client:setAction()

            target:setAction()
            target:setNetVar("tying")
        end)

    end
end