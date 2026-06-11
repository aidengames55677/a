-----------------------------------------------------------------------------------------------
hook.Add("PostPlayerDraw", "DrawCircleAroundPlayer", function(ply)
    if ply == LocalPlayer() and ply:Alive() and ply:GetActiveWeapon():GetClass() == "adminstick" then
        -- Don't draw the circle if the player is in noclip mode
        if ply:GetMoveType() == MOVETYPE_NOCLIP then return end

        local pos = ply:GetPos() -- position of the player
        local radius = 50 -- adjust as needed
        local segments = 64 -- number of segments in the circle

        -- Define user groups that should have a rainbow circle
        local rainbowUserGroups = {
            "superadmin",
            "network_owner",
            "network_coowner",
            "network_executive",
            "head_developer",
            "community_director"
        }

        -- Define colors for different user groups
        local colors = {
            ["head_administrator"] = Color(153, 0, 204),
            ["supervising_administrator"] = Color(204, 204, 0),
            ["administrator"] = Color(0, 102, 204),
            ["admin"] = Color(0, 102, 204),
            ["moderator"] = Color(51, 153, 255),
            ["trial_moderator"] = Color(102, 255, 102),
            ["community_manager"] = Color(102, 255, 255)
        }

        -- Get the color for the player's user group
        local color
        if table.HasValue(rainbowUserGroups, ply:GetUserGroup()) then
            -- If the user group is in the list, create a rainbow color
            color = HSVToColor(CurTime() * 50 % 360, 1, 1)
            color.a = 128 -- 128 makes it semi-transparent
        else
            -- If the user group is not in the list, use the defined color or default to white
            color = colors[ply:GetUserGroup()] or Color(255, 255, 255)
            color.a = 128 -- 128 makes it semi-transparent
        end

        -- Draw the circle on the ground
        cam.Start3D2D(pos + Vector(0, 0, 1), Angle(0, 0, 0), 1)
            surface.SetDrawColor(color)

            local circle = {}
            for i = 0, segments do
                local angle = math.rad((i / segments) * -360)
                local x = math.sin(angle) * radius
                local y = math.cos(angle) * radius
                table.insert(circle, {x = x, y = y})
            end

            surface.DrawPoly(circle)
        cam.End3D2D()
    end
end)

-----------------------------------------------------------------------------------------------