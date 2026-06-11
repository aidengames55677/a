-- "gamemodes\\mafiarp\\plugins\\casinonpc\\derma\\cl_casinonpc.lua"


surface.CreateFont( "CasinoLarge", {
    font = "Tahoma",
    weight = 1000,
    size = 23,
    bold = true
} )

surface.CreateFont( "CasinoBold", {
    font = "Tahoma",
    weight = 1000,
    size = 13,
    bold = true
} )

local PLUGIN = PLUGIN
local PANEL = {}

function PANEL:Init()
    self:SetTitle( "Casino NPC #0" )
    self:SetSize( 450, 285 )
    self:Center()
    self:MakePopup()
    self.PanelsToRemove = {}
end

function PANEL:HasPermission( perm )
    if not self.Permissions then return false end
    return PLUGIN:HasPermission( self.Permissions, perm )
end

function PANEL:HasActionPermissions()
    return PLUGIN:HasAnyPermission( self.Permissions, PLUGIN.Permissions.Deposit, PLUGIN.Permissions.Withdraw )
end

function PANEL:HasAdministrationPermissions()
    if not self.Permissions then return false end
    return PLUGIN:HasAnyPermission( self.Permissions, PLUGIN.Permissions.Manage, PLUGIN.Permissions.ViewLogs )
end

