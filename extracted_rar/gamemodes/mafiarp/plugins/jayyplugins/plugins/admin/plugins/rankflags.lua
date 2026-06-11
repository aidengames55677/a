local PLUGIN = PLUGIN

PLUGIN.name = "Flag Control"
PLUGIN.desc = "Controls Flags"
PLUGIN.author = "JayyKashtaCodes"

local conf = {
	superadmin = "petrcPCULFdelnwybBma",
	network_owner = "petrcPCULFdelnwybBma",
	network_coowner = "petrcPCULFdelnwybBma",
	network_executive = "petrcPCULFdelnwybBma",
	head_developer = "petrcPCULFdelnwybBma",
	community_director = "petrcPCULFdelnwybBma",
	head_administrator = "petrcFP",
	supervising_administrator = "petrcFP",
	administrator = "petrcFP",
	admin = "petrcFP",
	moderator = "petrcFP",
	trial_moderator = "petrcFP",
	community_manager = "petrcFP",
	faction_leader = "petrFP",
	vip_plus = "petrP",
	vip = "petP"
}

-- Define the FlagFind function
function string.FlagFind(inp, str)
    if str=="" then return false end
    local found=true
    string.gsub(str, '.', function(c)
        if inp:find(c) and found then 
            found=true 
        else 
            found=false 
        end
    end)
    return found
end

-- Define the RemoveDuplicateFlags function
function string.RemoveDuplicateFlags(flags)
    local flagSet = {}
    local newFlags = ""
    string.gsub(flags, '.', function(c)
        if not flagSet[c] then 
            flagSet[c] = true
            newFlags = newFlags .. c
        end
    end)
    return newFlags
end

-- Use the FlagFind and RemoveDuplicateFlags functions
hook.Add("PlayerLoadedChar", "assignFlagsForRank", function(ply, char, oldChar)
    -- Store the player's current flags
    local currentFlags = char:getFlags()

    -- Remove duplicate flags
    local newFlags = currentFlags:RemoveDuplicateFlags()
    if newFlags ~= currentFlags then
        char:setFlags(newFlags)
    end

    -- Check user group and assign flags
    for k, v in pairs(conf) do
        if ply:IsUserGroup(k) then
            if not newFlags:FlagFind(v) then -- Player does not have the flags
                char:addFlags(v) -- Give the flags
            end
            break
        end
    end
end)
