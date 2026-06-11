-- "gamemodes\\mafiarp\\plugins\\casinonpc\\derma\\cl_bannedusers.lua"


local PLUGIN = PLUGIN
local PANEL = {}

function PANEL:Init()
    self:SetTitle( "Banned Users" )
    self:SetSize( 450, 450 )
    self:SetDraggable( false )
    self:Center()
    self:MakePopup()

    self.ListView = vgui.Create( "DListView", self )
    self.ListView:Dock( FILL )
    self.ListView.OnMousePressed = function( _, mb )
        if mb == MOUSE_RIGHT and PLUGIN:HasPermission( self.Permissions, PLUGIN.Permissions.Manage ) then
            local menu = DermaMenu()

            local banUser = menu:AddOption( "Ban User", function()
                Derma_StringRequest( "Ban User", "Please insert the CharID of the user you wish to ban from gambling.",
                "",
                function( charId )
                    charId = tonumber( charId )

                    if not charId or charId < 1 then
                        nut.util.notify( "That is not a valid CharID." )
                        return
                    end

                    if not self.NPC then
                        return
                    end

                    net.Start( "Casino.UpdateBannedStatus" )
                    net.WriteEntity( self.NPC )
                    net.WriteUInt( charId, 32 )
                    net.WriteBool( true )
                    net.SendToServer()

                    self:Close()
                end,
                function()
                end,
                "Ban User",
                "Cancel" )
            end )

            banUser:SetIcon( "icon16/user_delete.png" )

            menu:Open()
        end
    end

    self.ListView.OnRowRightClick = function( _, lineId, line )
        local charId = tonumber( line:GetValue( 1 ) )

        local menu = DermaMenu()

        local unbanUser = menu:AddOption( "Unban User", function()
            Derma_Query( "Are you sure you want to unban the user with CharID #" .. charId .. "?", "Unban User",
            "Yes",
            function()
                net.Start( "Casino.UpdateBannedStatus" )
                net.WriteEntity( self.NPC )
                net.WriteUInt( charId, 32 )
                net.WriteBool( false )
                net.SendToServer()
                self:Close()
            end,
            "No" )
        end )
        unbanUser:SetIcon( "icon16/user_add.png" )

        menu:Open()
    end

    self.ListView:AddColumn( "CharID" )
end

function PANEL:PopulateListView( npc, bannedUsers )
    local casinoMenu = PLUGIN.Menu
    if not casinoMenu then return end

    self.NPC = npc
    self.Permissions = casinoMenu.Permissions

    self.ListView:Clear()

    for charId, name in pairs( bannedUsers ) do
        self.ListView:AddLine( charId )
    end
end

vgui.Register( "Casino.BannedUsers", PANEL, "DFrame" )