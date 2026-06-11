-- "gamemodes\\mafiarp\\plugins\\casinonpc\\cl_network.lua"


local PLUGIN = PLUGIN

net.Receive( "Casino.OpenMenu", function()
    local npc = net.ReadEntity()
    local perms = net.ReadUInt( 16 )

    if PLUGIN.Menu then
        PLUGIN.Menu:Remove()
    end

    PLUGIN.Menu = vgui.Create( "CasinoNPC" )
    PLUGIN.Menu:InitializeInfo( npc, perms )
end )

net.Receive( "Casino.OpenManageAdmins", function()
    local npc = net.ReadEntity()
    local users = net.ReadTable()

    local manageUsersPanel = vgui.Create( "Casino.ManageAdmins" )
    manageUsersPanel:PopulateListView( npc, users )
    manageUsersPanel.OnRemove = function()
        if PLUGIN.Menu and PLUGIN.Menu.PanelsToRemove then
            PLUGIN.Menu.PanelsToRemove[manageUsersPanel] = nil
        end
    end

    if PLUGIN.Menu then
        PLUGIN.Menu.PanelsToRemove[manageUsersPanel] = true
    end
end )

net.Receive( "Casino.OpenBannedUsers", function()
    local npc = net.ReadEntity()
    local bannedUsers = net.ReadTable()

    local bannedUsersPanel = vgui.Create( "Casino.BannedUsers" )
    bannedUsersPanel:PopulateListView( npc, bannedUsers )
    bannedUsersPanel.OnRemove = function()
        if PLUGIN.Menu and PLUGIN.Menu.PanelsToRemove then
            PLUGIN.Menu.PanelsToRemove[bannedUsersPanel] = nil
        end
    end

    if PLUGIN.Menu then
        PLUGIN.Menu.PanelsToRemove[bannedUsersPanel] = true
    end
end )

net.Receive( "Casino.OpenLogs", function()
    local logs = net.ReadTable()

    local logsPanel = vgui.Create( "Casino.Logs" )
    logsPanel:PopulateListView( logs )
    logsPanel.OnRemove = function()
        if PLUGIN.Menu and PLUGIN.Menu.PanelsToRemove then
            PLUGIN.Menu.PanelsToRemove[logsPanel] = nil
        end
    end

    if PLUGIN.Menu then
        PLUGIN.Menu.PanelsToRemove[logsPanel] = true
    end
end )

net.Receive( "Casino.OpenLeaderboard", function()
    local leaderboard = net.ReadTable()

    local leaderboardPanel = vgui.Create( "Casino.Leaderboard" )
    leaderboardPanel:PopulateListView( leaderboard )
    leaderboardPanel.OnRemove = function()
        if PLUGIN.Menu and PLUGIN.Menu.PanelsToRemove then
            PLUGIN.Menu.PanelsToRemove[leaderboardPanel] = nil
        end
    end

    if PLUGIN.Menu then
        PLUGIN.Menu.PanelsToRemove[leaderboardPanel] = true
    end
end )