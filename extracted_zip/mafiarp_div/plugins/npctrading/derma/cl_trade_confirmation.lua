-- "gamemodes\\mafiarp\\plugins\\npctrading\\derma\\cl_trade_confirmation.lua"


local PANEL = {}

function PANEL:Init()
    self:MakePopup()
    self:SetDrawOnTop( true )
    self:DoModal()
    self:SetSize( 250, 235 )
    self:Center()

    self.TradingLabel = vgui.Create( "DLabel", self )
    self.TradingLabel:SetText( "You will lose:" )
    self.TradingLabel:SetFont( "Trebuchet18" )
    self.TradingLabel:SizeToContents()
    self.TradingLabel:Dock( TOP )
    self.TradingLabel:DockMargin( 5, 5, 0, 0 )
    self.TradingLabel:SetTextColor( color_white )

    self.TradingInputs = vgui.Create( "DLabel", self )
    self.TradingInputs:SetText( "" )
    self.TradingInputs:SetFont( "Trebuchet18" )
    self.TradingInputs:SizeToContents()
    self.TradingInputs:Dock( TOP )
    self.TradingInputs:DockMargin( 5, 0, 0, 0 )
    self.TradingInputs:SetTextColor( Color( 255, 0, 0 ) )

    self.ExchangeLabel = vgui.Create( "DLabel", self )
    self.ExchangeLabel:SetText( "In exchange for:" )
    self.ExchangeLabel:SetFont( "Trebuchet18" )
    self.ExchangeLabel:SizeToContents()
    self.ExchangeLabel:Dock( TOP )
    self.ExchangeLabel:DockMargin( 5, 5, 0, 0 )
    self.ExchangeLabel:SetTextColor( color_white )

    self.TradingOutputs = vgui.Create( "DLabel", self )
    self.TradingOutputs:SetText( "" )
    self.TradingOutputs:SetFont( "Trebuchet18" )
    self.TradingOutputs:SizeToContents()
    self.TradingOutputs:Dock( TOP )
    self.TradingOutputs:DockMargin( 5, 0, 0, 0 )
    self.TradingOutputs:SetTextColor( Color( 0, 255, 0 ) )

    self.Buttons = vgui.Create( "DPanel", self )
    self.Buttons:Dock( BOTTOM )
    self.Buttons:SetTall( 35 )
    self.Buttons:DockMargin( 5, 0, 5, 5 )
    self.Buttons.Paint = function() end

    self.Buttons.Confirm = vgui.Create( "DButton", self.Buttons )
    self.Buttons.Confirm:SetText( "Confirm" )
    self.Buttons.Confirm:SetWide( 120 )
    self.Buttons.Confirm:Dock( LEFT )
    self.Buttons.Confirm.DoClick = function()
        if not self.Recipe then return end

        net.Start( "NPCTrading.MakeTrade" )
        net.WriteString( self.Recipe )
        net.SendToServer()

        self:Remove()

        NPCTrading:ClosePanel()
    end

    self.Buttons.Cancel = vgui.Create( "DButton", self.Buttons )
    self.Buttons.Cancel:SetText( "Cancel" )
    self.Buttons.Cancel:SetWide( 120 )
    self.Buttons.Cancel:Dock( RIGHT )
    self.Buttons.Cancel.DoClick = function()
        self:Remove()
    end
end

function PANEL:SetRecipe( recipe )
    self.Recipe = recipe.ID

    local i, max = 0, table.Count( recipe.InputItems )
    local inputText = ""
    for k, v in pairs( recipe.InputItems ) do
        i = i + 1
        inputText = inputText .. v .. "x " .. nut.item.list[k].name .. ( i == max and "" or "\n" )
    end
    self.TradingInputs:SetText( inputText )
    self.TradingInputs:SizeToContents()

    i, max = 0, table.Count( recipe.OutputItems )
    local outputText = ""
    for k, v in pairs( recipe.OutputItems ) do
        i = i + 1
        outputText = outputText .. v .. "x " .. nut.item.list[k].name .. ( i == max and "" or "\n" )
    end
    self.TradingOutputs:SetText( outputText )
    self.TradingOutputs:SizeToContents()
end

function PANEL:Paint( w, h )
    draw.RoundedBox( 0, 0, 0, w, h, Color( 35, 35, 35 ) )
end

vgui.Register( "NPCTrading.Confirmation", PANEL, "EditablePanel" )