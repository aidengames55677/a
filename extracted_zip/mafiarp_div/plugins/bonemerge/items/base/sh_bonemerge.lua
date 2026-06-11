-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\base\\sh_bonemerge.lua"


ITEM.name = "Bonemerge"
ITEM.desc = "Bonemerge"
ITEM.model = "models/props_junk/cardboard_box003a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Clothing"
ITEM.slot = "head"
ITEM.Hands = 16
ITEM.usesEquipSlot = true

ITEM.functions.Equip = {
    name = "Equip",
    tip = "equipTip",
    icon = "icon16/tick.png",
    onRun = function( item )
        item:setData( "equip", true )

        item:Transmit()

        return false
    end,
    onCanRun = function( item )
        local canWearShoes = false

        for _, compare in next, item.player:getChar():getInv():getItems() do
            if compare:getData( "equip" ) and compare.base == "base_bonemerge" and compare ~= item then
                if compare.slot == item.slot then
                    return false
                end

                if compare.slot == "pants" and compare.CanWearShoes then
                    canWearShoes = true
                end

                if not compare:CanWearWith( item ) then
                    return false
                end
            end
        end

        if item.slot == "shoes" and not canWearShoes then
            return false
        end

        if item.gender and item.player:GetGender() ~= item.gender then
            return false
        end

        if nut.inventory.instances[item.invID] ~= item.player:getChar():getInv() then 
            return false
        end

        if item.player:IsUserGroup( "founder" ) then
            return true
        end

        if item.isPD and item.player:Team() ~= FACTION_POLICE then
            return false
        end

        if item.FactionsEquip or item.PlayersEquip then
            if item.FactionsEquip and item.FactionsEquip[item.player:Team()] then
                return true
            end

            if item.PlayersEquip and item.PlayersEquip[item.player:SteamID()] then
                return true
            end

            return false
        end

        return not IsValid( item.entity ) and not item:getData( "equip" )
    end
}

ITEM.functions.Unequip = {
    name = "Unequip",
    tip = "equipTip",
    icon = "icon16/cross.png",
    onRun = function( item )
        item:setData( "equip", false )

        if item.CanWearShoes then
            for _, shoes in next, item.player:getChar():getInv():getItems() do
                if shoes.slot == "shoes" and shoes:getData( "equip" ) then
                    netstream.stored["invAct"]( item.player, "Unequip", shoes:getID(), shoes.invID ) -- TODO: What the fuck is this?
                    break
                end
            end
        end

        item:Transmit()

        return false
    end,
    onCanRun = function( item )
        local inventory = item.player:getChar():getInv()
        return not IsValid( item.entity ) and item:getData( "equip" ) and inventory:findFreePosition( item )
    end
}

--[[
ITEM.functions.Adjust = {
    name = "Adjust",
    icon = "icon16/anchor.png",
    onRun = function( item )
        net.Start( "Bonemerge.StartAdjustingItem" )
        net.Send( item.player )

        return false
    end,
    onCanRun = function( item )
        return not IsValid( item.entity ) and item:getData( "equip" ) and Bonemerge.CanAdjust[item.slot]
    end
}
]]--

ITEM.functions.drop.onCanRun = function( item )
    return item.entity == nil
    and not IsValid( item.entity )
    and not item.noDrop
    and not item:getData( "equip" )
end

function ITEM:onCanBeTransfered( oldInventory, newInventory )
    if newInventory and self:getData( "equip" ) then
        return false
    end

    return true
end

function ITEM:onLoadout()
    if SERVER and self:getData( "equip" ) then
        self:Transmit()
    end
end

function ITEM:CanWearWith( item )
    local allowItems = {
        ["hats"] = true,
        ["glasses"] = true,
        ["neck"] = true,
        ["wrist"] = true,
        ["rightring"] = true,
        ["leftring"] = true,
        ["vest"] = true,
        ["face"] = true,
    }

    if ( item.slot == "fulloutfit" and allowItems[self.slot] ) or ( self.slot == "fulloutfit" and allowItems[item.slot] ) then
        return true
    end

    if self.slot == "fulloutfit" or item.slot == "fulloutfit" then
        return false
    end

    if self.slot == "pants" and item.slot == "shoes" and not self.CanWearShoes then
        return false
    end

    return true
end

if SERVER then
    function ITEM:Transmit( ply )
        if not IsValid( self:getOwner() ) or self:getOwner():getNetVar( "char", 0 ) == 0 then return end
        local ownerInv = nut.inventory.instances[self.invID]
        local characterID = ownerInv.data.char

        if not characterID then return end

        net.Start( "Bonemerge.ReceiveBonemergeItem" )
            net.WriteUInt( self.id, 32 )
            net.WriteEntity( self:getOwner() )
            net.WriteUInt( characterID, 32 )
            net.WriteString( self.uniqueID )
            net.WriteBool( self:getData( "equip", false ) )
        if ply then
            net.Send( ply )
        else
            net.Broadcast()
        end
    end
end

if CLIENT then
    function ITEM:paintOver( item, w, h )
        if ( item:getData( "equip" ) ) then
            surface.SetDrawColor( 110, 255, 110, 100 )
            surface.DrawRect( w - 14, h - 14, 8, 8 )
        end
    end
end