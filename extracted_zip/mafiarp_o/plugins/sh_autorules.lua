-- "gamemodes\\1942rp\\plugins\\sh_autorules.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
PLUGIN.name = "Anti Innocent Deathmatch"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "Anti Innocent Deathmatch."
PLUGIN.maxhardkilling = 50

-- THIS PLUGIN IS FUNCTIONAL
-- POSSIBLE MINOR BUGS MAY OCCUR
-- PLEASE REPORT.

function PLUGIN:EntityTakeDamage(  target, dmginfo )
	local attacker = dmginfo:GetAttacker()
	if attacker:IsPlayer() and target:IsPlayer() then
		target.dmglog = target.dmglog or {}
		local dmg =  dmginfo:GetDamage()
		target.dmglog[ attacker ] = target.dmglog[ attacker ] or 0
		target.dmglog[ attacker ] = ( target.dmglog[ attacker ] + dmg )
	--	print( tostring( attacker ) .. " - " .. target.dmglog[ attacker ] )
	end
end

local whitelist = {
	FACTION_ORPO,
}

function PLUGIN:PlayerDeath( ply, info, attacker )
	local tbllog = ply.dmglog or {} -- Damage log
	for att, amt in pairs( tbllog ) do
		if ( att == ply || !att:IsValid() ) then continue end
		 att.dmglog = att.dmglog  or {}
		local vicatt = att.dmglog[ ply ]  or 0 
		if ( amt  - vicatt ) > ply:GetMaxHealth() then
			
			if table.HasValue( whitelist, att:Team() ) then return end
			att.hardkilled = att.hardkilled or 0
			att.hardkilled = att.hardkilled + 1
			att:ChatPrint( "You killed someone who was causing no harm to you." )
			if att.hardkilled >= 50 then att:Ban( 10, "Exessive Hard Killing" ) att:Kick( "Exessive Hard Killing" ) end
			print( tostring( att:Name() ) .. " HARDKILLED " .. tostring( ply:Name() ) )
			
			att.dmglog[ ply ] = 0
			ply.dmglog = {}
			
		end
	end
end