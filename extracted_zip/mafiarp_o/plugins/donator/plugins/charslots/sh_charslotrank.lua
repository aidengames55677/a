local overrideCharLimit = {
  ["superadmin"] = 10,
  ["admin"] = 2,
  ["moderator"] = 2,
  ["vip"] = 5,
  ["user"] = 2,
}

hook.Add("GetMaxPlayerCharacter", "returnRankCharLimit", function(ply)
	local function getOverrideChars()
		if ply:getNetVar("overrideSlots", nil) then
			return ply:getNetVar("overrideSlots")
		else
			return nut.config.get("maxChars")
		end
	end
	
	
	local function getRankChars()
		local defChars = nut.config.get("maxChars", 5)

		for group,slots in pairs(overrideCharLimit) do
			if group == ply:GetUserGroup() then
			  return slots
			end
		end
		return defChars
	end

	return math.max(nut.config.get("maxChars", 2), getOverrideChars(), getRankChars()) + ply:GetAdditionalCharSlots()
end)

