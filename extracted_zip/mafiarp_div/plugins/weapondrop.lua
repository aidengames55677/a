-- "gamemodes\\mafiarp\\plugins\\weapondrop.lua"

PLUGIN.name = "Drop Equipped Weapons"
PLUGIN.author = "Pendred"
PLUGIN.desc = "When you die, you will lose any equipped weapons..."

local noComp = {["rpg7"] = true, }
function PLUGIN:PlayerDeath( client )
    local items = client:getChar():getInv():getItems()
    for k, item in pairs( items ) do
        if item.isWeapon then
            if item:getData( "equip" ) then
                item:remove()
                client:notify("Because you died, you have lost your weapons.")
				SAdmin:AddLog("Weapon Lost", client:Nick().." died & lost their "..item.name.." (#"..item.id..")", client:SteamID())
                if !noComp[item.uniqueID] then
                    client.lostWep = item
                end
            end
        end
    end
end