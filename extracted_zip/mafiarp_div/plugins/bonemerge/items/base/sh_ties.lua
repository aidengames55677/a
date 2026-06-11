-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\base\\sh_ties.lua"


ITEM.name = "Tie"
ITEM.desc = "Tie"
ITEM.model = "models/props_junk/cardboard_box003a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Ties"
ITEM.slot = "tie"
ITEM.TieBodygroup = 1
ITEM.price = 50
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
        local foundCompatibleItem = false
        for _, compare in next, item.player:getChar():getInv():getItems() do
            if compare:getData( "equip" ) and ( compare.base == "base_bonemerge" or compare.base == "base_ties" ) then
                if compare.slot == item.slot then
                    return false
                end

                if item:CanWearWith( compare ) then
                    foundCompatibleItem = true
                end
            end
        end

        if item.gender and item.player:GetGender() ~= item.gender then
            return false
        end

        if not foundCompatibleItem then
            return false
        end

        return not IsValid( item.entity ) and not item:getData( "equip" )
    end,
}

ITEM.functions.Unequip = {
    name = "Unequip",
    tip = "equipTip",
    icon = "icon16/cross.png",
    onRun = function( item )
        item:setData( "equip", false )
        item:Transmit()

        return false
    end,
    onCanRun = function( item )
        return not IsValid( item.entity ) and item:getData( "equip" )
    end,
}

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

local whitelist = {
    ["models/cultist/clothing/male/robbers/r_closed_suit.mdl"] = true,
    ["models/cultist/clothing/male/robbers/r_long_coat.mdl"] = true,
    ["models/cultist/clothing/male/robbers/r_open_suit_w_tie.mdl"] = true,
    ["models/cultist/clothing/male/robbers/r_open_waistcoat.mdl"] = true,
    ["models/cultist/clothing/male/robbers/r_shirt_tie_closedcollar.mdl"] = true,
    ["models/cultist/clothing/male/robbers/r_shirt_tie_closedcollar_rolled.mdl"] = true,
    ["models/cultist/clothing/male/robbers/r_shirt_tie_closedcollar_short.mdl"] = true,
    ["models/cultist/clothing/male/robbers/gucci_suit.mdl"] = true,
    ["models/cultist/clothing/male/aquila/blacksiltsuit.mdl"] = true,
    ["models/cultist/clothing/male/aquila/gtaivsuit.mdl"] = true,
    ["models/cultist/clothing/male/aquila/shelbyvest.mdl"] = true,
    ["models/diverge/gimpsuit/gimpsuit.mdl"] = true,
    ["models/diverge/spacedsuits/spacedbeige/spacedbeige.mdl"] = true,
    ["models/diverge/spacedsuits/spacedred/spacedred.mdl"] = true,
    ["models/diverge/spacedsuits/spacedblack/spacedblack.mdl"] = true,
}

function ITEM:CanWearWith(item)
    if item.Bonemerge then
        for k, v in ipairs( item.Bonemerge ) do
            if whitelist[v.Model] then
                return true
            end
        end
    end

    return false
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
        if item:getData( "equip" ) then
            surface.SetDrawColor( 110, 255, 110, 100 )
            surface.DrawRect (w - 14, h - 14, 8, 8 )
        end
    end
end