-- "gamemodes\\mafiarp\\plugins\\bank\\entities\\entities\\bankaccount_npc\\cl_init.lua"

include( "shared.lua" )

local TEXT_OFFSET = Vector( 0, 0, 20 )
local toScreen = FindMetaTable( "Vector" ).ToScreen
local colorAlpha = ColorAlpha
local drawText = nut.util.drawText
local configGet = nut.config.get
local PLUGIN = PLUGIN
    
ENT.DrawEntityInfo = true

function ENT:onDrawEntityInfo( alpha )
    local position = toScreen( self.LocalToWorld(self, self.OBBCenter( self )) + TEXT_OFFSET )
    local x, y = position.x, position.y

    drawText( "Abraham Steinhausen", x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 0.65 )
    drawText( "Hello goy, here to open an account?", x, y + 16, colorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65 )
end

ENT.NPC_INFORMATION = {
    name = "Abraham Steinhausen",
    profession = "Banker",
    model = "models/palyer/kerry/jew_boss.mdl",
}

local function createDermaQuery(panel, price, accountType)
    Derma_Query(
        "Are you sure you would like to create an account? ($"..price..")", 
        "Open Account Confirmation", 
        "Yes", function() 
        net.Start( "Banking.AccountCreate" ) 
            net.WriteInt( accountType, 32 ) 
        net.SendToServer()
        panel:Close()
        end,
        "No", function() end
    )
end

ENT.NPC_CONVERSATION = {
    opening = {
        response = "Hello, what can I do for you?",
        options = {
            "createaccount",
            "howdothiswork",
            "exit",
        },
    },
    createaccount = {
        dialog = "I would like to open a bank account.",
        response = "Okay! What type of account would you like to open?",
        callback = function(panel, key)        
            local dialog = panel.conversations[key]
            net.Start( "Banking.RetrieveAccounts" )
            net.SendToServer()
        
            net.Receive( "Banking.ReturnAccounts", function()
                local numaccounts = net.ReadInt(32)
                panel:ClearDialogOptions()
                panel:SetText(dialog.response)
                
                if numaccounts == 0 then
                    panel:AddDialogOption("Open a bank account ($1,000)", "open_account", function(panel, key)
                        createDermaQuery(panel, 1000, 1)
                    end)
                elseif numaccounts == 1 then
                    panel:AddDialogOption("Open a second bank account ($50,000)", "open_second_account", function(panel, key)
                        createDermaQuery(panel, 50000, 2)
                    end)
                elseif numaccounts == 2 then
                    panel:AddDialogOption("Open a third bank account ($100,000)", "open_third_account", function(panel, key)
                        createDermaQuery(panel, 100000, 3)
                    end)
                elseif numaccounts >= 3 then
                    panel:SetText("Sorry, you've already opened the maximum number of bank accounts.")
                end

                panel:AddDialogOption("Exit", "exit", function(panel, key)
                    panel:Close()
                end)
            end)
        end,
        options = {
            "nevermind",
        },
    },
    howdothiswork = {
        dialog = "How do bank accounts work?",
        response = "Here's a guide that tells you how bank accounts work.",
        callback = function(panel, key)
            local f = vgui.Create("DFrame")
            f:SetSize(ScrW()*0.8, ScrH()*0.8)
            f:SetTitle("Guides")
            f:Center()
            f:MakePopup()
            local h = vgui.Create("DHTML", f)
            h:Dock(FILL)
            h:OpenURL("https://divergenet.works/forums/showthread.php?tid=3262")
        end,
    },
    nevermind = {
        dialog = "Nevermind.",
        response = "No problem, let me know if you change your mind.",
    },        
    exit = {
        dialog = "Exit",
        callback = function(panel, key)
            panel:Close()
        end,
    },
}

net.Receive( "Banking.NPC",function()
	if LocalPlayer():GetEyeTrace().Entity:GetClass() != "bankaccount_npc" then return false end
	
    local ent = net.ReadEntity()

    local dialog = vgui.Create("hdNPCDialog")
    dialog:SetTitle(ent.NPC_INFORMATION.name.." - "..ent.NPC_INFORMATION.profession)
    dialog:AddDialogOptions(ent.NPC_CONVERSATION)
    dialog:SetModel(ent.NPC_INFORMATION.model)
end )