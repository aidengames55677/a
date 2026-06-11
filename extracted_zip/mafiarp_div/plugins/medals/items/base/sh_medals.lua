-- "gamemodes\\mafiarp\\plugins\\medals\\items\\base\\sh_medals.lua"

local PLUGIN = nut.plugin.list.medals -- ok

ITEM.model = "models/diverge/medalsbox.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector( 0, 0, 200 ),
	ang = Angle( 90, 0, 0 ),
	fov = 5.2941176470588,
}

ITEM.category = "Medals"
ITEM.noSpawning = true
ITEM.usesEquipSlot = true

ITEM.functions.wear = {
	name = "Wear Medal",
	icon = "icon16/award_star_add.png",
    onCanRun = function( item )
        local ply = item.player
        local char = ply:getChar()
        local charID = char:getID()

        if (item.FactionsEquip or item.PlayersEquip) then
            if item.FactionsEquip and item.FactionsEquip[ply:Team()] then
                return true
            end

            if item.PlayersEquip and item.PlayersEquip[ply:SteamID()] then
                return true
            end

            return false
        end

        --local medalOwner = item:getData( "medalOwner" )
        --if not item.plyExclusive and medalOwner and medalOwner ~= charID then
            --return false
        --end

        if table.Count( PLUGIN.PlayerMedals[charID] ) == 5 then
            return false
        end

        if PLUGIN.PlayerMedals[charID][item.uniqueID] then
            return false
        end

        if nut.inventory.instances[item.invID] ~= char:getInv() then
            return false
        end

        return not IsValid( item.entity ) and not item:getData( "equip" )
    end,
    onRun = function( item )
        local ply = item.player
        item:setData( "equip", true )

        if not item.plyExclusive and not item:getData( "medalOwner" ) then
            item:setData( "medalOwner", ply:getChar():getID() )
        end
 
        PLUGIN.PlayerMedals[ply:getChar():getID()][item.uniqueID] = true
        PLUGIN:UpdateAll()

        return false
    end
}

ITEM.functions.unWear = {
	name = "Take off Medal",
	icon = "icon16/award_star_delete.png",
    onCanRun = function( item )
        if nut.inventory.instances[item.invID] ~= item.player:getChar():getInv() then 
            return false
        end
        return not IsValid( item.entity ) and item:getData( "equip" )
	end,
	onRun = function( item )
        if not item.player:getChar():getInv():findFreePosition( item ) then
            item.player:notify( "You don't have enough space for this!" )
            return false
        end
		item:setData( "equip", false )

        PLUGIN.PlayerMedals[item.player:getChar():getID()][item.uniqueID] = nil
        PLUGIN:UpdateAll()

        return false
    end
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

if CLIENT then
    function ITEM:paintOver( item, w, h )
        if item:getData( "equip" ) then
            surface.SetDrawColor( 110, 255, 110, 100 )
            surface.DrawRect( w - 14, h - 14, 8, 8 )
        end
    end
end