-----------------------------------------------------------------------------------------------
local PLUGIN = PLUGIN

-----------------------------------------------------------------------------------------------
PLUGIN.name = "Rainbow Admin Physgun"
PLUGIN.author = "JayyKashtaCodes"
PLUGIN.desc = "Changes the color of admin stick and physgun based on user group"

-----------------------------------------------------------------------------------------------
nut.config.add("PhysgunNoclip", true, "Hide Physgun During Noclip", nil, {
	category = "Rainbow Stuff"
})

-----------------------------------------------------------------------------------------------
-- Function to convert HSL to RGB
local function hslToRgb(h, s, l)
    local r, g, b

    if s == 0 then
        r, g, b = l, l, l -- achromatic
    else
        local function hue2rgb(p, q, t)
            if t < 0 then t = t + 1 end
            if t > 1 then t = t - 1 end
            if t < 1/6 then return p + (q - p) * 6 * t end
            if t < 1/2 then return q end
            if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
            return p
        end

        local q = l < 0.5 and l * (1 + s) or l + s - l * s
        local p = 2 * l - q

        r = hue2rgb(p, q, h + 1/3)
        g = hue2rgb(p, q, h)
        b = hue2rgb(p, q, h - 1/3)
    end

    return r * 255, g * 255, b * 255
end

-----------------------------------------------------------------------------------------------
-- Define the user groups that should have the rainbow effect
local rainbowUserGroups = {
    "superadmin",
    "network_owner",
    "network_coowner",
    "network_executive",
    "head_developer",
    "community_director"
}

-----------------------------------------------------------------------------------------------
-- Define the user groups and their colors
local userGroupColors = {
    ["head_administrator"] = Color(153, 0, 204),
    ["supervising_administrator"] = Color(204, 204, 0),
    ["administrator"] = Color(0, 102, 204),
    ["admin"] = Color(0, 102, 204),
    ["moderator"] = Color(51, 153, 255),
    ["trial_moderator"] = Color(102, 255, 102),
    ["community_manager"] = Color(102, 255, 255)
}
-----------------------------------------------------------------------------------------------
-- Function to update physgun color
function PLUGIN:Think()
    for _, ply in ipairs(player.GetAll()) do
        local userGroup = ply:GetUserGroup()

        if userGroupColors[userGroup] then
            -- If the player's user group has a specific color, use it
            local color = userGroupColors[userGroup]
            ply:SetWeaponColor(Vector(color.r / 255, color.g / 255, color.b / 255))
        elseif table.HasValue(rainbowUserGroups, userGroup) then
            -- Otherwise, if the player's user group should have the rainbow effect, use it
            local h, s, l

            if (nut.config.get("PhysgunNoclip") == true) and ply:GetMoveType() == MOVETYPE_NOCLIP then
                h, s, l = 0, 0, 0
            else
                local curTime = CurTime()
                h = math.sin(curTime * 0.1) * 0.5 + 0.5
                s = 1
                l = 0.5
            end

            local r, g, b = hslToRgb(h, s, l)
            ply:SetWeaponColor(Vector(r / 255, g / 255, b / 255))
        elseif (nut.config.get("PhysgunNoclip") == true) and ply:GetMoveType() == MOVETYPE_NOCLIP then
            h, s, l = 0, 0, 0
        end
    end
end

-----------------------------------------------------------------------------------------------