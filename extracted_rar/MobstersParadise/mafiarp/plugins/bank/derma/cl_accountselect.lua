-- "gamemodes\\mafiarp\\plugins\\bank\\derma\\cl_accountselect.lua"


local PANEL = {}

function PANEL:Init()
    self:SetTitle( "Select Account" )
    self:SetSize( 350, 350 )
    self:SetDraggable( false )
    self:Center()
    self:MakePopup()

    self.ScrollPanel = vgui.Create( "DScrollPanel", self )
    self.ScrollPanel:Dock( FILL )

    self.AccountButtons = {}
end

function PANEL:PopulateScrollPanel( accounts )
    for _, v in pairs( self.AccountButtons ) do
        v:Remove()
    end

    self.AccountButtons = {}

    for _, v in pairs( accounts ) do
        local btn = vgui.Create( "DButton", self.ScrollPanel )
        btn:Dock( TOP )
        btn:SetText( v.NAME and v.NAME .. " (#" .. v.BANK_ID .. ")" or "Account #" .. v.BANK_ID )
        btn.DoClick = function()
            net.Start( "Banking.ShowAccount" )
            net.WriteUInt( v.BANK_ID, 32 )
            net.SendToServer()
            self:Close()
        end

        table.insert( self.AccountButtons, btn )
    end
end

function PANEL:Think()
    if input.IsKeyDown( KEY_ESCAPE ) then
        RunConsoleCommand( "cancelselect" )
        self:Close()
    end
end

vgui.Register( "Banking.AccountSelect", PANEL, "DFrame" )