AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

util.AddNetworkString("locker_menu_navy")

function ENT:Initialize()
self:SetModel( "models/props_c17/Lockers001a.mdl" )
self:SetHullType( HULL_HUMAN )
self:SetHullSizeNormal( )
self:SetNPCState( NPC_STATE_SCRIPT )
self:SetSolid( SOLID_BBOX )
self:CapabilitiesAdd( CAP_ANIMATEDFACE )
self:SetUseType( SIMPLE_USE )
--self:DropToFloorent()
 
end

function ENT:OnTakeDamage()
    return false
end 

local allowedFactions = {
	[FACTION_FEDS] = true,
	[FACTION_SWAT] = true,
	[FACTION_POLICE] = true,
	[FACTION_MIAMIGOV] = true,
	[FACTION_STAFF] = true
}
function ENT:AcceptInput( Name, Activator, Caller )    
    if Name == "Use" and Caller:IsPlayer() then
		if (allowedFactions[Caller:Team()]) then
	    	net.Start( "locker_menu_navy" ) net.Send( Caller )
		else
			Caller:notify("You cannot open this.")
		end
    end
end