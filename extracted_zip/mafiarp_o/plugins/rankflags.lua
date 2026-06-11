PLUGIN.name = "Rank Flags"
PLUGIN.desc = "Gives flags for certain ranks"
PLUGIN.author = "Robert Bearson"

local conf = {
	superadmin = "petrcPCULFdelnwybBma",
	network_owner = "petrcPCULFdelnwybBma",
	network_coowner = "petrcPCULFdelnwybBma",
	network_executive = "petrcPCULFdelnwybBma",
	head_developer = "petrcPCULFdelnwybBma",
	community_director = "petrcPCULFdelnwybBma",
	head_administrator = "petrcF",
	supervising_administrator = "petrcF",
	administrator = "petrcF",
	admin = "petrcF",
	moderator = "petrcF",
	trial_moderator = "petrcF",
	community_manager = "petrcF"
}

hook.Add("PlayerLoadedChar", "assignFlagsForRank", function(ply,char,oldChar)
	for k,v in pairs(conf) do
		if ply:IsUserGroup(k) then
			local cFlags = char:getFlags()
			if cFlags:find(v) then --Player already has the flags
				return
			end

			char:giveFlags(v) --Giving the flags
			return
		end
	end

	--No usergroup
	if not ply:IsAdmin() or ply:IsUserGroup("bronzevip") or ply:IsUserGroup("silvervip") or ply:IsUserGroup("goldvip")or ply:IsUserGroup("gamemaster") or ply:IsUserGroup("tmod") then
		print("Player isn't in any usergroup, removing flags")
		char:takeFlags("petnCr") --Taking flags if not in usergroup
	end
end)

--[[Restrict access to business tab
nut.flag.add("b", "Access to the business/black market tab") --Add the b flag
if CLIENT then

	hook.Add("BuildBusinessMenu","RestrictBusinessMenuAccess", function(panel)
		if LocalPlayer():getChar():getFlags():find("b") then
			return true
		end

		return false
	end)
end
]]