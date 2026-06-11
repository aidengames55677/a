local PLUGIN = PLUGIN
PLUGIN.name = "Admin Drawing"
PLUGIN.author = "Gen"
PLUGIN.desc = "Shows above the head if they are an admin or not using usergroups."
 
if (CLIENT) then
    local NETWORKMANAGEMENT = Color(102, 0, 204)
    local DEVELOPMENT = Color(51, 204, 51)
    local SERVERMANAGEMENT = Color(255, 51, 0)
    local UPPERADMINISTRATION = Color(255, 255, 0)
    local ADMINISTRATION = Color(0, 102, 204)
    local MODERATION = Color(102, 255, 204)

    hook.Add( "DrawCharInfo", "DrawCharInfoStaff", function( client, character, info )
        if (client:Team() == FACTION_STAFF) then

            if (client:IsUserGroup("superadmin")) then
                info[#info + 1] = {"Network Management", NETWORKMANAGEMENT}
            end

            if (client:IsUserGroup("network_owner")) then
                info[#info + 1] = {"Network Management", NETWORKMANAGEMENT}
            end

            if (client:IsUserGroup("network_coowner")) then
                info[#info + 1] = {"Network Management", NETWORKMANAGEMENT}
            end

            if (client:IsUserGroup("network_executive")) then
                info[#info + 1] = {"Network Management", NETWORKMANAGEMENT}
            end

            if (client:IsUserGroup("head_developer")) then
                info[#info + 1] = {"Network Management", DEVELOPMENT}
            end

            if (client:IsUserGroup("community_director")) then
                info[#info + 1] = {"Server Management", SERVERMANAGEMENT}
            end

            if (client:IsUserGroup("head_administrator")) then
                info[#info + 1] = {"Upper Administration", UPPERADMINISTRATION}
            end

            if (client:IsUserGroup("supervising_administrator")) then
                info[#info + 1] = {"Upper Administration", UPPERADMINISTRATION}
            end

            if (client:IsUserGroup("administrator")) then
                info[#info + 1] = {"Administration", ADMINISTRATION}
            end

            if (client:IsUserGroup("admin")) then
                info[#info + 1] = {"Administration", ADMINISTRATION}
            end

            if (client:IsUserGroup("moderator")) then
                info[#info + 1] = {"Moderation", MODERATION}
            end

            if (client:IsUserGroup("trial_moderator")) then
                info[#info + 1] = {"Moderation", MODERATION}
            end
            
            if (client:IsUserGroup("community_manager")) then
                info[#info + 1] = {"Game Masters", MODERATION}
            end
        end
    end )
end