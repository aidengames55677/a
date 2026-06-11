-- "gamemodes\\mafiarp\\plugins\\npctrading\\derma\\cl_recipes.lua"


local PANEL = {}

function PANEL:Init()
    self:SetSize( 300, 250 )
    self:MakePopup()
    self:SetTitle( "NPC Trading Admin - Recipes" )
    self.UpdateRecipePanel = nil

    self.ScrollPanel = vgui.Create( "DScrollPanel", self )
    self.ScrollPanel:Dock( FILL )

    self.RecipePanels = {}

    local newButton = vgui.Create( "DButton", self )
    newButton:Dock( BOTTOM )
    newButton:SetTall( 30 )
    newButton:SetText( "Create New Recipe" )
    newButton:DockMargin( 0, 10, 0, 0 )
    newButton.DoClick = function()
        self.UpdateRecipePanel = vgui.Create( "NPCTradingRecipes.Update" )
    end

    local searchEntry = vgui.Create( "DTextEntry", self )
    searchEntry:Dock( BOTTOM )
    searchEntry:SetTall( 25 )
    searchEntry.OnChange = function()
        if self.Recipes then
            self:PopulateRecipes( self.Recipes, searchEntry:GetValue() )
        end
    end

    self:Center()
end

function PANEL:PopulateRecipes( recipes, searchQuery )
    if recipes then
        self.Recipes = recipes
    else
        recipes = self.Recipes
    end

    for k, v in pairs( self.RecipePanels ) do
        v:Remove()
    end

    self.RecipePanels = {}

    for k, v in pairs( recipes ) do
        if searchQuery and searchQuery ~= "" and not string.find( string.lower( v.ID ), string.lower( searchQuery ) ) then
            continue
        end

        local recipePanel = vgui.Create( "DButton", self.ScrollPanel )
        recipePanel:Dock( TOP )
        recipePanel:DockMargin( 0, 2, 0, 0 )
        recipePanel:SetTall( 25 )
        recipePanel:SetText( v.ID )
        recipePanel.DoClick = function()
            self.UpdateRecipePanel = vgui.Create( "NPCTradingRecipes.Update" )
            self.UpdateRecipePanel:SetRecipeInfo( v )
        end

        table.insert( self.RecipePanels, recipePanel )
    end
end

function PANEL:Think()
    if input.IsKeyDown( KEY_ESCAPE ) then
        self:Remove()
        RunConsoleCommand( "cancelselect" )
    end
end

function PANEL:OnRemove()
    NPCTrading.RecipesPanel = nil

    if self.UpdateRecipePanel then
        self.UpdateRecipePanel:Remove()
    end
end

vgui.Register( "NPCTradingRecipes", PANEL, "DFrame" )