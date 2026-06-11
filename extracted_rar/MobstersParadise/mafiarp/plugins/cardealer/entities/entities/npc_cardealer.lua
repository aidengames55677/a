-- "gamemodes\\mafiarp\\plugins\\cardealer\\entities\\entities\\npc_cardealer.lua"

AddCSLuaFile();
ENT.Type = "ai"
ENT.Base = "base_ai"

ENT.PrintName	= "Car Dealer NPC"
ENT.Author	= "Nitoria"
ENT.Category = "Diverge Entities"

ENT.Spawnable	= true
ENT.AdminOnly	= true


function ENT:Initialize()
	if (SERVER) then
		self:SetModel( "models/Humans/Group02/male_08.mdl" )
		self:SetHullType( HULL_HUMAN )
		self:SetHullSizeNormal( )
		self:SetNPCState( NPC_STATE_SCRIPT )
		self:SetSolid( SOLID_BBOX )
		self:CapabilitiesAdd( CAP_ANIMATEDFACE )
		self:SetUseType( SIMPLE_USE )
		--self:DropToFloorent()
	end
end

if (SERVER) then

	function ENT:OnTakeDamage()
	    return false
	end

	function ENT:AcceptInput( Name, Activator, Caller )    
	    if Name == "Use" and Caller:IsPlayer() then
	    	net.Start("ui_dealership")
	    		net.WriteEntity(self)
	    	net.Send(Caller)
	    end
	end
end

if (CLIENT) then

	local TEXT_OFFSET = Vector(0, 0, 20)
	local toScreen = FindMetaTable("Vector").ToScreen
	local colorAlpha = ColorAlpha
	local drawText = nut.util.drawText
	local configGet = nut.config.get
	
		ENT.DrawEntityInfo = true

	function ENT:onDrawEntityInfo(alpha)
		local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self)) + TEXT_OFFSET)
		local x, y = position.x, position.y
		--local desc = self.getNetVar(self, "desc")

		drawText("Paul McCormick", x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 0.65)

		--if (desc) then
			drawText("Hey, you looking to buy a car?", x, y + 16, colorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
		--end
	end
end