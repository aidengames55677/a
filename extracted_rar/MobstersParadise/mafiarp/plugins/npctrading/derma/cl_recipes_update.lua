-- "gamemodes\\mafiarp\\plugins\\npctrading\\derma\\cl_recipes_update.lua"


local charset = "abcdefghijklmnopqrstuvwxyz_0123456789"

local PANEL = {}

function PANEL:Init()
    self:SetSize( 300, 475 )
    self:MakePopup()
    self:SetDrawOnTop( true )
    self:DoModal()
    self:SetDraggable( false )
    self:Center()
    self:SetTitle( "New Recipe" )

    self.IsEditing = false

    self.IDLabel = vgui.Create( "DLabel", self )
    self.IDLabel:Dock( TOP )
    self.IDLabel:SetText( "Unique Recipe ID" )

    self.IDEntry = vgui.Create( "DTextEntry", self )
    self.IDEntry:Dock( TOP )
    self.IDEntry:DockMargin( 5, 5, 5, 0 )
    self.IDEntry.AllowInput = function( _, char )
        return not string.find( charset, char, 1, true )
    end

    self.CooldownLabel = vgui.Create( "DLabel", self )
    self.CooldownLabel:Dock( TOP )
    self.CooldownLabel:SetText( "Cooldown in Seconds" )
    self.CooldownLabel:DockMargin( 0, 5, 0, 0 )

    self.CooldownEntry = vgui.Create( "DTextEntry", self )
    self.CooldownEntry:Dock( TOP )
    self.CooldownEntry:DockMargin( 5, 5, 5, 0 )
    self.CooldownEntry:SetNumeric( true )
    self.CooldownEntry:SetValue( 0 )

    self.InputLabel = vgui.Create( "DLabel", self )
    self.InputLabel:Dock( TOP )
    self.InputLabel:SetText( "Input Items" )
    self.InputLabel:DockMargin( 0, 5, 0, 0 )

    self.InputEntries = {}
    for i = 1, 4 do
        self.InputEntries[i] = vgui.Create( "DPanel", self )
        self.InputEntries[i]:Dock( TOP )
        self.InputEntries[i]:DockMargin( 5, 5, 5, 0 )

        self.InputEntries[i].Item = vgui.Create( "DTextEntry", self.InputEntries[i] )
        self.InputEntries[i].Item:Dock( FILL )
        self.InputEntries[i].Item.AllowInput = function( _, char )
            return not string.find( charset, char, 1, true )
        end

        self.InputEntries[i].Button = vgui.Create( "DButton", self.InputEntries[i] )
        self.InputEntries[i].Button:SetWide( 25 )
        self.InputEntries[i].Button:Dock( RIGHT )
        self.InputEntries[i].Button:SetText( "⟳" )
        self.InputEntries[i].Button.DoClick = function()
            self:OpenItemsList( true, i )
        end

        self.InputEntries[i].Count = vgui.Create( "DTextEntry", self.InputEntries[i] )
        self.InputEntries[i].Count:SetWide( 25 )
        self.InputEntries[i].Count:Dock( RIGHT )
        self.InputEntries[i].Count:SetNumeric( true )
    end

    local outputLabel = vgui.Create( "DLabel", self )
    outputLabel:Dock( TOP )
    outputLabel:SetText( "Output Items" )
    outputLabel:DockMargin( 0, 5, 0, 0 )

    self.OutputEntries = {}
    for i = 1, 4 do
        self.OutputEntries[i] = vgui.Create( "DPanel", self )
        self.OutputEntries[i]:Dock( TOP )
        self.OutputEntries[i]:DockMargin( 5, 5, 5, 0 )

        self.OutputEntries[i].Item = vgui.Create( "DTextEntry", self.OutputEntries[i] )
        self.OutputEntries[i].Item:Dock( FILL )
        self.OutputEntries[i].Item.AllowInput = function( _, char )
            return not string.find( charset, char, 1, true )
        end

        self.OutputEntries[i].Button = vgui.Create( "DButton", self.OutputEntries[i] )
        self.OutputEntries[i].Button:SetWide( 25 )
        self.OutputEntries[i].Button:Dock( RIGHT )
        self.OutputEntries[i].Button:SetText( "⟳" )
        self.OutputEntries[i].Button.DoClick = function()
            self:OpenItemsList( false, i )
        end

        self.OutputEntries[i].Count = vgui.Create( "DTextEntry", self.OutputEntries[i] )
        self.OutputEntries[i].Count:SetWide( 25 )
        self.OutputEntries[i].Count:Dock( RIGHT )
        self.OutputEntries[i].Count:SetNumeric( true )
    end

    self.UpdateButton = vgui.Create( "DButton", self )
    self.UpdateButton:Dock( TOP )
    self.UpdateButton:SetText( "Create" )
    self.UpdateButton:SetTall( 25 )
    self.UpdateButton:DockMargin( 5, 10, 5, 0 )
    self.UpdateButton.DoClick = function()
        self:UpdateRecipe()
    end

    self.CancelButton = vgui.Create( "DButton", self )
    self.CancelButton:Dock( TOP )
    self.CancelButton:SetText( "Cancel" )
    self.CancelButton:SetTall( 25 )
    self.CancelButton:DockMargin( 5, 3, 5, 0 )
    self.CancelButton.DoClick = function()
        self:Remove()
    end
