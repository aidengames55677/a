-- "gamemodes\\mafiarp\\plugins\\cardealer\\derma\\cl_vehicletrunk.lua"

local PLUGIN = PLUGIN
local function PlayerOpenVehicleTrunk(vehicle)
    local invID = vehicle:GetNWInt("invID")
    if not invID then return end

    local trunkPanel = vgui.Create("nutInventory")

    local ownInv = LocalPlayer():getChar():getInv()
    local ownPanel = vgui.Create("nutInventory")
    ownPanel:setInventory(ownInv)
    ownPanel:SetTitle("Your Inventory")
    ownPanel:Center()
    ownPanel:ShowCloseButton(true)
    function ownPanel:OnRemove()
        trunkPanel:Remove()
    end
    function ownPanel:OnKeyCodePressed(key)
        if key == KEY_F1 then
            self:Remove()
            trunkPanel:Remove()
        end
    end

    local trunkInventory = nut.item.inventories[invID]
    trunkPanel:SetTitle("Trunk")
    -- local trunkPanel = vgui.Create("nutInventory")
    trunkPanel:setInventory(trunkInventory)
    local x,y = ownPanel:GetPos()
    trunkPanel:SetPos(x-trunkPanel:GetWide(), y)
    trunkPanel:ShowCloseButton(true)
    function trunkPanel:OnRemove()
        ownPanel:Remove()
    end
end

netstream.Hook("PlayerOpenVehicleTrunk", PlayerOpenVehicleTrunk)