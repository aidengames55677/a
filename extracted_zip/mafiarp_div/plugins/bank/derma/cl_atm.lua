-- "gamemodes\\mafiarp\\plugins\\bank\\derma\\cl_atm.lua"


surface.CreateFont( "ATMLarge", {
    font = "Tahoma",
    weight = 1000,
    size = 23,
    bold = true
} )

surface.CreateFont( "ATMBold", {
    font = "Tahoma",
    weight = 1000,
    size = 13,
    bold = true
} )

local PLUGIN = PLUGIN
local PANEL = {}

function PANEL:Init()
    self:SetTitle( "Automated Teller Machine - Account #0" )
    self:SetSize( 450, 320 )
    self:Center()
    self:MakePopup()
    self.PanelsToRemove = {}
end

function PANEL:HasPermission( perm )
    if not self.Permissions then return false end
    return PLUGIN:HasPermission( self.Permissions, perm )
end

function PANEL:HasActionPermissions()
    return PLUGIN:HasAnyPermission( self.Permissions, PLUGIN.Permissions.Deposit, PLUGIN.Permissions.Withdraw, PLUGIN.Permissions.Transfer, PLUGIN.Permissions.ItemBank )
end

function PANEL:HasAdministrationPermissions()
    if not self.Permissions then return false end
    return PLUGIN:HasAnyPermission( self.Permissions, PLUGIN.Permissions.Manage, PLUGIN.Permissions.ViewLogs )
end

