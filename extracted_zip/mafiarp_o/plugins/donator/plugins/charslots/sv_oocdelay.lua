local nonDonator = "user"
local donatorOOCTime = 1

hook.Add("getOOCDelay", "checkForDonator", function(ply)
  if ply:GetUserGroup() != nonDonator then
	return donatorOOCTime
end
end)
