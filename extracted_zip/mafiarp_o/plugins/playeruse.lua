-- "gamemodes\\1942rp\\plugins\\playeruse.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

DRAGGING_TARGETRADIUS = 50*50 // SQUARED FOR PERFORMANCE The distance the dragged player will try to achieve
DRAGGING_MOVE_SPEED = 160 // Dragged players always walk, so put this between 0 and walk speed (160 by default)
DRAGGING_MAX_DISTANCE = 200*200 // SQUARED FOR PERFORMANCE When the drag gets interrupted
DRAGGING_START_RANGE = 100
DRAGGING_SWEP = "nut_hands"

if (SERVER) then
	Dragging = {}
	Draggers = {}
	
	function IsBeingDragged(dragee)
		return (Dragging[dragee] != nil)
	end
	
	function SetDrag(dragee, drager)
		if (!IsValid(dragee)) then return end
		if (IsValid(Draggers[drager]) && IsValid(Dragging[Draggers[drager]])) then
			Dragging[Draggers[drager]] = nil
		end
		if (drager == nil) then
			if (Dragging[dragee]) then
				Draggers[Dragging[dragee]] = nil
			end
		else
			Draggers[drager] = dragee
		end
		Dragging[dragee] = drager
	end
	
	hook.Add("PlayerDisconnected","Dragging::Disconnected", function(ply)
		for k,v in pairs(Dragging or {}) do
			if (k == ply or v == ply) then
				Dragging[k] = nil
				net.Start("Dragging::Update")
				net.WriteBool(false)
				net.Send(k)
			end
		end
	end)
	
	hook.Add("PlayerDeath", "Dragging::Death", function(ply)
		for k,v in pairs(Dragging or {}) do
			if (k == ply or v == ply) then
				Dragging[k] = nil
				net.Start("Dragging::Update")
				net.WriteBool(false)
				net.Send(k)
			end
		end
	end)
	
	hook.Add("StartCommand", "Dragging::StartCommand", function(ply, cmd)
		if (Dragging[ply] && IsValid(Dragging[ply])) then
			local dragger = Dragging[ply]
			local TargetPos = dragger:GetPos()
			cmd:ClearMovement()
			local myPos = ply:GetPos()
			local MoveVector = WorldToLocal(TargetPos, Angle(0, 0, 0), myPos, ply:GetAngles())
			MoveVector:Normalize()
			MoveVector:Mul(DRAGGING_MOVE_SPEED)
			cmd:RemoveKey(IN_JUMP)
			cmd:RemoveKey(IN_SPEED)
			cmd:RemoveKey(IN_DUCK)
			
			local dist2Sqr = (TargetPos.x - myPos.x)^2 + (TargetPos.y - myPos.y)^2
			if (dist2Sqr > DRAGGING_MAX_DISTANCE) then
				SetDrag(ply, nil)
				return
			elseif (dist2Sqr > DRAGGING_TARGETRADIUS) then
				cmd:SetForwardMove(MoveVector.x)
				cmd:SetSideMove(-MoveVector.y)
			end
		end
		
		if (Draggers[ply] && IsValid(Draggers[ply])) then
			if (!ply:KeyDown(IN_ATTACK)) then
				SetDrag(Draggers[ply], nil)
			end
		end
	end)

	hook.Add("KeyPress", "Dragging::KeyPress", function(ply, key)
		if (IsValid(ply) && key == IN_ATTACK && IsValid(ply:GetActiveWeapon()) && ply:GetActiveWeapon():GetClass() == DRAGGING_SWEP && !ply:InVehicle() && !IsBeingDragged(ply)) then
			local traceEnt = ply:GetEyeTrace().Entity
			if (IsValid(traceEnt) && traceEnt:IsPlayer() && traceEnt:GetPos():DistToSqr(ply:GetPos()) <= DRAGGING_START_RANGE * DRAGGING_START_RANGE && traceEnt:getNetVar("restricted") && ! traceEnt:InVehicle()) then
				SetDrag(traceEnt, ply)
			end
		end

		if(IsValid(ply) && key == IN_ATTACK2 && IsValid(ply:GetActiveWeapon()) && ply:GetActiveWeapon():GetClass() == DRAGGING_SWEP && !ply:InVehicle() && !IsBeingDragged(ply) && IsValid(Draggers[ply])) then
			local target = ply:GetEyeTrace().Entity
			local dist2Sqr = (target:GetPos().x - ply:GetPos().x)^2 + (target:GetPos().y - ply:GetPos().y)^2
			if(dist2Sqr < DRAGGING_MAX_DISTANCE and target:GetClass() == "gmod_sent_vehicle_fphysics_base") then
				for k,v in pairs(target:GetPassengerSeats()) do
					if(IsValid(v)  and not IsValid(v:GetDriver())) then
						target = v
						break
					end
				end
			end
			Draggers[ply]:EnterVehicle(target)
			Draggers[ply].restrictVehicle = target
		end
	end)
end