-- "gamemodes\\mafiarp\\plugins\\casinonpc\\entities\\entities\\casinonpc\\shared.lua"


ENT.Type = "anim"
ENT.PrintName = "Casino NPC"
ENT.Author = "GlorifiedPig"
ENT.Category = "Diverge Entities"

ENT.Spawnable = true
ENT.AdminOnly = true

function ENT:SetupDataTables()
    self:NetworkVar( "Int", 0, "CasinoID" ) -- ID of the casino.
    self:NetworkVar( "Int", 1, "OwnerCharID" ) -- CharID that owns this casino.
    self:NetworkVar( "Int", 2, "Balance" ) -- Cache balance of this casino. The real balance and other vars (such as logs) will be in the database, linked to the CasinoID.
    self:NetworkVar( "String", 0, "CasinoName" ) -- Name of the casino.
    self:NetworkVar( "Bool", 0, "GamblingEnabled" ) -- Whether or not gambling is enabled in this casino.
end

function ENT:IsCasinoSetup()
    local casinoId = self:GetCasinoID()
    local owner = self:GetOwnerCharID()
    return casinoId and owner and casinoId ~= 0 and owner ~= 0
end

function ENT:GetSerializedPosition()
    return tostring( self:GetPos() ) .. ":" .. tostring( self:GetAngles() )
end