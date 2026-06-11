-- "gamemodes\\mafiarp\\plugins\\npctrading\\entities\\entities\\trader\\shared.lua"

ENT.Type = "anim"
ENT.PrintName	= "Trader NPC"
ENT.Author	= "Diverge"
ENT.Category = "Diverge Entities"

ENT.Spawnable	= true
ENT.AdminOnly	= true

function ENT:SetupDataTables()
    self:NetworkVar( "String", 0, "TraderName" )
    self:NetworkVar( "String", 1, "TraderDesc" )

    self:SetTraderName( "Unnamed Trader" )
    self:SetTraderDesc( "" )
end