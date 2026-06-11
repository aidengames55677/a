-- "gamemodes\\mafiarp\\plugins\\npctrading\\cl_plugin.lua"


local PLUGIN = PLUGIN

-- Regular Panel
PLUGIN.Panel = nil

function PLUGIN:OpenPanel( recipes )
    self:ClosePanel()
    NPCTrading.Panel = vgui.Create( "NPCTrading" )
    NPCTrading.Panel:PopulateRecipes( recipes )
end

function PLUGIN:ClosePanel()
    if self.Panel then
        self.Panel:Remove()
        self.Panel = nil
    end
end

net.Receive( "NPCTrading.OpenTrader", function()
    PLUGIN:OpenPanel( net.ReadTable() )
end )

-- Recipes Panel
PLUGIN.RecipesPanel = nil

function PLUGIN:OpenRecipesPanel( recipes )
    self:CloseRecipesPanel()
    self.RecipesPanel = vgui.Create( "NPCTradingRecipes" )
    self.RecipesPanel:PopulateRecipes( recipes )
end

function PLUGIN:CloseRecipesPanel()
    if self.RecipesPanel then
        self.RecipesPanel:Remove()
        self.RecipesPanel = nil
    end
end

net.Receive( "NPCTrading.OpenRecipes", function()
    PLUGIN:OpenRecipesPanel( net.ReadTable() )
end )

-- Trader Edit Panel Panel
PLUGIN.TraderEditPanel = nil

function PLUGIN:OpenTraderEditPanel( trader, recipes, allRecipes )
    self:CloseTraderEditPanel()
    NPCTrading.TraderEditPanel = vgui.Create( "NPCTraderEdit" )
    NPCTrading.TraderEditPanel:PopulateRecipes( trader, recipes, allRecipes )
end

function PLUGIN:CloseTraderEditPanel()
    if self.TraderEditPanel then
        self.TraderEditPanel:Remove()
        self.TraderEditPanel = nil
    end
end

net.Receive( "NPCTrading.OpenTraderEdit", function()
    local trader = net.ReadEntity()
    local recipes = net.ReadTable()
    local allRecipes = net.ReadTable()
    PLUGIN:OpenTraderEditPanel( trader, recipes, allRecipes )
end )