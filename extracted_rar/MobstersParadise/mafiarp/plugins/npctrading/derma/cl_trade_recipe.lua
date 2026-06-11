-- "gamemodes\\mafiarp\\plugins\\npctrading\\derma\\cl_trade_recipe.lua"


local PANEL = {}

function PANEL:Init()
    local margin = 8

    self:SetTall( 65 )
    self:SetText( "=" )
    self:SetFont( "Trebuchet24" )

    self.InputPanels = {}
    self.OutputPanels = {}

    for i = 1, 4 do
        self.InputPanels[i] = vgui.Create( "NPCTrading.Recipe.Item", self )
        self.InputPanels[i]:Dock( LEFT )
        self.InputPanels[i]:SetWide( self:GetTall() - ( margin * 2 ) )
        self.InputPanels[i]:DockMargin( margin, margin, 0, margin )
    end

    for i = 1, 4 do
        self.OutputPanels[i] = vgui.Create( "NPCTrading.Recipe.Item", self )
        self.OutputPanels[i]:Dock( RIGHT )
        self.OutputPanels[i]:SetWide( self:GetTall() - ( margin * 2 ) )
        self.OutputPanels[i]:DockMargin( 0, margin, margin, margin )
    end
end

function PANEL:SetRecipe( recipe )
    local i = 4
    for k, v in pairs( recipe.InputItems ) do
        self.InputPanels[i]:SetModel( nut.item.list[k].model, nut.item.list[k].skin )
        self.InputPanels[i].Count = v

        i = i - 1
    end

    i = 4
    for k, v in pairs( recipe.OutputItems ) do
        self.OutputPanels[i]:SetModel( nut.item.list[k].model, nut.item.list[k].skin )
        self.OutputPanels[i].Count = v

        i = i - 1
    end

    local cooldowns = util.JSONToTable( LocalPlayer():getChar():getData( "trading_cooldowns", "[]" ) )
    if cooldowns[recipe.ID] then
        self:SetCooldownTime( cooldowns[recipe.ID] )
    end
end

function PANEL:Think()
    if self.CooldownTime and os.time() >= self.CooldownTime then
        self.CooldownTime = nil
        self:SetEnabled( true )
    end
end

local cooldownPanelColor = Color( 0, 0, 0, 250 )
function PANEL:PaintOver( w, h )
    if self.CooldownTime and os.time() < self.CooldownTime then
        draw.RoundedBox( 0, 0, 0, w, h, cooldownPanelColor )
        draw.SimpleText( "On Cooldown - " .. NPCTrading:FormatTime( self.CooldownTime - os.time(), "%02i:%02i:%02i" ) .. " Remaining", "Trebuchet18", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
end

function PANEL:SetCooldownTime( cooldownTime )
    self.CooldownTime = cooldownTime
    self:SetEnabled( false )
end

vgui.Register( "NPCTrading.Recipe", PANEL, "DButton" )