function PANEL:InitializeInfo( npc, perms )
    local name, balance, id = npc:GetCasinoName(), npc:GetBalance(), npc:GetCasinoID()

    self:SetTitle( ( name or "Casino NPC" ) .. " - ID #" .. id )
    self.AccountData = accountData
    self.Permissions = perms

    if not self:HasPermission( PLUGIN.Permissions.Access ) then
        self:Remove()
        return
    end

    -- Balance --
    self.BalanceLabel = vgui.Create( "DLabel", self )
    self.BalanceLabel:SetText( "Balance: $" .. string.Comma( balance ) )
    self.BalanceLabel:Dock( TOP )
    self.BalanceLabel:SetContentAlignment( 5 )
    self.BalanceLabel:SetFont( "CasinoLarge" )

    -- Actions --
    if self:HasActionPermissions() then
        self.ActionsLabel = vgui.Create( "DLabel", self )
        self.ActionsLabel:SetText( "Actions:" )
        self.ActionsLabel:Dock( TOP )
        self.ActionsLabel:DockMargin( 0, 5, 0, 0 )
        self.ActionsLabel:SetContentAlignment( 5 )
        self.ActionsLabel:SetFont( "CasinoBold" )

        if self:HasPermission( PLUGIN.Permissions.Deposit ) then
            self.DepositButton = vgui.Create( "DButton", self )
            self.DepositButton:SetText( "Deposit" )
            self.DepositButton:Dock( TOP )
            self.DepositButton:SetTall( 25 )
            self.DepositButton.DoClick = function()
                local pnl = Derma_StringRequest(
                    "Deposit",
                    "How much would you like to deposit?",
                    "",
                    function( amount )
                        amount = tonumber( amount )

                        if not isnumber( amount ) then
                            nut.util.notify( "That is not a valid number." )
                            return
                        end

                        if amount <= 0 then
                            nut.util.notify( "You must deposit more than $0." )
                            return
                        end

                        if amount > LocalPlayer():getChar():getMoney() then
                            nut.util.notify( "You do not have enough money to deposit that much." )
                            return
                        end

                        net.Start( "Casino.DepositRequest" )
                        net.WriteUInt( amount, 32 )
                        net.WriteEntity( npc )
                        net.SendToServer()

                        self:Close()
                    end,
                    nil,
                    "Deposit",
                    "Cancel"
                )

                pnl.OnRemove = function()
                    if self.PanelsToRemove then
                        self.PanelsToRemove[pnl] = nil
                    end
                end

                self.PanelsToRemove[pnl] = true
            end
        end

        if self:HasPermission( PLUGIN.Permissions.Withdraw ) then
            self.WithdrawButton = vgui.Create( "DButton", self )
            self.WithdrawButton:SetText( "Withdraw" )
            self.WithdrawButton:Dock( TOP )
            self.WithdrawButton:SetTall( 25 )
            self.WithdrawButton.DoClick = function()
                local pnl = Derma_StringRequest(
                    "Withdraw",
                    "How much would you like to withdraw?",
                    "",
                    function( amount )
                        amount = tonumber( amount )

                        if not isnumber( amount ) then
                            nut.util.notify( "That is not a valid number." )
                            return
                        end

                        if amount <= 0 then
                            nut.util.notify( "You must withdraw more than $0." )
                            return
                        end

                        if amount > npc:GetBalance() then
                            nut.util.notify( "There is not enough in the casino to withdraw that much." )
                            return
                        end

                        net.Start( "Casino.WithdrawRequest" )
                        net.WriteUInt( amount, 32 )
                        net.WriteEntity( npc )
                        net.SendToServer()

                        self:Close()
                    end,
                    nil,
                    "Withdraw",
                    "Cancel"
                )

                pnl.OnRemove = function()
                    if self.PanelsToRemove then
                        self.PanelsToRemove[pnl] = nil
                    end
                end

                self.PanelsToRemove[pnl] = true
            end
        end
    end

    -- Administration --
    if self:HasAdministrationPermissions() then
        self.AdministrationLabel = vgui.Create( "DLabel", self )
        self.AdministrationLabel:SetText( "Administration:" )
        self.AdministrationLabel:Dock( TOP )
        self.AdministrationLabel:DockMargin( 0, 5, 0, 0 )
        self.AdministrationLabel:SetContentAlignment( 5 )
        self.AdministrationLabel:SetFont( "CasinoBold" )

        if self:HasPermission( PLUGIN.Permissions.Manage ) then
            self.ManageUsersButton = vgui.Create( "DButton", self )
            self.ManageUsersButton:SetText( "Manage Admins" )
            self.ManageUsersButton:Dock( TOP )
            self.ManageUsersButton:SetTall( 25 )
            self.ManageUsersButton.DoClick = function()
                net.Start( "Casino.OpenManageAdmins" )
                net.WriteEntity( npc )
                net.SendToServer()
            end
        end

        if self:HasPermission( PLUGIN.Permissions.Manage ) then
            self.BannedUsersButton = vgui.Create( "DButton", self )
            self.BannedUsersButton:SetText( "Banned Users" )
            self.BannedUsersButton:Dock( TOP )
            self.BannedUsersButton:SetTall( 25 )
            self.BannedUsersButton.DoClick = function()
                net.Start( "Casino.OpenBannedUsers" )
                net.WriteEntity( npc )
                net.SendToServer()
            end
        end

        if self:HasPermission( PLUGIN.Permissions.ViewLogs ) then
            self.ViewLogsButton = vgui.Create( "DButton", self )
            self.ViewLogsButton:SetText( "View Logs" )
            self.ViewLogsButton:Dock( TOP )
            self.ViewLogsButton:SetTall( 25 )
            self.ViewLogsButton.DoClick = function()
                net.Start( "Casino.OpenLogs" )
                net.WriteEntity( npc )
                net.SendToServer()
            end
        end

        if self:HasPermission( PLUGIN.Permissions.ViewLogs ) then
            self.ViewLeaderboardButton = vgui.Create( "DButton", self )
            self.ViewLeaderboardButton:SetText( "View Leaderboard" )
            self.ViewLeaderboardButton:Dock( TOP )
            self.ViewLeaderboardButton:SetTall( 25 )
            self.ViewLeaderboardButton.DoClick = function()
                net.Start( "Casino.OpenLeaderboard" )
                net.WriteEntity( npc )
                net.SendToServer()
            end
        end

        if self:HasPermission( PLUGIN.Permissions.Manage ) then
            self.RenameButton = vgui.Create( "DButton", self )
            self.RenameButton:SetText( "Rename Casino" )
            self.RenameButton:Dock( TOP )
            self.RenameButton:SetTall( 25 )
            self.RenameButton.DoClick = function()
                local pnl = Derma_StringRequest(
                    "Rename",
                    "What would you like to rename this casino to?",
                    "",
                    function( newName )
                        newName = tostring( newName )

                        if #newName < 4 or #newName > 64 then
                            nut.util.notify( "Invalid length. Please choose something between 4-64 characters." )
                            return
                        end

                        net.Start( "Casino.RenameRequest" )
                        net.WriteString( newName )
                        net.WriteEntity( npc )
                        net.SendToServer()

                        self:Close()
                    end,
                    nil,
                    "Rename",
                    "Cancel"
                )

                pnl.OnRemove = function()
                    if self.PanelsToRemove then
                        self.PanelsToRemove[pnl] = nil
                    end
                end

                self.PanelsToRemove[pnl] = true
            end
        end
    end

    self:InvalidateLayout()
end

function PANEL:Think()
    if not self.WasEscapePressed and input.IsKeyDown( KEY_ESCAPE ) then
        RunConsoleCommand( "cancelselect" )

        local removedPanels = false
        for k in pairs( self.PanelsToRemove ) do
            if IsValid( k ) then
                k:Remove()
                removedPanels = true -- Let's prioritize panels over the main one when pressing escape, for better UX.
            end
        end

        if not removedPanels then
            self:Close()
        end

        self.WasEscapePressed = true
    elseif self.WasEscapePressed and not input.IsKeyDown( KEY_ESCAPE ) then
        self.WasEscapePressed = nil
    end
end

function PANEL:OnRemove()
    for k in pairs( self.PanelsToRemove ) do
        if IsValid( k ) then
            k:Remove()
        end
    end
end

vgui.Register( "CasinoNPC", PANEL, "DFrame" )