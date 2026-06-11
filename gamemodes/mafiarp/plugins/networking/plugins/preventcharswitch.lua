local PLUGIN = PLUGIN
PLUGIN.name = "Prevent Character Switch"
PLUGIN.author = "rusty"
PLUGIN.desc = "Prevent players from switching characters after being damaged."

function PLUGIN:CanPlayerUseChar(client, character)
	if client.LastDamaged and client.LastDamaged > CurTime() - 180 and character:getFaction() != FACTION_STAFF and client:getChar() then
		return false, "You took or dealt damage too recently to switch characters!"	
	end
end

function PLUGIN:PlayerDisconnected(ply)
	local character = ply:getChar()
	if ply.LastDamaged and ply.LastDamaged > CurTime() - 180 and ply:getChar():getFaction() != FACTION_STAFF and ply:getChar() then
		SAdmin:AddLog("Connection", ply:Nick().." disconnected from the server whilst a damage cooldown was active.", ply:SteamID())
	end
end

function PLUGIN:EntityTakeDamage(ent, dmg)
	if !IsValid(ent) or !ent:IsPlayer() then return end

	local attacker = dmg:GetAttacker()

	if !dmg:IsFallDamage() and IsValid(attacker) and attacker:IsPlayer() and attacker != ent and ent:Team() != FACTION_STAFF then
		ent.LastDamaged = CurTime()
		attacker.LastDamaged = CurTime()
	end
end

PLUGIN.MultiCharacterExemption = {
	a_astaff = true,
	a_dea = true,
	a_fbi = true,
	a_government = true,
	a_government_state = true,
	a_police = true,
	citizen = true,
	a_ers = true,
	prisoner = true,
}

function PLUGIN:CanCharacterBeTransfered(character, faction, oldFaction)
	if !self.MultiCharacterExemption[faction.uniqueID] then
		for id,otherCharacter in next, nut.char.loaded do
			if otherCharacter.steamID == character.steamID and faction.index == otherCharacter:getFaction() then
				return false, "This player already has another character in this faction!"
			end
		end
	end

	local ply = character:getPlayer()
	if IsValid(ply) && ply:getNutData( "pdblacklisted", false ) && faction.uniqueID == "a_police" then
		return false, "This player is blacklisted from the PD!"
	end
end