end

function PANEL:OpenItemsList( isInput, index )
    if self.ItemsView then return end

    self.ItemsView = vgui.Create( "NPCTrading.ItemsView" )
    self.ItemsView.OnSelectItem = function( _, id )
        if isInput then
            self.InputEntries[index].Item:SetText( id )
        else
            self.OutputEntries[index].Item:SetText( id )
        end

        self.ItemsView = nil
    end
    self.ItemsView.OnRemove = function()
        self.ItemsView = nil
    end
end

function PANEL:OnRemove()
    if self.ItemsView then
        self.ItemsView:Remove()
        self.ItemsView = nil
    end
end

function PANEL:UpdateRecipe()
    local id, cooldown, inputs, outputs = "", 0, {}, {}

    id = tostring( self.IDEntry:GetValue() )
    cooldown = self.CooldownEntry:GetInt() or 0

    for k, v in pairs( self.InputEntries ) do
        local item, count = tostring( v.Item:GetValue() ), v.Count:GetInt() or 1

        if item and string.len( item ) >= 1 then
            inputs[item] = count
        end
    end

    for k, v in pairs( self.OutputEntries ) do
        local item, count = tostring( v.Item:GetValue() ), v.Count:GetInt() or 1

        if item and string.len( item ) >= 1 then
            outputs[item] = count
        end
    end

    if not NPCTrading:ValidateRecipeInfo( id, cooldown, inputs, outputs ) then return end

    if self.IsEditing then
        net.Start( "NPCTrading.EditRecipe" )
        net.WriteString( id )
        net.WriteUInt( cooldown, 32 )
        net.WriteTable( inputs )
        net.WriteTable( outputs )
        net.SendToServer()

        NPCTrading:CloseRecipesPanel()
    else
        net.Start( "NPCTrading.NewRecipe" )
        net.WriteString( id )
        net.WriteUInt( cooldown, 32 )
        net.WriteTable( inputs )
        net.WriteTable( outputs )
        net.SendToServer()

        NPCTrading:CloseRecipesPanel()
    end
end

function PANEL:SetRecipeInfo( recipe ) -- We call this if we are editing an existing recipe.
    self:SetTall( 505 ) -- Make space for the delete button.
    self:SetTitle( "Edit Recipe" )
    self.IsEditing = true

    self.IDEntry:SetText( recipe.ID )
    self.IDEntry:SetEditable( false )

    self.CooldownEntry:SetText( recipe.Cooldown )

    local i = 0
    for k, v in pairs( recipe.InputItems ) do
        i = i + 1

        self.InputEntries[i].Item:SetValue( k )
        self.InputEntries[i].Count:SetValue( v )
    end

    i = 0
    for k, v in pairs( recipe.OutputItems ) do
        i = i + 1

        self.OutputEntries[i].Item:SetValue( k )
        self.OutputEntries[i].Count:SetValue( v )
    end

    self.UpdateButton:SetText( "Edit" )

    self.DeleteButton = vgui.Create( "DButton", self )
    self.DeleteButton:Dock( TOP )
    self.DeleteButton:SetText( "Delete" )
    self.DeleteButton:SetTall( 25 )
    self.DeleteButton:DockMargin( 5, 3, 5, 0 )
    self.DeleteButton.DoClick = function()
        Derma_Query( "Are you sure you want to delete this recipe?", "Delete Recipe", "Yes", function()
            net.Start( "NPCTrading.DeleteRecipe" )
            net.WriteString( recipe.ID )
            net.SendToServer()
        end, "No" )
    end
end

function PANEL:Paint( w, h )
    draw.RoundedBox( 0, 0, 0, w, h, Color( 45, 45, 45 ) )
end

vgui.Register( "NPCTradingRecipes.Update", PANEL, "DFrame" )