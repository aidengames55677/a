-- "gamemodes\\mafiarp\\plugins\\statschange\\entities\\entities\\statschange_npc\\cl_init.lua"

include( "shared.lua" )

local PLUGIN = PLUGIN

local TEXT_OFFSET = Vector( 0, 0, 20 )
local toScreen = FindMetaTable( "Vector" ).ToScreen
local colorAlpha = ColorAlpha
local drawText = nut.util.drawText
local configGet = nut.config.get

ENT.DrawEntityInfo = true

function ENT:onDrawEntityInfo( alpha )
    local position = toScreen( self:LocalToWorld( self:OBBCenter() ) + TEXT_OFFSET)
    local x, y = position.x, position.y

    drawText( "Surgeon Adrian White", x, y, colorAlpha(configGet( "color" ), alpha), 1, 1, nil, alpha * 0.65 )
    drawText( "Want to enhance your physicality?", x, y + 16, colorAlpha( color_white, alpha ), 1, 1, "nutSmallFont", alpha * 0.65 )
end

ENT.NPC_INFORMATION = {
    name = "Adrian White",
    profession = "Surgeon; New York Hospital",
    model = "models/kerry/medic_ag/male_06.mdl",
}

ENT.NPC_CONVERSATION = {
    opening = {
        response = "Hello, what can I do for you?",
        options = {
            "changeattributes",
            "changelanguages",
            "changeheight",
            "exit",
        },
    },
    changeattributes = {
        dialog = "I'd like to modify my attributes.",
        response = "Are you sure? It will cost $100,000 and is a one time use.",
        options = {
            "changeattributesdo",
            "nevermind",
        },
    },
    changeattributesdo = {
        dialog = "Modify attributes ($100,000)",
        callback = function( panel, key )
            local char = LocalPlayer():getChar()
            if char:getData( "changedAttributes" ) then
                panel:Close()
                nut.util.notify( "You've already modified your attributes on this character!" )
            elseif not char:hasMoney( 100000 ) then
                panel:Close()
                nut.util.notify( "You don't have enough money to modify your attributes!" )
            else
                panel:Close()
                PLUGIN:ChangeAttributes()
            end
        end,
    },
    changelanguages = {
        dialog = "I'd like to forget my learned languages.",
        response = "Are you sure? It will cost $100,000. You will have to relearn them for a price.",
        options = {
            "changelanguagesdo",
            "nevermind",
        },
    },
    changelanguagesdo = {
        dialog = "Forget learned languages ($100,000)",
        callback = function( panel, key )
            local char = LocalPlayer():getChar()
            if not char:getData( "knownLanguages" ) then
                panel:Close()
                nut.util.notify( "You've don't have any languages to forget." )
            elseif not char:hasMoney( 100000 ) then
                panel:Close()
                nut.util.notify( "You don't have enough money to forget your learned languages!" )
            else
                Derma_Query(
                    "Are you sure you want to wipe your languages? This cannot be undone and will cost $100,000.", 
                    "Confirmation of Language Wipe",
                    "Yes",
                    function()
                        panel:Close()
                        net.Start("StatsChange.Languages")
                        net.SendToServer()
                    end,
                    "No" 
                )
            end
        end,
    },
    changeheight = {
        dialog = "I'd like to modify my height.",
        response = "Are you sure? It will cost $100,000 and is a one time use.",
        options = {
            "changeheightdo",
            "nevermind",
        },
    },
    changeheightdo = {
        dialog = "Change Height ($100,000)",
        callback = function( panel, key )
            local char = LocalPlayer():getChar()
            if char:getData( "changedHeight" ) then
                panel:Close()
                nut.util.notify( "You've already modified your height on this character!" )
            elseif not char:hasMoney( 100000 ) then
                panel:Close()
                nut.util.notify( "You don't have enough money to modify your height!" )
            else
                panel:Close()
                PLUGIN:ChangeHeight()
            end
        end,
    },
    nevermind = {
        dialog = "Nevermind.",
        response = "No problem, let me know if you change your mind.",
    },        
    exit = {
        dialog = "Exit",
        callback = function( panel, key )
            panel:Close()
        end,
    },
}

net.Receive( "StatsChange.NPC", function()
    local ent = net.ReadEntity()

    local dialog = vgui.Create( "hdNPCDialog" )
    dialog:SetTitle( ent.NPC_INFORMATION.name.." - "..ent.NPC_INFORMATION.profession )
    dialog:AddDialogOptions( ent.NPC_CONVERSATION )
    dialog:SetModel( ent.NPC_INFORMATION.model )
end)