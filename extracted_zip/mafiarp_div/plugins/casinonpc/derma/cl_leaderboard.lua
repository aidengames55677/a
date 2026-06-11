-- "gamemodes\\mafiarp\\plugins\\casinonpc\\derma\\cl_leaderboard.lua"


local PLUGIN = PLUGIN
local PANEL = {}

function PANEL:Init()
    self:SetTitle( "Leaderboard" )
    self:SetSize( 700, 700 )
    self:SetDraggable( false )
    self:Center()
    self:MakePopup()

    self.ListView = vgui.Create( "DListView", self )
    self.ListView:Dock( FILL )

    self.ListView:AddColumn( "Rank" )
    self.ListView:AddColumn( "CharID" )
    self.ListView:AddColumn( "Name" )
    self.ListView:AddColumn( "User's Profit" )
    self.ListView:AddColumn( "Total Spent" )
    self.ListView:AddColumn( "Total Earned" )

    self.ListView:SortByColumn( 1, true )
end

function PANEL:PopulateListView( leaderboard )
    local casinoMenu = PLUGIN.Menu
    if not casinoMenu then return end

    self.NPC = npc
    self.Permissions = casinoMenu.Permissions

    self.ListView:Clear()

    for rank, data in ipairs( leaderboard ) do
        self.ListView:AddLine( tostring( rank ), tostring( data.CharID ), tostring( data.Name ), tostring( data.Profit ), tostring( data.MoneyOut ), tostring( data.MoneyIn ) )
    end
end

vgui.Register( "Casino.Leaderboard", PANEL, "DFrame" )