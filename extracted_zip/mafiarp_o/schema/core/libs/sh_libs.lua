-------------------------------------------------------------------------------------------------------------------------
local isStaff = {
    ["Network Owner"] = true,
    ["Network Co-Owner"] = true,
    ["Head Developer"] = true,
    ["Community Director"] = true,
    ["Supervising Administrator"] = true,
    ["Head Administrator"] = true,
    ["Administrator"] = true,
    ["Moderator"] = true,
    ["Trial Moderator"] = true,
    ["Community Manager"] = true
}

-------------------------------------------------------------------------------------------------------------------------
local isVip = {
    ["Network Owner"] = true,
    ["Network Co-Owner"] = true,
    ["Head Developer"] = true,
    ["Community Director"] = true,
    ["Supervising Administrator"] = true,
    ["Head Administrator"] = true,
    ["Administrator"] = true,
    ["Moderator"] = true,
    ["Trial Moderator"] = true,
    ["Community Manager"] = true,
    ["VIP"] = true,
    ["VIPPLUS"] = true
}

-------------------------------------------------------------------------------------------------------------------------
function SCHEMA:CanDeleteChar(ply, char)
    if char:getMoney() < nut.config.get("defMoney", 0) then return true end
end

-------------------------------------------------------------------------------------------------------------------------
function SCHEMA:PlayerSwitchFlashlight(ply, on)
    if not ply:getChar() then return end

    if ply:getChar():getInv():hasItem("flashlight") then
        return true
    else
        return false
    end
end

-------------------------------------------------------------------------------------------------------------------------
function SCHEMA:PlayerSpray(client)
    return true
end

-------------------------------------------------------------------------------------------------------------------------
function SCHEMA:GetGameDescription()
    return "WW2RP"
end

-------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerNoClip", "nsClippyClip", function(player, state)
    if (player:IsAdmin()) then
        if (state) then
            player:SetNoDraw(true)
            player:DrawShadow(false)
            player:SetNotSolid(true)
        else
            player:SetNoDraw(false)
            player:DrawShadow(true)
            player:SetNotSolid(false)
        end
    elseif player:getChar():getFaction() == FACTION_STAFF then
        if (state) then
            player:SetNoDraw(true)
            player:DrawShadow(false)
            player:SetNotSolid(true)
        else
            player:SetNoDraw(false)
            player:DrawShadow(false)
            player:SetNotSolid(false)
        end

        return true
    else
        return false
    end
end)

-------------------------------------------------------------------------------------------------------------------------
function SCHEMA:CanPlayerSpawnStorage(client)
    if client:IsSuperAdmin() or client:IsAdmin() then
        return true
    else
        return false
    end
end

------------------------------------------------------------------------------------------------------------------------
function SCHEMA:OnCharCreated(client, character)
    timer.Simple(5, function()
        client:SendLua([[gui.OpenURL("https://discord.gg/JVwvMfmn3f")]])
    end)
end

------------------------------------------------------------------------------------------------------------------------
function SCHEMA:OnWeaponEquipped(client, equip)
    client:notify("You have equipped your" .. ITEM.name .. ".")
end

------------------------------------------------------------------------------------------------------------------------
function SCHEMA:OnItemDropped(client)
    client:notify("You have dropped your" .. ITEM.name .. ".")
end

------------------------------------------------------------------------------------------------------------------------
function SCHEMA:ShouldCollide(f, t)
    if f:GetClass() == "nut_item" and t:GetClass() == "nut_item" then return false end
end

------------------------------------------------------------------------------------------------------------------------
hook.Add("CheckValidSit", "noVehSit", function(ply, trace)
    local ent = trace.Entity
    if ent:IsVehicle() then return false end
end)

------------------------------------------------------------------------------------------------------------------------
function SCHEMA:EntityTakeDamage(target, dmginfo)
    if (target:IsPlayer()) then
        local inflictor = dmginfo:GetInflictor()

        if (IsValid(inflictor) and (inflictor:GetClass() == "gmod_sent_vehicle_fphysics_base" or inflictor:GetClass() == "gmod_sent_vehicle_fphysics_wheel")) then
            if (not IsValid(target:GetVehicle())) then
                dmginfo:ScaleDamage(0)

                if (not IsValid(target.nutRagdoll)) then
                    target:setRagdolled(true, 5)
                end
            end
        end
    end
end

------------------------------------------------------------------------------------------------------------------------
function SCHEMA:DrawCharInfo(client, character, info)
    if (client:getChar():getClass()) then
        local playerClass = client:getChar():getClass()
        local className = nut.class.list[playerClass].name
        local COLOR_CLASS = Color(245, 215, 110)
        info[#info + 1] = {L""..className.."", COLOR_CLASS}
    end
end

------------------------------------------------------------------------------------------------------------------------