-- "gamemodes\\mafiarp\\plugins\\casinonpc\\sh_permissions.lua"


local PLUGIN = PLUGIN

PLUGIN.Permissions = {
    Access = bit.lshift( 1, 0 ), -- View Balance and Access Casino Menu
    Deposit = bit.lshift( 1, 1 ), -- Deposit to Casino
    Withdraw = bit.lshift( 1, 2 ), -- Withdraw from Casino
    Manage = bit.lshift( 1, 3 ), -- Manage Users + Rename Account
    ViewLogs = bit.lshift( 1, 4 ) -- View Logs + Leaderboard
}

function PLUGIN:HasPermission( perms, perm )
    return bit.band( perms, perm ) == perm
end

function PLUGIN:HasAnyPermission( perms, ... )
    for i = 1, select( "#", ... ) do
        local perm = select( i, ... )
        if self:HasPermission( perms, perm ) then
            return true
        end
    end

    return false
end

function PLUGIN:GrantPermissions( perms, ... )
    return bit.bor( perms, ... )
end

function PLUGIN:RemovePermission( perms, perm )
    return bit.band( perms, bit.bnot( perm ) )
end

function PLUGIN:GetAdminPerms()
    local perms = 0

    for _, v in pairs( self.Permissions ) do
        perms = self:GrantPermissions( perms, v )
    end

    return perms
end

function PLUGIN:GetFormattedPermissions( perms )
    if perms == self:GetAdminPerms() then
        return "Administrator"
    end

    local permList = {}
    for perm, permValue in SortedPairsByValue( self.Permissions ) do
        if permValue ~= self.Permissions.Access and self:HasPermission( perms, permValue ) then
            table.insert( permList, perm )
        end
    end

    return table.concat( permList, ", " )
end

function PLUGIN:GetAvailablePermissionsToAdd( perms, excludePerms )
    local availablePerms = {}

    for perm, permValue in pairs( self.Permissions ) do
        if excludePerms and not self:HasPermission( excludePerms, permValue ) then continue end
        if permValue ~= self.Permissions.Access and not self:HasPermission( perms, permValue ) then
            availablePerms[perm] = true
        end
    end

    return availablePerms
end

function PLUGIN:GetAvailablePermissionsToRemove( perms, excludePerms )
    local availablePerms = {}

    for perm, permValue in pairs( self.Permissions ) do
        if excludePerms and not self:HasPermission( excludePerms, permValue ) then continue end
        if permValue ~= self.Permissions.Access and self:HasPermission( perms, permValue ) then
            availablePerms[perm] = true
        end
    end

    return availablePerms
end

function PLUGIN:CanUpdatePermissionsToFollowing( perms, updatedPerms )
    if not self:HasPermission( perms, self.Permissions.Manage ) then
        return false
    end

    for _, permValue in pairs( self.Permissions ) do
        if self:HasPermission( updatedPerms, permValue ) and not self:HasPermission( perms, permValue ) then
            return false
        end
    end

    return true
end