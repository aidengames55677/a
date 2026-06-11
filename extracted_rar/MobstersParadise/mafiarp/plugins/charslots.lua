-- "gamemodes\\mafiarp\\plugins\\charslots.lua"

PLUGIN.name = "Character Limit Per Rank"
PLUGIN.desc = "Set the character limit depending on the player's rank."
PLUGIN.author = "Robert Bearson"

local overrideCharLimit = {
	["founder"] = 100,
	["communitymanager"] = 100,
	["servermanager"] = 100,
	["advisor"] = 100,
	["headadministrator"] = 100,
	["superadministrator"] = 6,
	["senioradministrator"] = 6,
	["seasonedadministrator"] = 6,
	["administrator"] = 6,
	["moderator"] = 6,
	["eventmanager"] = 6,
	["donator"] = 5,
	["user"] = 2,
}

hook.Add("GetMaxPlayerCharacter", "returnRankCharLimit", function(ply)
	local rank = ply:GetNWString("usergroup", nil)
	local defchars = nut.config.get("maxChars", 2)
	local addSlots = ply:getNutData("CharacterSlots", 0)

	if not rank then return defchars end
	for group,slots in pairs(overrideCharLimit) do
		if rank == group then
			return slots + addSlots
		end
	end

	return defchars + addSlots
end)
