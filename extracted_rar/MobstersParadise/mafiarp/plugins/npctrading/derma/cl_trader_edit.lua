-- "gamemodes\\mafiarp\\plugins\\npctrading\\derma\\cl_trader_edit.lua"


local function updateTraderInfo( trader, name, description, model )
    net.Start( "NPCTrading.UpdateTraderInfo" )
    net.WriteEntity( trader )
    net.WriteString( name or "Unnamed Trader" )
    net.WriteString( description or "" )
    net.WriteString( model or "models/player/suits/male_05_closed_tie.mdl" )
    net.SendToServer()
end

local PANEL = {}

function PANEL:Init()
    self:SetSize( 300, 450 )
    self:MakePopup()
    self:Center()
    self:SetTitle( "Edit Trader" )

    self.RecipesPanel = nil
    self.Trader = nil
    self.AllRecipes = nil
    self.Recipes = {}

    self.NamePanel = vgui.Create( "DPanel", self )
    self.NamePanel:Dock( TOP )
    self.NamePanel:DockMargin( 5, 5, 5, 5 )
    self.NamePanel.Paint = function() end

    self.NameLabel = vgui.Create( "DLabel", self.NamePanel )
    self.NameLabel:Dock( LEFT )
    self.NameLabel:SetText( "Name" )

    self.NameInput = vgui.Create( "DTextEntry", self.NamePanel )
    self.NameInput:Dock( FILL )
    self.NameInput:SetText( "Unnamed Trader" )
    self.NameInput.OnValueChange = function()
        if not IsValid( self.Trader ) then return end
        updateTraderInfo( self.Trader, self.NameInput:GetValue(), self.DescriptionInput:GetValue(), self.ModelInput:GetValue() )
    end

    self.DescriptionPanel = vgui.Create( "DPanel", self )
    self.DescriptionPanel:Dock( TOP )
    self.DescriptionPanel:DockMargin( 5, 5, 5, 5 )
    self.DescriptionPanel.Paint = function() end

    self.DescriptionLabel = vgui.Create( "DLabel", self.DescriptionPanel )
    self.DescriptionLabel:Dock( LEFT )
    self.DescriptionLabel:SetText( "Description" )

    self.DescriptionInput = vgui.Create( "DTextEntry", self.DescriptionPanel )
    self.DescriptionInput:Dock( FILL )
    self.DescriptionInput:SetText( "" )
    self.DescriptionInput.OnValueChange = function()
        if not IsValid( self.Trader ) then return end
        updateTraderInfo( self.Trader, self.NameInput:GetValue(), self.DescriptionInput:GetValue(), self.ModelInput:GetValue() )
    end

    self.ModelPanel = vgui.Create( "DPanel", self )
    self.ModelPanel:Dock( TOP )
    self.ModelPanel:DockMargin( 5, 5, 5, 5 )
    self.ModelPanel.Paint = function() end

    self.ModelLabel = vgui.Create( "DLabel", self.ModelPanel )
    self.ModelLabel:Dock( LEFT )
    self.ModelLabel:SetText( "Model" )

    self.ModelInput = vgui.Create( "DTextEntry", self.ModelPanel )
    self.ModelInput:Dock( FILL )
    self.ModelInput:SetText( "" )
    self.ModelInput.OnValueChange = function()
        if not IsValid( self.Trader ) then return end
        updateTraderInfo( self.Trader, self.NameInput:GetValue(), self.DescriptionInput:GetValue(), self.ModelInput:GetValue() )
    end

    self.RecipeListView = vgui.Create( "DListView", self )
    self.RecipeListView:Dock( FILL )
    self.RecipeListView:AddColumn( "Recipe ID" )
    self.RecipeListView.OnRowRightClick = function( _, lineId, line )
        local menu = DermaMenu()
        menu:AddOption( "Delete", function()
            if not IsValid( self.Trader ) then return end

            net.Start( "NPCTrading.RemoveRecipeFromTrader" )
            net.WriteEntity( self.Trader )
            net.WriteString( line.ID )
            net.SendToServer()

            self:Remove()
        end )
        menu:Open()
    end

    self.AddButton = vgui.Create( "DButton", self )
    self.AddButton:Dock( BOTTOM )
    self.AddButton:SetText( "Add" )
    self.AddButton.DoClick = function()
        if not self.Trader or not self.AllRecipes then return end

        self.RecipesPanel = vgui.Create( "DFrame" )
        self.RecipesPanel:MakePopup()
        self.RecipesPanel:SetDrawOnTop( true )
        self.RecipesPanel:SetTitle( "Recipes" )
        self.RecipesPanel:SetDraggable( false )
        self.RecipesPanel:DoModal()
        self.RecipesPanel:SetSize( 250, 235 )
        self.RecipesPanel:Center()

        local recipesScrollPanel = vgui.Create( "DScrollPanel", self.RecipesPanel )
        recipesScrollPanel:Dock( FILL )

        local recipePanels = {}

        local function populateRecipes( searchQuery )
            for k, v in pairs( recipePanels ) do
                v:Remove()
            end

            recipePanels = {}

            for k, v in pairs( self.AllRecipes ) do
                if self.Recipes[v] then continue end

                if searchQuery and searchQuery ~= "" and not string.find( string.lower( v ), string.lower( searchQuery ) ) then
                    continue
                end

                local recipePanel = vgui.Create( "DButton", recipesScrollPanel )
                recipePanel:Dock( TOP )
                recipePanel:DockMargin( 0, 2, 0, 0 )
                recipePanel:SetTall( 25 )
                recipePanel:SetText( v )
                recipePanel.DoClick = function()
                    if not IsValid( self.Trader ) then return end

                    net.Start( "NPCTrading.AddRecipeToTrader" )
                    net.WriteEntity( self.Trader )
                    net.WriteString( v )
                    net.SendToServer()

                    self:Remove()
                end

                table.insert( recipePanels, recipePanel )
            end
        end

        populateRecipes()

        local searchEntry = vgui.Create( "DTextEntry", self.RecipesPanel )
        searchEntry:Dock( BOTTOM )
        searchEntry:SetTall( 25 )
        searchEntry.OnChange = function()
            if self.Recipes then
                populateRecipes( searchEntry:GetValue() )
            end
        end
    end
end

function PANEL:PopulateRecipes( trader, recipes, allRecipes )
    self.Trader = trader
    self.Recipes = recipes
    self.AllRecipes = allRecipes

    self.RecipeListView:Clear()

    for k, v in pairs( recipes ) do
        local line = self.RecipeListView:AddLine( k )
        line.ID = k
    end

    self.NameInput:SetValue( self.Trader:GetTraderName() )
    self.DescriptionInput:SetValue( self.Trader:GetTraderDesc() )
    self.ModelInput:SetValue( self.Trader:GetModel() )
end

function PANEL:Think()
    if input.IsKeyDown( KEY_ESCAPE ) then
        self:Remove()
        RunConsoleCommand( "cancelselect" )
    end
end

function PANEL:OnClose()
    if not IsValid( self.Trader ) or not self.NameInput or not self.DescriptionInput then return end
    updateTraderInfo( self.Trader, self.NameInput:GetValue(), self.DescriptionInput:GetValue(), self.ModelInput:GetValue() )
end

function PANEL:OnRemove()
    NPCTrading.TraderEditPanel = nil

    if self.RecipesPanel then
        self.RecipesPanel:Remove()
    end
end

vgui.Register( "NPCTraderEdit", PANEL, "DFrame" )