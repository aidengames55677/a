-- "gamemodes\\mafiarp\\plugins\\bonemerge\\entities\\entities\\plasticsurgery_npc\\cl_init.lua"

local PLUGIN = PLUGIN
include( "shared.lua" )

local TEXT_OFFSET = Vector( 0, 0, 20 )
local toScreen = FindMetaTable( "Vector" ).ToScreen
local colorAlpha = ColorAlpha
local drawText = nut.util.drawText
local configGet = nut.config.get

ENT.DrawEntityInfo = true

function ENT:onDrawEntityInfo( alpha )
    local position = toScreen( self:LocalToWorld( self:OBBCenter() ) + TEXT_OFFSET)
    local x, y = position.x, position.y

    drawText( "Surgeon Andrew Scaleno", x, y, colorAlpha(configGet( "color" ), alpha), 1, 1, nil, alpha * 0.65 )
    drawText( "Want to change up your apperance?", x, y + 16, colorAlpha( color_white, alpha ), 1, 1, "nutSmallFont", alpha * 0.65 )
end

ENT.NPC_INFORMATION = {
    name = "Andrew Scaleno",
    profession = "Surgeon; New York Hospital",
    model = "models/kerry/medic_ag/sir_roma.mdl",
}

ENT.NPC_CONVERSATION = {
    opening = {
        response = "Hello, what can I do for you?",
        options = {
            "changeface",
            "customchangeface",
            "exit",
        },
    },
    changeface = {
        dialog = "I'd like to modify my appearance.",
        response = "Are you sure? It will cost $50,000.",
        options = {
            "changefacedo",
            "nevermind",
        },
    },
    changefacedo = {
        dialog = "Modify appearance ($50,000)",
        response = "Here's your new appearance! Enjoy.",
        callback = function( panel, key )
            if LocalPlayer():getChar():hasMoney( 50000 ) then
                net.Start( "Bonemerge.ChangeFace" )
                net.SendToServer()
                panel:Close()
            else
                panel:Close()
                nut.util.notify( "You don't have enough money to modify your appearance!" )
            end

        end,
    },

    customchangeface = {
        dialog = "I'd like to modify my appearance. (Custom)",
        response = "Are you sure? It will cost $50,000.",
		can_see = function( panel, key )
			return PLUGIN:HasCustomHead( LocalPlayer() )
		end,
        options = {
            "customchangefacedo",
            "nevermind",
        },
    },
    customchangefacedo = {
        dialog = "Modify appearance ($50,000)",
        response = "Here's your new appearance! Enjoy.",
        callback = function( panel, key )
            if LocalPlayer():getChar():hasMoney( 50000 ) then
                net.Start( "Bonemerge.CustomChangeFace" )
                net.SendToServer()
                panel:Close()
            else
                panel:Close()
                nut.util.notify( "You don't have enough money to modify your appearance!" )
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

net.Receive( "Bonemerge.NPC", function()
    local ent = net.ReadEntity()

    local dialog = vgui.Create( "hdNPCDialog" )
    dialog:SetTitle( ent.NPC_INFORMATION.name.." - "..ent.NPC_INFORMATION.profession )
    dialog:AddDialogOptions( ent.NPC_CONVERSATION )
    dialog:SetModel( ent.NPC_INFORMATION.model )
end)