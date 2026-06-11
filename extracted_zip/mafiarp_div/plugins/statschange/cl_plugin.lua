-- "gamemodes\\mafiarp\\plugins\\statschange\\cl_plugin.lua"


local PLUGIN = PLUGIN

function PLUGIN:ChangeAttributes()
    local frame = vgui.Create( "DFrame" )
    frame:SetSize( 300, 200 )
    frame:Center()
    frame:SetTitle( "Attribute Selection" )
    frame:SetDraggable( false )
    
    local enduranceSlider = vgui.Create( "DNumSlider", frame )
    enduranceSlider:SetPos( 50, 50 )
    enduranceSlider:SetSize( 200, 20 )
    enduranceSlider:SetText( "Endurance" )
    enduranceSlider:SetMin( 0 )
    enduranceSlider:SetMax( 30 )
    enduranceSlider:SetDecimals( 0 )
    
    local staminaSlider = vgui.Create( "DNumSlider", frame )
    staminaSlider:SetPos( 50, 80 )
    staminaSlider:SetSize( 200, 20 )
    staminaSlider:SetText( "Stamina" )
    staminaSlider:SetMin( 0 )    
    staminaSlider:SetMax( 30 )
    staminaSlider:SetDecimals( 0 )
    
    local strengthSlider = vgui.Create( "DNumSlider", frame )
    strengthSlider:SetPos( 50, 110 )
    strengthSlider:SetSize( 200, 20 )
    strengthSlider:SetText( "Strength" )
    strengthSlider:SetMin( 0 )
    strengthSlider:SetMax( 30 )
    strengthSlider:SetDecimals( 0 )
    
    local submitButton = vgui.Create( "DButton", frame )
    submitButton:SetPos( 100, 150 )
    submitButton:SetSize( 100, 30 )
    submitButton:SetText( "Submit" )
    submitButton.DoClick = function()
        local endurancePoints = math.floor( enduranceSlider:GetValue() )
        local staminaPoints = math.floor( staminaSlider:GetValue() )
        local strengthPoints = math.floor( strengthSlider:GetValue() )
        local totalPoints = endurancePoints + staminaPoints + strengthPoints
        if totalPoints ~= 30 then
            nut.util.notify( "You have allocated more or less than 30 total points. Please adjust your selections." )
            return
        end

        local attributes = {
            endurance = endurancePoints,
            stamina = staminaPoints,
            strength = strengthPoints
        }
        
        Derma_Query(
            "You have selected " .. endurancePoints .. " Endurance, " .. staminaPoints .. " Stamina, and " .. strengthPoints .. " Strength. Once you change these, you cannot change them again on this character. Are you sure?", 
            "Confirmation of Attribute Change",
            "Yes",
            function()
                net.Start( "StatsChange.Attributes" )
                    net.WriteTable( attributes )
                net.SendToServer()
                frame:Close()
            end,
            "No" 
        )
    end
    
    frame:MakePopup()
end

function PLUGIN:ChangeHeight()
    local frame = vgui.Create( "DFrame" )
    frame:SetSize( 200, 150 )
    frame:Center()
    frame:SetTitle( "Height Selection" )
    frame:SetDraggable( false )
    
    local dropdown = vgui.Create( "DComboBox", frame )
    dropdown:SetPos( 50, 50 )
    dropdown:SetSize( 100, 20 )
        
    for _, option in ipairs( PLUGIN.HeightOptions ) do
        dropdown:AddChoice( option )
    end
    
    local submitButton = vgui.Create( "DButton", frame )
    submitButton:SetPos( 50, 100 )
    submitButton:SetSize( 100, 30 )
    submitButton:SetText( "Submit" )
    submitButton.DoClick = function()
        local selectedHeight = dropdown:GetSelected()
        if !selectedHeight then return end

        Derma_Query(
            "You have selected " .. selectedHeight .. " as your desired height. Once you change it, you cannot change it again on this character. Are you sure?", 
            "Confirmation of Height Change",
            "Yes",
            function()
                net.Start( "StatsChange.Height" )
                    net.WriteString( selectedHeight )
                net.SendToServer()
                frame:Close()
            end,
            "No" 
        )
    end

    frame:MakePopup()
end