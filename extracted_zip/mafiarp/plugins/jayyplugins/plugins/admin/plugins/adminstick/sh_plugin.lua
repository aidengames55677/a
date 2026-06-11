local PLUGIN = PLUGIN

PLUGIN.name = "Administrative Stick"
PLUGIN.author = "Anon"

PLUGIN.usergroups = {
    "superadmin",
    "network_owner",
    "network_coowner",
    "network_executive",
    "head_developer",
    "community_director",
    "supervising_administrator",
    "head_administrator",
    "administrator",
    "moderator",
    "trial_moderator",
    "admin",
    }

nut.util.include("cl_plugin.lua")

hook.Add("InitPostEntity","AdminStickAlwaysRaise",function()
end)

if SERVER then
    util.AddNetworkString("AS_ClearDecals")
    
    hook.Add( "PostPlayerLoadout", "Check Ranks", function(ply)
        if table.HasValue(PLUGIN.usergroups, ply:GetUserGroup()) then
            ply:Give("adminstick")
        end
    end)

    net.Receive("AS_ClearDecals", function(l, ply)
        if table.HasValue(PLUGIN.usergroups, ply:GetUserGroup()) then
            for k, v in ipairs(player.GetHumans()) do 
                v:ConCommand("r_cleardecals") 
            end
        end
    end)
end
