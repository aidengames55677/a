-- "gamemodes\\mafiarp\\plugins\\bank\\derma\\cl_logs.lua"


local PLUGIN = PLUGIN
local PANEL = {}

function PANEL:Init()
    self:SetTitle( "View Logs" )
    self:SetSize( 840, 600 )
    self:SetDraggable( false )
    self:Center()
    self:MakePopup()

    self.ListView = vgui.Create( "DListView", self )
    self.ListView:Dock( FILL )

    self.ListView.OnRowRightClick = function( _, lineId, line )
        local menu = DermaMenu()

        menu:AddOption( "Copy Date", function()
            SetClipboardText( line:GetValue( 1 ) )
        end )

        menu:AddOption( "Copy Log", function()
            SetClipboardText( line:GetValue( 2 ) )
        end )

        menu:Open()
    end

    local dateColumn = self.ListView:AddColumn( "Date" )
    dateColumn:SetFixedWidth( 135 )

    self.ListView:AddColumn( "Log" )
end

function PANEL:PopulateListView( logs )
    self.ListView:Clear()

    for _, v in pairs( logs ) do
        self.ListView:AddLine( os.date( "%Y-%m-%d %H:%M:%S", tonumber( v.TIMESTAMP ) ), v.LOG )
    end

    self.ListView:SortByColumn( 1, true )
end

vgui.Register( "Banking.Logs", PANEL, "DFrame" )

net.Receive( "Banking.RequestLogs", function()
    local logs = net.ReadTable()

    local logsPanel = vgui.Create( "Banking.Logs" )
    logsPanel:PopulateListView( logs )
    logsPanel.OnRemove = function()
        if PLUGIN.ATM and PLUGIN.ATM.PanelsToRemove then
            PLUGIN.ATM.PanelsToRemove[logsPanel] = nil
        end
    end

    if PLUGIN.ATM then
        PLUGIN.ATM.PanelsToRemove[logsPanel] = true
    end
end )