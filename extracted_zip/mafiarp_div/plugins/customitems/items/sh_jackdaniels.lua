-- "gamemodes\\mafiarp\\plugins\\customitems\\items\\sh_jackdaniels.lua"

ITEM.name = "Bottle of Jack Daniels"
ITEM.desc = "A bottle of Jack Daniels, a popular brand of whiskey."
ITEM.model = "models/diverge/drinks/jack.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(172.76951599121, 145, 103),
	ang = Angle(25, 220, 0),
	fov = 2.9411764705882,
}
ITEM.price = 10
ITEM.category = "Custom Items"
ITEM.noSpawning = true
ITEM.facExclusive = { [FACTION_BONANNOO] = true, }

function ITEM:getDesc()
	local desc = self.desc

    desc = self.desc .. "\n\n" .. "Shots remaining: " .. self:getData("shots", 4)
	
	return Format( desc )
end

ITEM.functions.Pour = {
	name = "Pour a Drink",
    icon = "icon16/drink.png",
	onRun = function( item )
        local ply = item.player
        local shots = tonumber( item:getData( "shots", 4 ) )

        local inv = ply:getChar():getInv()
        if inv:findFreePosition( "jackdaniels_glass" ) then
            inv:add( "jackdaniels_glass", 1 )
            :next( function( res )
                ply:EmitSound( "item_purewater_00_draw.wav" )
            end )
        else
            ply:notify( "You have no room in your inventory to store this." )
            return false
        end

        ply:notify( "You open the bottle and pour out a quarter of it into a glass." )
        item:setData( "shots", shots - 1 )

        if shots <= 1 then
            return true
        else
            return false
        end
    end,
    onCanRun = function( item )
        return item.uniqueID == "jackdaniels" -- No idea why it's applying to all items
    end
}