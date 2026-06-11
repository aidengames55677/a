-- "gamemodes\\mafiarp\\plugins\\pkwar\\derma\\cl_warinfo.lua"


local PLUGIN = PLUGIN

local PANEL = {}

function PANEL:Init()
    self:SetTitle( "War Info" )
    self:SetSize( ScrW() * 0.3, ScrH() * 0.4 )
    self:ShowCloseButton( false )
    self:Center()
    self:MakePopup()

    self.Container = self:Add( "EditablePanel" )
    self.Container:Dock( FILL )
end

function PANEL:OnClose()
    if IsValid( PLUGIN.WarManagement ) then
        PLUGIN.WarManagement:Center()
    end
end

local function sendTeamUpdate( warID, isTeamOne, team )
    net.Start( "FactionWars.RequestModification" )
        net.WriteUInt( warID, 16 )
        net.WriteUInt( WAR_EDIT_FACTIONS, 4 )
        net.WriteBool( isTeamOne )

        for uniqueID, _ in next, team do
            local faction = nut.faction.teams[uniqueID]
            if !faction then continue end

            net.WriteUInt( faction.index, 8 )
        end
    net.SendToServer()
end

function PANEL:PopulateWarInfo( warId )
    local data = PLUGIN.Wars[warId]

    self:SetTitle( data.Name )

    local panel = self.Container
    panel:Clear()

    panel.WarName = panel:Add( "DTextEntry" )
    panel.WarName:SetZPos( 1 )
    panel.WarName:Dock( TOP )
    panel.WarName:SetText( data.Name )
    function panel.WarName:OnEnter( text )
        net.Start( "FactionWars.RequestModification" )
            net.WriteUInt( data.ID, 16 )
            net.WriteUInt( WAR_EDIT_NAME, 4 )
            net.WriteString( text )
        net.SendToServer()

        panel:GetParent():SetTitle( text )
    end

    panel.EndWar = panel:Add( "DButton" )
    panel.EndWar:SetZPos( 2 )
    panel.EndWar:Dock( TOP )
    panel.EndWar:SetTextColor( Color( 255,255,255 ) )
    panel.EndWar:SetText( "End War" )
    function panel.EndWar:DoClick()
        net.Start( "FactionWars.RequestDeletion" )
            net.WriteUInt( data.ID, 16 )
        net.SendToServer()

        panel:GetParent():Close()
    end

    panel.TeamOne = panel:Add( "DListView" )
    panel.TeamOne:SetZPos( 3 )
    panel.TeamOne:Dock( LEFT )
    panel.TeamOne:SetWide( panel:GetWide() * 0.2 )
    panel.TeamOne:AddColumn( "Faction" )
    panel.TeamOne:DockMargin( 0, 0, 4, 0 )
    function panel.TeamOne:OnRowSelected()
        panel.TeamTwo:ClearSelection()
    end
    function panel.TeamOne:OnRowRightClick( lineID, line )
        local factionID = line:GetColumnText( 1 )
        local menu = DermaMenu()
        local factionList = menu:AddSubMenu( "Add" )
        for uniqueID,faction in next, nut.faction.teams do
            if uniqueID == factionID then continue end
            if data.Team1[uniqueID] or data.Team2[uniqueID] then continue end

            factionList:AddOption( faction.name, function()
                self:AddLine( uniqueID )

                local teamTable = {}
                for k,v in next, self:GetLines() do
                    teamTable[v:GetColumnText( 1 )] = true
                end

                sendTeamUpdate( data.ID, true, teamTable )
                data.Team1[uniqueID] = true
            end )
        end

        if table.Count( data.Team1 ) > 1 then
            menu:AddOption( "Remove", function()
                self:RemoveLine( lineID )

                local teamTable = {}
                for k,v in next, self:GetLines() do
                    teamTable[v:GetColumnText( 1 )] = true
                end

                sendTeamUpdate( data.ID, true, teamTable )
                data.Team1[factionID] = nil
            end )
        end

        menu:Open()
    end

    for faction,_ in next, data.Team1 do
        panel.TeamOne:AddLine( faction )
    end

    panel.TeamTwo = panel:Add( "DListView" )
    panel.TeamTwo:SetZPos( 4 )
    panel.TeamTwo:Dock( LEFT )
    panel.TeamTwo:SetWide( panel:GetWide() * 0.2 )
    panel.TeamTwo:AddColumn( "Faction" )
    panel.TeamTwo:DockMargin( 0, 0, 4, 0 )
    function panel.TeamTwo:OnRowSelected()
        panel.TeamOne:ClearSelection()
    end
    function panel.TeamTwo:OnRowRightClick( lineID, line )
        local factionID = line:GetColumnText( 1 )
        local menu = DermaMenu()
        local factionList = menu:AddSubMenu( "Add" )
        for uniqueID,faction in next, nut.faction.teams do
            if uniqueID == factionID then continue end
            if data.Team1[uniqueID] or data.Team2[uniqueID] then continue end

            factionList:AddOption( faction.name, function()
                self:AddLine( uniqueID )

                local teamTable = {}
                for k,v in next, self:GetLines() do
                    teamTable[v:GetColumnText( 1 )] = true
                end

                sendTeamUpdate( data.ID, false, teamTable )
                data.Team2[uniqueID] = true
            end )
        end

        if table.Count( data.Team2 ) > 1 then
            menu:AddOption( "Remove", function()
                self:RemoveLine( lineID )

                local teamTable = {}
                for k,v in next, self:GetLines() do
                    teamTable[v:GetColumnText( 1 )] = true
                end

                sendTeamUpdate( data.ID, false, teamTable )
                data.Team2[factionID] = nil
            end )
        end

        menu:Open()
    end


    for faction,_ in next, data.Team2 do
        panel.TeamTwo:AddLine( faction )
    end

    panel.Killed = panel:Add( "DListView" )
    panel.Killed:SetZPos( 5 )
    panel.Killed:Dock( LEFT )
    panel.Killed:SetWide( panel:GetWide() * 0.6 )
    panel.Killed:AddColumn( "Victim" )
    panel.Killed:AddColumn( "Attacker" )
    function panel.Killed:OnRowRightClick( lineID, line )
        local menu = DermaMenu()
        menu:AddOption( "Copy Victim ID", function()
            SetClipboardText( tostring( line.VictimCharID ) )
        end )
        menu:AddOption( "Copy Attacker ID", function()
            SetClipboardText( tostring( line.AttackerCharID ) )
        end )
        menu:Open()
    end

    for id, killed in next, data.Killed do
        local line = panel.Killed:AddLine( killed.Name, killed.Attacker.Name )
        line.VictimCharID = id
        line.AttackerCharID = killed.Attacker.ID
    end
