PLUGIN.name = "Drop Equipped Weapons"
PLUGIN.author = "Baid"
PLUGIN.desc = "Weapon dropping cuh"

function PLUGIN:PlayerDeath( client )
    local items = client:getChar():getInv():getItems()
    for k, item in pairs( items ) do
        if item.isWeapon then
            if item:getData( "equip" ) then
                nut.item.spawn( item.uniqueID, client:GetShootPos(), function()
                    item:remove()
                end, Angle(), item.data )
                client:notify("Because you died, you have lost your weapon.")
            end
        end
    end
end