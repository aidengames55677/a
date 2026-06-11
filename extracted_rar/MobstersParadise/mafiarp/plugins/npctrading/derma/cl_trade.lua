-- "gamemodes\\mafiarp\\plugins\\npctrading\\derma\\cl_trade.lua"


local PANEL = {}

function PANEL:Init()
    self:SetWide( 520 )
    self:MakePopup()
    self:SetTitle( "NPC Trading" )
    self.RecipePanels = {}
    self.Confirmation = nil
end

function PANEL:PopulateRecipes( recipes )
    for k, v in pairs( self.RecipePanels ) do
        v:Remove()
    end

    self.RecipePanels = {}

    local i = 0
    for k, v in pairs( recipes ) do
        i = i + 1

        self.RecipePanels[i] = vgui.Create( "NPCTrading.Recipe", self )
        self.RecipePanels[i]:Dock( TOP )
        self.RecipePanels[i]:DockMargin( 5, 5, 5, 0 )
        self.RecipePanels[i]:SetRecipe( v )
        self.RecipePanels[i].DoClick = function()
            self.Confirmation = vgui.Create( "NPCTrading.Confirmation" )
            self.Confirmation:SetRecipe( v )
        end
    end

    self:SetTall( i * 70 + 35 )
    self:Center()
end

function PANEL:Think()
    if input.IsKeyDown( KEY_ESCAPE ) then
        self:Remove()
        RunConsoleCommand( "cancelselect" )
    end
end

function PANEL:OnRemove()
    NPCTrading.Panel = nil

    if self.Confirmation then
        self.Confirmation:Remove()
    end
end

vgui.Register( "NPCTrading", PANEL, "DFrame" )