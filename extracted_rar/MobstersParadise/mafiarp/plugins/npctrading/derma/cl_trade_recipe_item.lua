-- "gamemodes\\mafiarp\\plugins\\npctrading\\derma\\cl_trade_recipe_item.lua"


local PANEL = {}

function PANEL:Init()
    self.Count = 1

    self:SetMouseInputEnabled( false )
    self:SetKeyboardInputEnabled( false )

    self.Icon = vgui.Create( "ModelImage", self )
    self.Icon:SetMouseInputEnabled( false )
    self.Icon:SetKeyboardInputEnabled( false )
    self.Icon:Dock( FILL )
    self.Icon:DockMargin( 5, 5, 5, 5 )
    self.Icon:SetVisible( false )
end

function PANEL:SetModel( model, skin )
    self.Icon:SetModel( model, skin or 0, "000000000" )
    self.Icon:SetVisible( true )
end

function PANEL:PaintOver( w, h )
    if self.Count > 1 then
        draw.SimpleTextOutlined( "x" .. self.Count, "DermaDefault", w - 5, h - 5, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, color_black )
    end
end

vgui.Register( "NPCTrading.Recipe.Item", PANEL, "DPanel" )