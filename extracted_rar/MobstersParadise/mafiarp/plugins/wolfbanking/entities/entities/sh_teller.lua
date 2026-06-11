ENT.Type = "anim"
ENT.PrintName = "Bank Teller"
ENT.Category = "NutScript"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.isVendor = true

function ENT:Initialize()
	if (SERVER) then
		self:SetModel("models/player/suits/male_09_shirt_tie.mdl")
		self:SetUseType(SIMPLE_USE)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:DrawShadow(true)
		self:SetSolid(SOLID_OBB)
		self:PhysicsInit(SOLID_OBB)

		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(false)
			physObj:Sleep()
		end
	end

	timer.Simple(1, function()
		if (IsValid(self)) then
			self:setAnim()
		end
	end)
end

function ENT:setAnim()
	for k, v in ipairs(self:GetSequenceList()) do
		if v:lower():find("idle") and v ~= "idlenoise" then
			return self:ResetSequence(k)
		end
	end

	self:ResetSequence(4)
end

if SERVER then
	function ENT:SpawnFunction(client, trace)
		local angles = (trace.HitPos - client:GetPos()):Angle()
		angles.r = 0
		angles.p = 0
		angles.y = angles.y + 180

		local entity = ents.Create("sh_teller")
		entity:SetPos(trace.HitPos)
		entity:SetAngles(angles)
		entity:Spawn()

		entity:AddToPerma()

		return entity
	end
else
	function ENT:createBubble()
		self.bubble = ClientsideModel("models/extras/info_speech.mdl", RENDERGROUP_OPAQUE)
		self.bubble:SetPos(self:GetPos() + Vector(0, 0, 84))
		self.bubble:SetModelScale(0.6, 0)
	end

	function ENT:Draw()
		local bubble = self.bubble

		if (IsValid(bubble)) then
			local realTime = RealTime()

			bubble:SetRenderOrigin(self:GetPos() + Vector(0, 0, 84 + math.sin(realTime * 3) * 0.05))
			bubble:SetRenderAngles(Angle(0, realTime * 100, 0))
		end

		self:DrawModel()
	end

	function ENT:Think()
		local noBubble = self:getNetVar("noBubble")

		if (IsValid(self.bubble) and noBubble) then
			self.bubble:Remove()
		elseif (!IsValid(self.bubble) and !noBubble) then
			self:createBubble()
		end

		if ((self.nextAnimCheck or 0) < CurTime()) then
			self:setAnim()
			self.nextAnimCheck = CurTime() + 60
		end

		self:SetNextClientThink(CurTime() + 0.25)

		return true
	end

	function ENT:OnRemove()
		if (IsValid(self.bubble)) then
			self.bubble:Remove()
		end
	end

	local TEXT_OFFSET = Vector(0, 0, 20)
	local toScreen = FindMetaTable("Vector").ToScreen
	local colorAlpha = ColorAlpha
	local drawText = nut.util.drawText
	local configGet = nut.config.get

	ENT.DrawEntityInfo = true

	function ENT:onDrawEntityInfo(alpha)
		local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self)) + TEXT_OFFSET)
		local x, y = position.x, position.y
		local desc = self.getNetVar(self, "desc")

		drawText("Bank Teller", x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 0.65)
	end
end

function ENT:Use(ply)
  netstream.Start(ply, "OpenBankingTeller")
end
