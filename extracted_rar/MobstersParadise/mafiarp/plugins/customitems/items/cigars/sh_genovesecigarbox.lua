-- "gamemodes\\mafiarp\\plugins\\customitems\\items\\cigars\\sh_genovesecigarbox.lua"

ITEM.name = "Barzini Cigars"
ITEM.desc = "A box of finely rolled cigars from the luxurious cigar establishment, Barzini's Cigar Lounge."
ITEM.model = "models/diverge/cigarbox/cigarbox.mdl"
ITEM.category = "Custom Items"
ITEM.noSpawning = true
ITEM.plyExclusive = {
    ["STEAM_0:0:436856446"] = true, 
    ["STEAM_0:1:434305432"] = true, 
    ["STEAM_0:0:47358017"] = true, 
}

function ITEM:getDesc()
	local desc = self.desc

    desc = self.desc .. "\n\n" .. "Cigars remaining: " .. self:getData("cigarsLeft", 10)
	
	return Format( desc )
end

local totalCigars = {
	["genovesecigar_1"] = 3,
	["genovesecigar_2"] = 2,
	["genovesecigar_3"] = 1,
	["cigar"] = 4,
}

ITEM.functions.take.onCanRun = function( item )
    if item.entity and item:getData( "open" ) then 
        return 
    end

    return IsValid( item.entity )
end

ITEM.functions.OpenCigarBox = {
	name = "Open Cigar Box",
    sound = "item_medkit_ai_01_open.wav",
	onRun = function( item )
        local cigarsLeft = item:getData( "cigarsLeft", 10 )
        local bodygroup = 10 - cigarsLeft + 1
        item.entity:SetBodygroup( 0, bodygroup )
        item:setData( "open", true )

        return false
	end,
    onCanRun = function( item )
        return item.uniqueID == "genovesecigarbox" and item.entity and not item:getData( "open" )
    end
}

ITEM.functions.CloseCigarBox = {
	name = "Close Cigar Box",
    sound = "item_medkit_ai_01_open.wav",
	onRun = function( item )
        item.entity:SetBodygroup( 0, 0 )
        item:setData( "open", nil )

        return false
	end,
    onCanRun = function( item )
        return item.uniqueID == "genovesecigarbox" and item.entity and item:getData( "open" )
    end
}

ITEM.functions.TakeCigar = {
	name = "Take a cigar",
    icon = "icon16/pencil_go.png",
	onRun = function( item )
        local cigars = {}
        for k, v in pairs( totalCigars ) do
            local cigarCount = item:getData( k, v )
            if cigarCount > 0 then
                table.insert( cigars, k )
            end
        end

        local cigar = table.Random( cigars )
        local ply = item.player
        local inv = ply:getChar():getInv()
        if inv:findFreePosition( cigar ) then
            inv:add( cigar, 1 )
        else
            ply:notify( "You have no room in your inventory to store this." )
            return false
        end

        ply:notify( "You take out a cigar at random." )

        local cigarsLeft = item:getData( "cigarsLeft", 10 )
        item:setData( "cigarsLeft", cigarsLeft - 1 )
        item:setData( cigar, item:getData( cigar, totalCigars[cigar] ) - 1 )

        cigarsLeft = item:getData( "cigarsLeft", 10 )
        if item.entity then
            local bodygroup = 10 - cigarsLeft + 1
            item.entity:SetBodygroup( 0, bodygroup )
        end

        if cigarsLeft <= 0 then
            return true
        else
            return false
        end
	end,
    onCanRun = function( item )
        if item.entity and not item:getData( "open" ) then return end
        return item.uniqueID == "genovesecigarbox"
    end
}