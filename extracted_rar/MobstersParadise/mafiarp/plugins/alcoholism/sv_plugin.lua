local PLUGIN = PLUGIN
local meta = FindMetaTable("Player")

function meta:AddBAC(amt)
	local plugin = nut.plugin.list["alcoholism"]
	plugin:AddBAC(self, amt)
end

function PLUGIN:AddBAC(ply, amt)
	if !IsValid(ply) then return end
	if !amt or !isnumber(amt) then return end
	
	ply:SetNW2Int("nut_alcoholism_bac", math.Clamp(ply:GetNW2Int("nut_alcoholism_bac", 0) + amt, 0, 100))
end

function PLUGIN:Think()
	if !self.next_think then
		self.next_think = CurTime()
	end
	
	if self.next_think <= CurTime() then
		for k,v in next, player.GetAll() do
			local bac = v:GetNW2Int("nut_alcoholism_bac", 0)
			if bac > 0 then
				v:SetNW2Int("nut_alcoholism_bac", math.Clamp(bac - nut.config.get("alcoholism_degraderate", 5), 0, 100))
			end
		end
		
		self.next_think = CurTime() + nut.config.get("alcoholism_ticktime", 30)
	end
end

local moves = {
	[IN_FORWARD] = true,
	[IN_BACK] = true,
	[IN_MOVELEFT] = true,
	[IN_MOVERIGHT] = true,
	[IN_SPEED] = true,
}

function PLUGIN:StartCommand(ply, ucmd)
	if((ply.nextDrunkCheck or 0) < CurTime()) then
		ply.nextDrunkCheck = CurTime() + 0.05
		
		if(ply:GetNW2Int("nut_alcoholism_bac", 0) > 30) then		
			ucmd:ClearButtons()
			
			if((ply.nextDrunkSide or 0) < CurTime()) then
				ply.nextDrunkSide = CurTime() + math.Rand(0.1,0.3) + (ply:GetNW2Int("nut_alcoholism_bac", 0) * 0.01)
				
				ply.sideRoll = math.random(-1,1)
				ply.frontRoll = math.random(-1,1)
			end
			
			if(ply.frontRoll == 1) then
				ucmd:SetForwardMove(100000)
			elseif(ply.frontRoll == -1) then
				ucmd:SetForwardMove(-100000)
			end
			
			if(ply.sideRoll == 1) then
				ucmd:SetSideMove(100000)
			elseif(ply.sideRoll == -1) then
				ucmd:SetSideMove(-100000)
			end
		end
	end
end

function PLUGIN:resetBAC(ply)
	ply:SetNW2Int("nut_alcoholism_bac", nil)
end

function PLUGIN:PlayerLoadedChar(ply)
	PLUGIN:resetBAC(ply)
end

function PLUGIN:PlayerLoadout(ply)
	PLUGIN:resetBAC(ply)
end