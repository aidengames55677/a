-- "gamemodes\\mafiarp\\plugins\\medals\\cl_plugin.lua"


local PLUGIN = PLUGIN

local OFFSET_NORMAL = Vector( 0, 0, 80 )
local OFFSET_CROUCHING = Vector( 0, 0, 48 )
local toScreen = FindMetaTable( "Vector" ).ToScreen

function PLUGIN:DrawMedals( ply, alpha )
    local char = ply:getChar()
    if not char then return end

    local charID = char:getID()
    if not self.PlayerMedals[charID] then return end

    local drawposition2 = ply:Crouching() and OFFSET_CROUCHING or OFFSET_NORMAL
    drawposition2 = Vector( drawposition2.x, drawposition2.y, drawposition2.z * ply:GetModelScale() )
    local position = toScreen( ply:GetPos() + drawposition2 )
    local x, y = position.x, position.y

    local drawMedals = {}
    local i = 0
    for k,v in pairs( PLUGIN.PlayerMedals[charID] ) do
        if i == 5 then break end

        local medalData = nut.item.list[k]
        if medalData then
            table.insert( drawMedals, {icon = medalData.medalIcon, iconH = medalData.iconH, iconW = medalData.iconW} )
            i = i + 1
        end
    end

    local totalWidth = 0

    for k,v in pairs( drawMedals ) do
        totalWidth = totalWidth + v.iconH + 20
    end

    local widthOffset = -totalWidth / 2
    for k,v in pairs( drawMedals ) do
        surface.SetDrawColor( 255, 255, 255, alpha )
        surface.SetMaterial( Material( v.icon ) )
        surface.DrawTexturedRect( x + widthOffset, y - 10 - v.iconH, v.iconW, v.iconH )
        widthOffset = widthOffset + v.iconW + 20
    end
end

function PLUGIN:DrawEntityInfo( entity, alpha )
    local ply = entity:IsPlayer() and entity
    if not ply then return end

    local char = ply:getChar()
    if not char then return end

    if self.PlayerMedals[char:getID()] then 
        self:DrawMedals( ply, alpha )
    end
end