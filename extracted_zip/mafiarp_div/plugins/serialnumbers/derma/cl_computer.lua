-- "gamemodes\\mafiarp\\plugins\\serialnumbers\\derma\\cl_computer.lua"


local SerialNumberSearch
local PANEL = {}

function PANEL:Init()
    self:MakePopup()
    self:SetSize( 350, 300 )
    self:SetTitle( "Serial Number Search" )
    self:Center()

    self.OwnersList = vgui.Create( "DListView", self )
    self.OwnersList:Dock( FILL )
    self.OwnersList:AddColumn( "Name" )

    self.SearchPanel = vgui.Create( "DPanel", self )
    self.SearchPanel:Dock( BOTTOM )
    self.SearchPanel:SetTall( 25 )
    self.SearchPanel.Paint = function() end

    self.SearchPanel.TextEntry = vgui.Create( "DTextEntry", self.SearchPanel )
    self.SearchPanel.TextEntry:Dock( FILL )
    self.SearchPanel.TextEntry.AllowInput = function( _, char )
        if not string.find( "0123456789", tostring( char ) ) then return true end
    end

    self.SearchPanel.SearchButton = vgui.Create( "DButton", self.SearchPanel )
    self.SearchPanel.SearchButton:Dock( RIGHT )
    self.SearchPanel.SearchButton:SetText( "Search" )
    self.SearchPanel.SearchButton.DoClick = function()
        self.OwnersList:Clear()

        local serialNumber = self.SearchPanel.TextEntry:GetInt()

        if isnumber( serialNumber ) then
            net.Start( "SerialNumbers.OwnerRequest" )
            net.WriteUInt( serialNumber, 32 )
            net.SendToServer()
        end
    end

    self.InfoText = vgui.Create( "DLabel", self )
    self.InfoText:SetText( "Enter a serial number below to search owners" )
    self.InfoText:Dock( BOTTOM )
end

function PANEL:ReceiveData( data )
    self.OwnersList:Clear()

    for i = 1, #data do
        self.OwnersList:AddLine( data[i] )
    end
end

function PANEL:Think()
    if input.IsKeyDown( KEY_ESCAPE ) then
        RunConsoleCommand( "cancelselect" )
        self:Close()
    end
end

function PANEL:OnRemove()
    if SerialNumberSearch then
        SerialNumberSearch = nil
    end
end

vgui.Register( "SerialNumbersComputer", PANEL, "DFrame" )

net.Receive( "SerialNumbers.OpenComputer", function()
    if SerialNumberSearch then
        SerialNumberSearch:Close()
    end

    SerialNumberSearch = vgui.Create( "SerialNumbersComputer" )
end )

net.Receive( "SerialNumbers.OwnerRequest", function()
    if SerialNumberSearch then
        SerialNumberSearch:ReceiveData( net.ReadTable() )
    end
end )