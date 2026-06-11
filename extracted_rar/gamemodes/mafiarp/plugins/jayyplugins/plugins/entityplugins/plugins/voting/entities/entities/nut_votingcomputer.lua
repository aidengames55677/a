AddCSLuaFile()

local PLUGIN = PLUGIN

ENT.Type = "anim"
ENT.PrintName = "Voting Box"
ENT.Author = "_FR_Starfox64"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "RedDawn - Voting"

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/ballotbox/ballotbox.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetUseType( SIMPLE_USE )
	end

	function ENT:AcceptInput(name, activator, ply, data)
		if name == "Use" and IsValid(ply) and ply:IsPlayer() then
			if PLUGIN:CanVote(ply) then
				netstream.Start(ply, "nut_OpenVotingComputer", PLUGIN.votingList)
			end
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
		local position = toScreen(self:LocalToWorld(self:OBBCenter()) + TEXT_OFFSET)
		local x, y = position.x, position.y
		local desc = self.getNetVar(self, "desc")

		-- Draw the name of the vendor.
		drawText(
			self.getNetVar(self, "name", "Ballot Box"),
			x, y,
			colorAlpha(configGet("color"), alpha),
			1, 1,
			nil,
			alpha * 0.65
		)

		-- Draw the vendor's description below the name.
		if (desc) then
			drawText(
				desc,
				x, y + 16,
				colorAlpha(color_white, alpha),
				1, 1,
				"nutSmallFont",
				alpha * 0.65
			)
		end
	end
end