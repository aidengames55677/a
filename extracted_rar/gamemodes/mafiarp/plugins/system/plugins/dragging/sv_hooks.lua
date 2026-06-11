local PLUGIN = PLUGIN

DRAGGING_TARGETRADIUS = 50*50 -- SQUARED FOR PERFORMANCE The distance the dragged player will try to achieve
DRAGGING_MOVE_SPEED = 160 -- Dragged players always walk, so put this between 0 and walk speed (160 by default)
DRAGGING_MAX_DISTANCE = 200*200 -- SQUARED FOR PERFORMANCE When the drag gets interrupted
DRAGGING_START_RANGE = 100
DRAGGING_SWEP = "nut_hands"

PLUGIN.Dragging = {}
PLUGIN.Draggers = {}

function PLUGIN:IsBeingDragged(dragee)
	return (self.Dragging[dragee] != nil)
end

function PLUGIN:SetDrag(dragee, drager)
	if (!IsValid(dragee)) then return end
	if (IsValid(self.Draggers[drager]) && IsValid(self.Dragging[self.Draggers[drager]])) then
		self.Dragging[self.Draggers[drager]] = nil
	end
	if (drager == nil) then
		if (self.Dragging[dragee]) then
			self.Draggers[self.Dragging[dragee]] = nil
		end
	else
		self.Draggers[drager] = dragee
	end
	self.Dragging[dragee] = drager
end

function PLUGIN:PlayerDisconnected(ply)
	for k,v in pairs(self.Dragging or {}) do
		if (k == ply or v == ply) then
			self.Dragging[k] = nil
		end
	end
end

function PLUGIN:PlayerDeath(ply)
	for k,v in pairs(self.Dragging or {}) do
		if (k == ply or v == ply) then
			self.Dragging[k] = nil
		end
	end
end

function PLUGIN:StartCommand(ply, cmd)
	if (self.Dragging[ply] && IsValid(self.Dragging[ply])) then
		local dragger = self.Dragging[ply]
		local TargetPos = dragger:GetPos()
		cmd:ClearMovement()
		local myPos = ply:GetPos()
		local MoveVector = WorldToLocal(TargetPos, Angle(0, 0, 0), myPos, ply:GetAngles())
		MoveVector:Normalize()
		MoveVector:Mul(DRAGGING_MOVE_SPEED)
		cmd:RemoveKey(IN_JUMP)
		cmd:RemoveKey(IN_SPEED)
		cmd:RemoveKey(IN_DUCK)
		cmd:RemoveKey(IN_WALK)
		
		ply:SetEyeAngles((dragger:GetPos() - ply:GetPos()):Angle())
		
		local dist2Sqr = (TargetPos.x - myPos.x)^2 + (TargetPos.y - myPos.y)^2
		if (dist2Sqr > DRAGGING_MAX_DISTANCE) then
			self:SetDrag(ply, nil)
			return
		elseif (dist2Sqr > DRAGGING_TARGETRADIUS) then
			cmd:SetForwardMove(MoveVector.x)
			cmd:SetSideMove(-MoveVector.y)
		end
	end
	
	if (self.Draggers[ply] && IsValid(self.Draggers[ply])) then
		if (!ply:KeyDown(IN_ATTACK2)) then
			self:SetDrag(self.Draggers[ply], nil)
		end
	end
end

function PLUGIN:KeyPress(ply, key)
	if (IsValid(ply) and key == IN_ATTACK2 and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == DRAGGING_SWEP and !ply:InVehicle() and !self:IsBeingDragged(ply)) then
		local traceEnt = ply:GetEyeTrace().Entity
		if (IsValid(traceEnt) and traceEnt:IsPlayer() and traceEnt:GetPos():DistToSqr(ply:GetPos()) <= DRAGGING_START_RANGE * DRAGGING_START_RANGE and traceEnt:getNetVar("restricted") and !traceEnt:InVehicle()) then
			self:SetDrag(traceEnt, ply)
		end
	end
end

function PLUGIN:simfphysUse(car,client)
	if (IsValid(client)) then
		local dragee = self.Draggers[client]
		
		if (IsValid(dragee)) then
			car:SetPassenger(dragee)
		end
	end
end