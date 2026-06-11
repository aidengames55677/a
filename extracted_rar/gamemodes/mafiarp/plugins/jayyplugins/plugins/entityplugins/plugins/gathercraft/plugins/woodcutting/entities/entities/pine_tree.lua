-------------------------------------------------------------------------------------------
AddCSLuaFile()
-------------------------------------------------------------------------------------------
local PLUGIN = PLUGIN
-------------------------------------------------------------------------------------------
ENT.PrintName = "Pine Tree"
ENT.Type = "anim"
ENT.Author = "Leonheart"
ENT.Category = "RedDawn - Woodcuting"
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.PhysgunDisable = true
ENT.PhysgunAllowAdmin = true
-------------------------------------------------------------------------------------------
if SERVER then
    function ENT:Initialize()
        self:SetModel("models/props_foliage/tree_pine05.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetNoDraw(false)
        self:SetNWInt("HP", nut.config.TreeTable[self:GetClass()].hp)
        local physObj = self:GetPhysicsObject()
        physObj:EnableMotion(false)
    end

    function ENT:OnTakeDamage(dmginfo)
        local ply = dmginfo:GetAttacker()
        local wep = ply:GetActiveWeapon():GetClass()
        local hp = self:GetNWInt("HP", 0)
        if wep == nut.config.get("AxeSWEP") then
            self:SetNWInt("HP", hp - nut.config.get("AxeDMGPerHit"))
            if hp > 0 then
                TreeBreak(self, ply)
            else
                TreeBreak(self, ply)
                TreeSpawn(self, ply, self:GetClass(), self:GetPos())
                self:Remove()
            end
        end
    end
end
-------------------------------------------------------------------------------------------