end

/*
    An explanation for this, as I just learned it recently: ( as displayed above )
    LuaJIT does not compile closures, while it hardly matters for UI, it'll be a good habit to build.

    http://wiki.luajit.org/NYI
    https://www.lua.org/pil/6.1.html
*/

local function ListOnMousePressed( self, keyCode )
    local otherTeam = self:GetParent()["Team" .. ( self.Team == 1 and "Two" or "One" )]

    if keyCode == MOUSE_RIGHT then
        local menu = DermaMenu()
        local factionList = menu:AddSubMenu( "Add" )
        for uniqueID,faction in next, nut.faction.teams do
            if self.Factions[uniqueID] or otherTeam.Factions[uniqueID] then continue end

            factionList:AddOption( faction.name, function()
                self:AddLine( uniqueID )
                self.Factions[uniqueID] = true
            end )
        end

        menu:Open()
    end
end

local function ListOnRowRightClicked( self, lineID, line )
    local otherTeam = self:GetParent()["Team" .. ( self.Team == 1 and "Two" or "One" )]
    local factionID = line:GetColumnText( 1 )
    local menu = DermaMenu()
    local factionList = menu:AddSubMenu( "Add" )

    for uniqueID,faction in next, nut.faction.teams do
        if uniqueID == factionID then continue end
        if otherTeam.Factions[uniqueID] or otherTeam.Factions[uniqueID] then continue end

        factionList:AddOption( faction.name, function()
            self:AddLine( uniqueID )
            self.Factions[uniqueID] = true
        end )
    end

    if table.Count( self.Factions ) > 1 then
        menu:AddOption( "Remove", function()
            self:RemoveLine( lineID )
            self.Factions[line:GetColumnText( 1 )] = nil
        end )
    end

    menu:Open()
