AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:setAnim()
	for k, v in ipairs(self:GetSequenceList()) do
		if (v:lower():find("idle") and v ~= "idlenoise") then
			return self:ResetSequence(k)
		end
	end

	self:ResetSequence(4)
end

function ENT:Initialize()
	if (SERVER) then
		self:SetModel( "models/odessa.mdl" )
		self:SetUseType(SIMPLE_USE)
		self:SetMoveType(MOVETYPE_NONE)
		self:DrawShadow(true)
		self:SetSolid(SOLID_BBOX)
		self:PhysicsInit(SOLID_BBOX)
		--self:DropToFloorent()
	end
	
	timer.Simple(1, function()
		if (IsValid(self)) then
			self:setAnim()
		end
	end)
	
	local physObj = self:GetPhysicsObject()
	
	if (IsValid(physObj)) then
		physObj:EnableMotion(false)
		physObj:Sleep()
	end
end

if (SERVER) then

	local function spawnNPC()
		/*if (!NPC_taxi || !IsValid(NPC_taxi)) then
			NPC_taxi = ents.Create("npc_taxi")
			NPC_taxi:SetModel("models/player/suits/male_08_open.mdl")
			NPC_taxi:SetPos(Vector(-2120.031250, 6929.425293, 7392.365234))
			NPC_taxi:SetAngles(Angle(11.279880, -177.991425, 0.000000))
			NPC_taxi:Spawn()
		end*/
	end
	hook.Add("LoadData", "Taxi_npc::Spawn", spawnNPC)


	util.AddNetworkString("ui_taxi_npc")
	util.AddNetworkString("ui_taxi_hired_npc")
	util.AddNetworkString("taxi_job")
	util.AddNetworkString("taxi_resign")
	util.AddNetworkString("taxi_take")
	util.AddNetworkString("taxi_return")


	net.Receive("taxi_job", function( len, ply ) 
		if team.GetName( ply:Team() ) == "Citizens of Berlin" then
			local faction = nut.faction.indices[FACTION_ATAXI]
			ply:getChar().vars.faction = faction.uniqueID
			ply:getChar():setFaction(faction.index)
			ply:notify("You have been hired into Berlin Taxis.")
			else
			ply:notify("You already have a job!")
			end
			end)			
		
	net.Receive("taxi_resign", function( len, ply ) 
		if (ply:Team() != FACTION_ATAXI) then return end
		
		local faction = nut.faction.indices[FACTION_citizen]
    	ply:getChar().vars.faction = faction.uniqueID
		ply:getChar():setFaction(faction.index)
		end)
		
	net.Receive('taxi_take', function(length, ply)
		if (IsValid(ply.taxiEnt)) then 
			ply:notify("You already have a Taxi out.")
			return 
		end
		
		
		for k,v in pairs(ents.FindInSphere(Vector( -2728.754639, 6359.442383, 7368.031250 ), 150)) do
			if (IsValid(v) && (v:GetClass() == "gmod_sent_vehicle_fphysics_base" || (v:IsPlayer() && v:Alive()))) then
				ply:notify("The Taxi Cab spawn is being blocked.")
				return
			end
		end
		
		local _v = simfphys.SpawnVehicleSimple( "simfphys_mafia2_shubert_taxi", Vector( -2728.754639, 6359.442383, 7368.031250 ), Angle( 0, 90, 0 ) )
		_v:SetNWInt( "Owner", ply:EntIndex() )
		_v:SetSkin( 1 )
		_v:Lock()
		_v.CPPIGetOwner = function()
			return ply
		end
		_v.taxi = true
		ply.taxiEnt = _v
		print(_v)
		timer.Simple(0.1, function()
			net.Start("taxi_sendtruck_cl")
			net.WriteEntity(_v)
			net.Send(ply)
		end)
		ply:notify("You have taken out a Taxi")
	end)
	
	net.Receive('taxi_return', function(length, ply)
		local ent = ply.taxiEnt
		if (IsValid(ent)) then
			ent:Remove()
			ply:notify("Your Taxi has been returned.")
			net.Start("taxi_sendtruck_cl")
			net.WriteEntity(NULL)
			net.Send(ply)
		else
			ply:notify("You don't have a Taxi taken out.")
		end
	end)
	
	hook.Add("PlayerDisconnected", "Taxi::PlayerDisconnected", function(ply)
		local ent = ply.taxiEnt
		if (IsValid(ent)) then
			ent:Remove()
		end
	end)
	

	function ENT:OnTakeDamage()
	    return false
	end 
	

	function ENT:AcceptInput( Name, Activator, Caller )    
	    if Name == "Use" and Caller:IsPlayer() and team.GetName( Caller:Team() ) == "Berlin Taxis" then
		    net.Start("ui_taxi_hired_npc")
		    net.Send(Caller)
		else
		    net.Start("ui_taxi_npc")
		    net.Send(Caller)
	    end
	end
end



if (SERVER) then
	hook.Add("PlayerDisconnected", "RemoveTaxiOnLeave", function(ply)
		for k, v in pairs(ents.GetAll()) do
			if v:IsVehicle() and v:GetNWInt("Owner") == ply:EntIndex() and v:GetModel() == "models/left4dead/vehicles/taxi_old.mdl" then
				v:Remove()
			end
		end
	end)
	
	util.AddNetworkString("taxi_sendtruck_cl")
end