-------------------------------------------------------------------------------------------
AddCSLuaFile()
-------------------------------------------------------------------------------------------
local PLUGIN = PLUGIN
-------------------------------------------------------------------------------------------
ENT.PrintName = "Medium Rock"
ENT.Type = "anim"
ENT.Author = "Leonheart"
ENT.Category = "RedDawn - Mining"
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.PhysgunDisable = true
ENT.PhysgunAllowAdmin = true
ENT.Model = "models/props_wasteland/rockgranite03a.mdl"
--------------------------------------------------------------------------------------------------------
if SERVER then
    function ENT:Initialize()
        self:SetModel(self.Model)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetNoDraw(false)
        self:SetModelScale(1)
        self:SetNWInt("HP", nut.config.rockTable[self:GetClass()].hp)
        local physObj = self:GetPhysicsObject()
        physObj:EnableMotion(false)
    end

    function ENT:OnTakeDamage(dmginfo)
        local ply = dmginfo:GetAttacker()
        local wep = ply:GetActiveWeapon():GetClass()
        local hp = self:GetNWInt("HP", 0)
        if wep == nut.config.get("PickAxeSWEP") then
            self:SetNWInt("HP", hp - nut.config.get("PickDMGPerHit"))
            self:EmitSound("physics/concrete/boulder_impact_hard" .. math.random(1, 4) .. ".wav", 75)
            if hp > 0 then
                RockBreak(self, ply)
            else
                RockBreak(self, ply)
                RockSpawn(self, ply, "rock_small", self:GetPos())
                self:Remove()
            end
        end
    end
end
--------------------------------------------------------------------------------------------------------