end

local function CreateWarClicked( self )
    local panel = self:GetParent()

    local teamOneCount = table.Count( panel.TeamOne.Factions )
    local teamTwoCount = table.Count( panel.TeamTwo.Factions )

    if teamOneCount == 0 or teamTwoCount == 0 then
        nut.util.notify( "There are no factions in one of the teams!" )
        return
    end

    net.Start( "FactionWars.RequestCreation" )
        net.WriteString( panel.WarName:GetText() )

        net.WriteUInt( teamOneCount, 8 )
        for factionID,_ in next, panel.TeamOne.Factions do
            local faction = nut.faction.teams[factionID]
            if !faction then continue end

            net.WriteUInt( faction.index, 8 )
        end

        net.WriteUInt( teamTwoCount, 8 )
        for factionID,_ in next, panel.TeamTwo.Factions do
            local faction = nut.faction.teams[factionID]
            if !faction then continue end

            net.WriteUInt( faction.index, 8 )
        end
    net.SendToServer()

    panel:GetParent():Close()
end

function PANEL:CreateWar()
    self:SetTitle( "New War" )

    local panel = self.Container
    panel:Clear()

    panel.WarName = panel:Add( "DTextEntry" )
    panel.WarName:SetZPos( 1 )
    panel.WarName:Dock( TOP )
    panel.WarName:SetText( "New War" )
    panel.WarName:DockMargin( 0, 0, 0, 4 )

    panel.CreateWar = panel:Add( "DButton" )
    panel.CreateWar:SetZPos( 2 )
    panel.CreateWar:Dock( TOP )
    panel.CreateWar:SetText( "Create" )
    panel.CreateWar:DockMargin( 0, 0, 0, 4 )
    panel.CreateWar.DoClick = CreateWarClicked

    panel.TeamOne = panel:Add( "DListView" )
    panel.TeamOne:SetZPos( 3 )
    panel.TeamOne:Dock( LEFT )
    panel.TeamOne:InvalidateLayout( true )
    panel.TeamOne:SetWide( panel:GetWide() * 0.5 )
    panel.TeamOne:AddColumn( "Faction" )
    panel.TeamOne:DockMargin( 0, 0, 4, 0 )
    panel.TeamOne.OnMousePressed = ListOnMousePressed
    panel.TeamOne.OnRowRightClick = ListOnRowRightClicked
    panel.TeamOne.Factions = {}
    panel.TeamOne.Team = 1

    panel.TeamTwo = panel:Add( "DListView" )
    panel.TeamTwo:SetZPos( 4 )
    panel.TeamTwo:Dock( LEFT )
    panel.TeamTwo:InvalidateLayout( true )
    panel.TeamTwo:SetWide( panel:GetWide() * 0.5 )
    panel.TeamTwo:AddColumn( "Faction" )
    panel.TeamTwo.OnMousePressed = ListOnMousePressed
    panel.TeamTwo.OnRowRightClick = ListOnRowRightClicked
    panel.TeamTwo.Factions = {}
    panel.TeamTwo.Team = 2
end

vgui.Register( "FactionWars.WarInfo", PANEL, "DFrame" )