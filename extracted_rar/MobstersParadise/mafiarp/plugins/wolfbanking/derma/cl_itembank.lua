local function openItemBank(invID)
    local itemBankInventory = nut.item.inventories[invID]
    
    local itemBank = vgui.Create("nutInventory")
    local ownPanel = vgui.Create("nutInventory")
    ownPanel:setInventory(LocalPlayer():getChar():getInv())
    ownPanel:ShowCloseButton(true)
    ownPanel:CenterHorizontal(0.75)
    ownPanel:CenterVertical()
    function ownPanel:OnRemove()
        itemBank:Remove()
    end

    itemBank:setInventory(itemBankInventory)
    itemBank:SetTitle("Item Bank")
    itemBank:ShowCloseButton(true)
    itemBank:CenterHorizontal(0.25)
    itemBank:CenterVertical()
    function itemBank:OnRemove()
        ownPanel:Remove()
    end
end

netstream.Hook("OpenItemBank", openItemBank)