-----------------------------------------------------------------------------------------------
PLUGIN.name = "Noclip Cloak"
-----------------------------------------------------------------------------------------------
PLUGIN.author = "JayyKashtaCodes"
-----------------------------------------------------------------------------------------------
PLUGIN.desc = "This plugin makes players invisible when they are in noclip mode."
-----------------------------------------------------------------------------------------------
function PLUGIN:PlayerSpawn(client)
    timer.Create( "NoclipCloak", 0.1, 0, function()
        for k,pl in pairs(player.GetAll()) do
            local oldstate = pl:GetMoveType()
            if oldstate != MOVETYPE_NOCLIP or pl:InVehicle() then
                pl:SetColor(Color( 255, 255, 255, 255 ))
                pl:SetNoDraw(false)
            else
                pl:SetColor(Color( 255, 255, 255, 0 ))
                pl:SetNoDraw(true)
            end
        end
    end )
end

if CLIENT then
    hook.Add("HUDPaint", "PhysgunWarning", function()
        for k,pl in pairs(player.GetAll()) do
            if pl == LocalPlayer() and pl:GetMoveType() == MOVETYPE_NOCLIP and pl:GetActiveWeapon():GetClass() == "weapon_physgun" and (nut.config.get("PhysgunNoclip") == false) then
                surface.SetTextColor(255, 0, 0, 255)
                surface.SetTextPos(ScrW() * 0.8, ScrH() * 0.1) -- Adjust these values as needed
                surface.SetFont("Default")
                surface.DrawText("You have your physgun out the players can see it")
            end
        end
    end)
end

-----------------------------------------------------------------------------------------------