-- "gamemodes\\mafiarp\\plugins\\bank\\derma\\cl_manageusers.lua"


local PLUGIN = PLUGIN
local PANEL = {}

function PANEL:Init()
    self:SetTitle( "Manage Users" )
    self:SetSize( 450, 450 )
    self:SetDraggable( false )
    self:Center()
    self:MakePopup()

    self.ListView = vgui.Create( "DListView", self )
    self.ListView:Dock( FILL )
    self.ListView.OnMousePressed = function( _, mb )
        if mb == MOUSE_RIGHT and PLUGIN:HasPermission( self.Permissions, PLUGIN.Permissions.Manage ) then
            local menu = DermaMenu()

            local addUser = menu:AddOption( "Add User", function()
                Derma_StringRequest( "Add User", "Please insert the CharID of the user you wish to add.",
                "",
                function( charId )
                    charId = tonumber( charId )

                    if not charId or charId < 1 then
                        nut.util.notify( "That is not a valid CharID." )
                        return
                    end

                    if not self.BankID then
                        return
                    end

                    net.Start( "Banking.AddUser" )
                    net.WriteUInt( self.BankID, 32 )
                    net.WriteUInt( charId, 32 )
                    net.SendToServer()

                    self:Close()
                end,
                function()
                end,
                "Add User",
                "Cancel" )
            end )

            addUser:SetIcon( "icon16/user_add.png" )

            menu:Open()
        end
    end

    self.ListView.OnRowRightClick = function( _, lineId, line )
        if not line.Manageable then return end

        local charId = tonumber( line:GetValue( 1 ) )
        local perms = tonumber( line:GetSortValue( 2 ) )

        local menu = DermaMenu()

        local addablePerms = PLUGIN:GetAvailablePermissionsToAdd( perms, self.Permissions )

        if table.Count( addablePerms ) > 0 then
            local addPermMenu, addPerm = menu:AddSubMenu( "Add Permission" )
            addPerm:SetIcon( "icon16/add.png" )

            for perm in pairs( addablePerms ) do
                addPermMenu:AddOption( perm, function()
                    net.Start( "Banking.UpdatePermissions" )
                    net.WriteUInt( self.BankID, 32 )
                    net.WriteUInt( charId, 32 )
                    net.WriteUInt( PLUGIN:GrantPermissions( perms, PLUGIN.Permissions[perm] ), 32 )
                    net.SendToServer()
                    self:Close()
                end )
            end
        end

        local removablePerms = PLUGIN:GetAvailablePermissionsToRemove( perms, self.Permissions )

        if table.Count( removablePerms ) > 0 then
            local removePermMenu, removePerm = menu:AddSubMenu( "Remove Permission" )
            removePerm:SetIcon( "icon16/delete.png" )

            for perm in pairs( removablePerms ) do
                removePermMenu:AddOption( perm, function()
                    net.Start( "Banking.UpdatePermissions" )
                    net.WriteUInt( self.BankID, 32 )
                    net.WriteUInt( charId, 32 )
                    net.WriteUInt( PLUGIN:RemovePermission( perms, PLUGIN.Permissions[perm] ), 32 )
                    net.SendToServer()
                    self:Close()
                end )
            end
        end

        if #addablePerms > 0 or #removablePerms > 0 then
            menu:AddSpacer()
        end

        local kickUser = menu:AddOption( "Kick User", function()
            Derma_Query( "Are you sure you want to kick the user with CharID #" .. charId .. "?", "Kick User",
            "Yes",
            function()
                net.Start( "Banking.RemoveUser" )
                net.WriteUInt( self.BankID, 32 )
                net.WriteUInt( charId, 32 )
                net.SendToServer()
                self:Close()
            end,
            "No" )
        end )
        kickUser:SetIcon( "icon16/user_delete.png" )

        menu:Open()
    end

    local charIdColumn = self.ListView:AddColumn( "CharID" )
    charIdColumn:SetFixedWidth( 65 )

    self.ListView:AddColumn( "Permissions" )
end

function PANEL:PopulateListView( bankId, users )
    local atmPanel = PLUGIN.ATM
    if not atmPanel then return end
    local accountData = atmPanel.AccountData
    if not accountData or not accountData.OWNER then return end

    self.BankID = bankId
    self.Permissions = atmPanel.Permissions

    self.ListView:Clear()

    for _, v in pairs( users ) do
        if v.LINKED_BANK ~= bankId then continue end

        local formattedPerms = PLUGIN:GetFormattedPermissions( v.PERMISSIONS )

        if v.CHARID == accountData.OWNER then
            formattedPerms = "Owner"
        end

        local line = self.ListView:AddLine( v.CHARID, formattedPerms )
        line:SetSortValue( 2, v.PERMISSIONS )
        line.Manageable = LocalPlayer():getChar():getID() ~= v.CHARID and v.CHARID ~= accountData.OWNER
    end

    self.ListView:SortByColumn( 2, true )
end

vgui.Register( "Banking.ManageUsers", PANEL, "DFrame" )

net.Receive( "Banking.OpenManageUsers", function()
    local bankId = net.ReadUInt( 32 )
    local users = net.ReadTable()

    local manageUsersPanel = vgui.Create( "Banking.ManageUsers" )
    manageUsersPanel:PopulateListView( bankId, users )
    manageUsersPanel.OnRemove = function()
        if PLUGIN.ATM and PLUGIN.ATM.PanelsToRemove then
            PLUGIN.ATM.PanelsToRemove[manageUsersPanel] = nil
        end
    end

    if PLUGIN.ATM then
        PLUGIN.ATM.PanelsToRemove[manageUsersPanel] = true
    end
end )