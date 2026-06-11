PLUGIN.name = "Character Limit Per Rank"
PLUGIN.desc = "Set the character limit depending on the player's rank."
PLUGIN.author = "Robert Bearson"

local overrideCharLimit = {
  ["founder"] = 10,
  ["diamond"] = 8,
  ["superadmin"] = 6,
  ["senioradmin"] = 5,
  ["admin"] = 4,
  ["moderator"] = 4,
  ["user"] = 2,
  ["plat"] = 5,
  ["gold"] = 4,
  ["silver"] = 4,
  ["bronze"] = 3
}

hook.Add("GetMaxPlayerCharacter", "returnRankCharLimit", function(ply)
	local rank = ply:GetUserGroup() //ply:GetNWString("usergroup", nil)
	local defchars = nut.config.get("maxChars", 2)

	if not rank then return defchars end
/*
  for group,slots in pairs(overrideCharLimit) do
    if rank == group then
      return slots
    end
  end
*/
  if overrideCharLimit[rank] then
    return overrideCharLimit[rank]
  end

  return defchars
end)