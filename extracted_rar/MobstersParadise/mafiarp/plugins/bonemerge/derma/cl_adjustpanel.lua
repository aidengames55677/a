-- "gamemodes\\mafiarp\\plugins\\bonemerge\\derma\\cl_adjustpanel.lua"


local PANEL = {}

function PANEL:Init()
    self:SetTitle( "Adjust Item" )
    self:SetSize( 210, 155 )
    self:MakePopup()
    self:Center()
    self:SetDrawOnTop( true )
    self:DoModal( true )

    self.XSlider = vgui.Create( "DNumSlider", self )
    self.XSlider:Dock( TOP )
    self.XSlider:SetText( "X Offset" )
    self.XSlider:SetMin( -5 )
    self.XSlider:SetMax( 5 )
    self.XSlider:SetDecimals( 2 )
    self.XSlider:SetValue( 0 )
    self.XSlider:DockMargin( 5, 0, 5, 0 )

    self.YSlider = vgui.Create( "DNumSlider", self )
    self.YSlider:Dock( TOP )
    self.YSlider:SetText( "Y Offset" )
    self.YSlider:SetMin( -5 )
    self.YSlider:SetMax( 5 )
    self.YSlider:SetDecimals( 2 )
    self.YSlider:SetValue( 0 )
    self.YSlider:DockMargin( 5, 0, 5, 0 )

    self.ZSlider = vgui.Create( "DNumSlider", self )
    self.ZSlider:Dock( TOP )
    self.ZSlider:SetText( "Z Offset" )
    self.ZSlider:SetMin( -5 )
    self.ZSlider:SetMax( 5 )
    self.ZSlider:SetDecimals( 2 )
    self.ZSlider:SetValue( 0 )
    self.ZSlider:DockMargin( 5, 0, 5, 0 )

    self.Buttons = vgui.Create( "DPanel", self )
    self.Buttons:Dock( BOTTOM )
    self.Buttons.Paint = function()
    end

    self.Buttons.Save = vgui.Create( "DButton", self.Buttons )
    self.Buttons.Save:Dock( LEFT )
    self.Buttons.Save:SetText( "Save" )
    self.Buttons.Save:SetWide( 65 )
    self.Buttons.Save.DoClick = function()
        self:Close()
    end

    self.Buttons.Reset = vgui.Create( "DButton", self.Buttons )
    self.Buttons.Reset:Dock( FILL )
    self.Buttons.Reset:SetText( "Reset" )
    self.Buttons.Reset.DoClick = function()
        self.XSlider:SetValue( 0 )
        self.YSlider:SetValue( 0 )
        self.ZSlider:SetValue( 0 )
    end

    self.Buttons.Cancel = vgui.Create( "DButton", self.Buttons )
    self.Buttons.Cancel:Dock( RIGHT )
    self.Buttons.Cancel:SetText( "Cancel" )
    self.Buttons.Cancel:SetWide( 65 )
    self.Buttons.Cancel.DoClick = function()
        self:Close()
    end
end

vgui.Register( "Bonemerge.AdjustPanel", PANEL, "DFrame" )