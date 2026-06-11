-- "gamemodes\\mafiarp\\plugins\\rjobs\\entities\\entities\\kt_delivery_crate.lua"

AddCSLuaFile();
ENT.Type = "anim"
ENT.PrintName	= "Delivery Crate"
ENT.Author	= "Killing Torcher"
ENT.Category = "Diverge Entities"

ENT.Spawnable	= true
ENT.AdminOnly	= true
ENT.DrawEntityInfo = true

function ENT:Initialize()
	if (SERVER) then
		self:SetModel( "models/items/item_item_crate.mdl" )
		self:SetUseType(SIMPLE_USE)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetTrigger(true)
		--self:DropToFloorent()
		
		local physObj = self:GetPhysicsObject()
		
		if (IsValid(physObj)) then
			physObj:EnableMotion(true)
			physObj:Wake()
		end
	end
end

if (SERVER) then
	function ENT:StartTouch(ent)
		if (!self.Affixed && ent.DeliveryTruck && ent.DeliveryTruckOwner == self.CrateOwner && !IsValid(ent.DeliveryCrateAttached)) then
			self.Affixed = true
			self:SetTrigger(false)
			
			self:SetParent(ent)
			self:SetPos(Vector(-100, 0, 33))
			self:SetAngles(Angle(0, 0, 0))
			constraint.NoCollide(self, ent, 0, 0)
			ent.DeliveryCrateAttached = self
		end
	end
end

if (CLIENT) then
	function ENT:onDrawEntityInfo(alpha)
		local position = (self.LocalToWorld(self, self.OBBCenter(self))):ToScreen()
		local x, y = position.x, position.y

		nut.util.drawText("Delivery Crate", x, y, ColorAlpha(nut.config.get("color"), alpha), 1, 1, nil, alpha * 0.65)
	end
end