function PANEL:InitializeInfo( accountData, perms )
    self:SetTitle( ( accountData.NAME or "Automated Teller Machine" ) .. " - Account #" .. accountData.BANK_ID )
    self.AccountData = accountData
    self.Permissions = perms

    if not self:HasPermission( PLUGIN.Permissions.Access ) then
        self:Remove()
        return
    end

    -- Balance --
    self.BalanceLabel = vgui.Create( "DLabel", self )
    self.BalanceLabel:SetText( "Balance: $" .. string.Comma( accountData.BALANCE ) )
    self.BalanceLabel:Dock( TOP )
    self.BalanceLabel:SetContentAlignment( 5 )
    self.BalanceLabel:SetFont( "ATMLarge" )

    -- Actions --
    if self:HasActionPermissions() then
        self.ActionsLabel = vgui.Create( "DLabel", self )
        self.ActionsLabel:SetText( "Actions:" )
        self.ActionsLabel:Dock( TOP )
        self.ActionsLabel:DockMargin( 0, 5, 0, 0 )
        self.ActionsLabel:SetContentAlignment( 5 )
        self.ActionsLabel:SetFont( "ATMBold" )


        if self:HasPermission( PLUGIN.Permissions.Deposit ) then
            self.DepositButton = vgui.Create( "DButton", self )
            self.DepositButton:SetText( "Deposit" )
            self.DepositButton:Dock( TOP )
            self.DepositButton:SetTall( 25 )
            self.DepositButton.DoClick = function()
                if BankingMenuOpen then return end

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

                        net.Start( "Banking.DepositRequest" )
                        net.WriteUInt( amount, 32 )
                        net.WriteUInt( accountData.BANK_ID, 32 )
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
                if BankingMenuOpen then return end

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

                        if amount > accountData.BALANCE then
                            nut.util.notify( "There is not enough in the bank to withdraw that much." )
                            return
                        end

                        net.Start( "Banking.WithdrawalRequest" )
                        net.WriteUInt( amount, 32 )
                        net.WriteUInt( accountData.BANK_ID, 32 )
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

        if self:HasPermission( PLUGIN.Permissions.Transfer ) then
            self.TransferButton = vgui.Create( "DButton", self )
            self.TransferButton:SetText( "Transfer" )
            self.TransferButton:Dock( TOP )
            self.TransferButton:SetTall( 25 )
            self.TransferButton.DoClick = function()
                if BankingMenuOpen then return end

                local pnl = vgui.Create( "DFrame" )
                pnl:SetTitle( "Transfer" )
                pnl:SetSize( 300, 105 )
                pnl:Center()
                pnl:MakePopup()
                pnl:DoModal()
                pnl:SetDrawOnTop( true )
                pnl:SetBackgroundBlur( true )

                pnl.account = pnl:Add( "DTextEntry" )
                pnl.account:Dock( TOP )
                pnl.account:SetZPos( 1 )
                pnl.account:SetPlaceholderText( "Account ID" )
                pnl.account:SetNumeric( true )
                pnl.account:DockMargin( 0, 2, 0, 0 )

                pnl.entry = pnl:Add( "DTextEntry" )
                pnl.entry:Dock( TOP )
                pnl.entry:SetZPos( 2 )
                pnl.entry:SetPlaceholderText( "Transfer Amount" )
                pnl.entry:SetNumeric( true )
                pnl.entry:DockMargin( 0, 2, 0, 2 )

                pnl.btn = pnl:Add( "DButton" )
                pnl.btn:Dock( BOTTOM )
                pnl.btn:SetZPos( 3 )
                pnl.btn:SetText( "Transfer" )
                pnl.btn.DoClick = function()
                    if BankingMenuOpen then return end

                    local accountID = tonumber( pnl.account:GetText() )
                    local amount = tonumber( pnl.entry:GetText() )

                    if not accountID or accountID == accountData.BANK_ID then return end
                    if not amount or amount <= 0 or amount > accountData.BALANCE then 
                        nut.util.notify( "There is not enough money in the bank for that." )
                        return 
                    end

                    net.Start( "Banking.TransferRequest" )
                    net.WriteUInt( amount, 32 )
                    net.WriteUInt( accountData.BANK_ID, 32 )
                    net.WriteUInt( accountID, 32 )
                    net.SendToServer()

                    pnl:Close()
                    self:Close()
                end

                pnl.OnRemove = function()
                    if self.PanelsToRemove then
                        self.PanelsToRemove[pnl] = nil
                    end
                end

                self.PanelsToRemove[pnl] = true
            end
        end

        if self:HasPermission( PLUGIN.Permissions.ItemBank ) then
            self.ItemBankButton = vgui.Create( "DButton", self )
            self.ItemBankButton:SetText( "Item Bank" )
            self.ItemBankButton:Dock( TOP )
            self.ItemBankButton:SetTall( 25 )
            self.ItemBankButton.DoClick = function()
                if not accountData.ITEM_BANK then return end
                local itemBankInventory = nut.inventory.instances[accountData.ITEM_BANK]
                if not itemBankInventory then return end
                if BankingMenuOpen then return end

                BankingMenuOpen = true

                local itemBank = vgui.Create( "nutGridInventory" )
                local ownPanel = vgui.Create( "nutGridInventory" )

                ownPanel:setInventory( LocalPlayer():getChar():getInv() )
                ownPanel:ShowCloseButton( true )
                ownPanel:CenterHorizontal( 0.75 )
                ownPanel:CenterVertical()
                ownPanel.OnRemove = function()
                    if self.PanelsToRemove then
                        self.PanelsToRemove[ownPanel] = nil
                        self.PanelsToRemove[itemBank] = nil
                    end

                    if itemBank then
                        itemBank:Remove()
                    end
                end

                itemBank:setInventory( itemBankInventory )
                itemBank:SetTitle( "Item Bank" )
                itemBank:ShowCloseButton( true )
                itemBank:CenterHorizontal( 0.25 )
                itemBank:CenterVertical()
                itemBank.OnRemove = function()
                    if self.PanelsToRemove then
                        self.PanelsToRemove[ownPanel] = nil
                        self.PanelsToRemove[itemBank] = nil
                    end

                    if ownPanel then
                        ownPanel:Remove()
                    end

                    BankingMenuOpen = nil
                end

                self.PanelsToRemove[itemBank] = true
                self.PanelsToRemove[ownPanel] = true
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
        self.AdministrationLabel:SetFont( "ATMBold" )

        if self:HasPermission( PLUGIN.Permissions.Manage ) then
            self.ManageUsersButton = vgui.Create( "DButton", self )
            self.ManageUsersButton:SetText( "Manage Users" )
            self.ManageUsersButton:Dock( TOP )
            self.ManageUsersButton:SetTall( 25 )
            self.ManageUsersButton.DoClick = function()
                if BankingMenuOpen then return end

                net.Start( "Banking.OpenManageUsers" )
                net.WriteUInt( accountData.BANK_ID, 32 )
                net.SendToServer()
            end
        end

        if self:HasPermission( PLUGIN.Permissions.ViewLogs ) then
            self.ViewLogsButton = vgui.Create( "DButton", self )
            self.ViewLogsButton:SetText( "View Logs" )
            self.ViewLogsButton:Dock( TOP )
            self.ViewLogsButton:SetTall( 25 )
            self.ViewLogsButton.DoClick = function()
                if BankingMenuOpen then return end

                net.Start( "Banking.RequestLogs" )
                net.WriteUInt( accountData.BANK_ID, 32 )
                net.SendToServer()
            end
        end

        if self:HasPermission( PLUGIN.Permissions.Manage ) then
            self.RenameButton = vgui.Create( "DButton", self )
            self.RenameButton:SetText( "Rename Account" )
            self.RenameButton:Dock( TOP )
            self.RenameButton:SetTall( 25 )
            self.RenameButton.DoClick = function()
                if BankingMenuOpen then return end

                local pnl = Derma_StringRequest(
                    "Rename",
                    "What would you like to rename this account to?",
                    "",
                    function( name )
                        name = tostring( name )

                        if #name < 4 or #name > 64 then
                            nut.util.notify( "Invalid length. Please choose something between 4-64 characters." )
                            return
                        end

                        net.Start( "Banking.RenameRequest" )
                        net.WriteUInt( accountData.BANK_ID, 32 )
                        net.WriteString( name )
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

    self.RemoveButton = vgui.Create( "DButton", self )
    self.RemoveButton:SetText( "Remove Self Access" )
    self.RemoveButton:Dock( TOP )
    self.RemoveButton:SetTall( 25 )
    self.RemoveButton.DoClick = function()
        if BankingMenuOpen then return end

            local confirmPanel = Derma_Query(
                "Are you sure you want to remove your access to this bank? ",
                "Confirm Removal",
                "Yes",
                function()
                    net.Start( "Banking.SelfRemove" )
                        net.WriteUInt( accountData.BANK_ID, 32 )
                    net.SendToServer()
                end,
                "No"
            )

        self:Close()
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

vgui.Register( "Banking.ATM", PANEL, "DFrame" )