AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Miami Times"
ENT.Author = "Rook"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Category = "Rook"


if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/props_lab/clipboard.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self.receivers = {}
		local physicsObject = self:GetPhysicsObject()

		if (IsValid(physicsObject)) then
			physicsObject:Wake()
		end
	end

	
	function ENT:Use(activator)
	if team.GetName(activator:Team()) == "The Miami Times" then
	net.Start("ArticleMenu")
	net.Send(activator)
	else
	activator:notify("You do not have access to this.")
	end
	end

else
	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:onShouldDrawEntityInfo()
		return true
	end

	function ENT:onDrawEntityInfo(alpha)
		local position = (self:LocalToWorld(self:OBBCenter()) + self:GetUp()*1):ToScreen()
		local x, y = position.x, position.y

		nut.util.drawText("Notepad", x, y, ColorAlpha(nut.config.get("color"), alpha), 1, 1, nil, alpha * 0.65)
		nut.util.drawText("", x, y + 16, ColorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
	end
end
