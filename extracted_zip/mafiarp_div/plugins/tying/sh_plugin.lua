-- "gamemodes\\mafiarp\\plugins\\tying\\sh_plugin.lua"

PLUGIN.name = "Tying"
PLUGIN.author = "Chessnut"
PLUGIN.desc = "Adds the ability to tie players."

nut.util.include("sv_plugin.lua", "server")
nut.util.include("sh_admincharsearch.lua")

POLICE = POLICE or {}
POLICE.Cuffed = POLICE.Cuffed or {}

function ResetPlyAnims(target)
	for k, v in pairs(POLICE.Cuffed) do
		local bone = target:LookupBone(k)
		if bone then
			target:ManipulateBoneAngles(bone, Angle(0, 0, 0))
		end
	end
end

PLUGIN.PoliceCuffFactions = 
{
	[FACTION_POLICE] = true
}

if (SERVER) then
	function PLUGIN:PlayerLoadout(client)
		client:setNetVar("restricted")
		ResetPlyAnims(client)
	end

	function PLUGIN:PlayerUse(client, entity)
		if (!client:getNetVar("restricted") and entity:IsPlayer() and entity:getNetVar("restricted") and !entity.nutBeingUnTied and !IsBeingDragged(entity) and !entity:getNetVar("cuffed")) then
			
			entity.nutBeingUnTied = true
			entity:setAction("@beingUntied", 3)

			client:setAction("@unTying", 3)
			client:doStaredAction(entity, function()
				entity:setRestricted(false)
				entity.nutBeingUnTied = false
                entity:SendLua([[hook.Remove( "RenderScreenspaceEffects", "BlindFold"..LocalPlayer():UserID())]])
				ResetPlyAnims(entity)

				client:EmitSound("npc/roller/blade_in.wav")
			end, 3, function()
				if (IsValid(entity)) then
					entity.nutBeingUnTied = false
					entity:setAction()
				end

				if (IsValid(client)) then
					client:setAction()
				end
			end)
		end
	end
else
	local COLOR_TIED = Color(245, 215, 110)
	local COLOR_CUFFED = Color(107, 159, 255)

	function PLUGIN:DrawCharInfo(client, character, info)
		if not client:getNetVar("restricted") then return end

		if !client:getNetVar("cuffed") then
			info[#info + 1] = {"This individual is restrained.", COLOR_TIED}
		else
			info[#info + 1] = {"This individual is cuffed.", COLOR_CUFFED}
		end
	end
end

-- This has to be shared or else you will break prediction.
DRAGGING_TARGETRADIUS = 50*50 // SQUARED FOR PERFORMANCE The distance the dragged player will try to achieve
DRAGGING_MOVE_SPEED = 200 // Dragged players always walk, so put this between 0 and walk speed (160 by default)
DRAGGING_MAX_DISTANCE = 300*300 // SQUARED FOR PERFORMANCE When the drag gets interrupted
DRAGGING_START_RANGE = 100

function IsBeingDragged(dragged)
	if !IsValid(dragged) then return end

	return dragged:GetNW2Entity("BeingDragged", false)
end

function SetDrag(dragged, dragger)
	if !IsValid(dragged) then return end
	if !dragger then
		local dragger = IsBeingDragged(dragged)
		dragger:SetNW2Entity("Dragging", nil)
		dragged:SetNW2Entity("BeingDragged", nil)
	
		return
	end

	if !IsValid(dragger) then return end
	if dragged:GetNW2Entity("BeingDragged", false) then return end
	if dragger:GetNW2Entity("Dragging", false) then return end

	dragged:SetNW2Entity("BeingDragged", dragger)
	dragger:SetNW2Entity("Dragging", dragged)
end

hook.Add("StartCommand", "Dragging::StartCommand", function(ply, cmd)
	local dragger = IsBeingDragged(ply)
	if IsValid(dragger) then
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
		if !dragger:Alive() then
			SetDrag(ply, nil)
		end
	end
end)

hook.Add("KeyPress", "Dragging::KeyPress", function(ply, key)
	if (IsValid(ply) && key == IN_ATTACK && IsValid(ply:GetActiveWeapon()) && !ply:InVehicle() && !IsBeingDragged(ply)) then
		local traceEnt = ply:GetEyeTrace().Entity
		if (IsValid(traceEnt) && traceEnt:IsPlayer() && traceEnt:GetPos():DistToSqr(ply:GetPos()) <= DRAGGING_START_RANGE * DRAGGING_START_RANGE && traceEnt:getNetVar("restricted") && ! traceEnt:InVehicle()) then
			SetDrag(traceEnt, ply)
		end
	end
end)