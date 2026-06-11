PLUGIN = PLUGIN

PLUGIN.name = "Capture Points"
PLUGIN.author = "JayyKashtaCodes"
PLUGIN.description = "Allows factions to capture certain areas in the map and hold them."

if SERVER then
    util.AddNetworkString("CapturePointUpdate")
    util.AddNetworkString("CapturePointsUpdate")

    -- Define the capture points
    nut.config.capturePoints = {}

    -- Check if a player is in a capture point
    function PLUGIN:PlayerInCapturePoint(client)
        for name, data in pairs(self.capturePoints) do
            if client:GetPos():Distance(data.pos) <= data.radius then
                return name
            end
        end
    end

    -- Handle capture point logic
    function PLUGIN:PlayerTick(client)
        local point = self:PlayerInCapturePoint(client)
        if point then
            if client:Team() ~= self.capturePoints[point].owner then
                self.capturePoints[point].owner = client:Team()
                self.capturePoints[point].captureTime = 0
                net.Start("CapturePointUpdate")
                net.WriteString(point)
                net.WriteInt(client:Team(), 32)
                net.WriteFloat(self.capturePoints[point].captureTime)
                net.Broadcast()
            else
                self.capturePoints[point].captureTime = self.capturePoints[point].captureTime + FrameTime()
            end
        end
    end

    -- Command to set a capture point
    nut.command.add("setcapturepoint", {
        adminOnly = true,
        syntax = "<string name>",
        onRun = function(client, arguments)
            local name = arguments[1]
            if not name then
                client:notify("You must provide a name for the capture point.")
                return
            end

            nut.config.capturePoints[name] = {pos = client:GetPos(), radius = 500, owner = nil, captureTime = 0}
            client:notify("Capture point '" .. name .. "' set at your current location.")

            -- Send the updated capture points to all clients
            net.Start("CapturePointsUpdate")
            net.WriteTable(nut.config.capturePoints)
            net.Broadcast()
        end
    })

    -- Command to remove a capture point
    nut.command.add("removecapturepoint", {
        adminOnly = true,
        syntax = "<string name>",
        onRun = function(client, arguments)
            local name = arguments[1]
            if not name then
                client:notify("You must provide the name of the capture point to remove.")
                return
            end

            if not nut.config.capturePoints[name] then
                client:notify("No capture point found with the name '" .. name .. "'.")
                return
            end

            nut.config.capturePoints[name] = nil
            client:notify("Capture point '" .. name .. "' has been removed.")

            -- Send the updated capture points to all clients
            net.Start("CapturePointsUpdate")
            net.WriteTable(nut.config.capturePoints)
            net.Broadcast()
        end
    })

    -- Command to modify a capture point
    nut.command.add("modifycapturepoint", {
        adminOnly = true,
        syntax = "<string name> <string property> <string value>",
        onRun = function(client, arguments)
            local name = arguments[1]
            local property = arguments[2]
            local value = arguments[3]
            if not name or not property or not value then
                client:notify("You must provide the name of the capture point, the property to modify, and the new value.")
                return
            end

            if not nut.config.capturePoints[name] then
                client:notify("No capture point found with the name '" .. name .. "'.")
                return
            end

            if not nut.config.capturePoints[name][property] then
                client:notify("No property found with the name '" .. property .. "' for the capture point '" .. name .. "'.")
                return
            end

            nut.config.capturePoints[name][property] = value
            client:notify("Property '" .. property .. "' of capture point '" .. name .. "' has been set to '" .. value .. "'.")

            -- Send the updated capture points to all clients
            net.Start("CapturePointsUpdate")
            net.WriteTable(nut.config.capturePoints)
            net.Broadcast()
        end
    })
end

if CLIENT then
    nut.config.capturePoints = nut.config.capturePoints or {}

    -- Handle capture point updates from the server
    net.Receive("CapturePointUpdate", function()
        local point = net.ReadString()
        local team = net.ReadInt(32)
        chat.AddText(team.GetColor(team), " has captured ", point, "!")
    end)

    -- Handle capture points updates from the server
    net.Receive("CapturePointsUpdate", function()
        nut.config.capturePoints = net.ReadTable()
    end)

    -- Draw the capture zones and display the capture time and current owner
    hook.Add("PostDrawOpaqueRenderables", "DrawCaptureZones", function()
        for name, data in pairs(nut.config.capturePoints) do
            -- Draw the capture zone
            render.SetColorMaterial()
            render.DrawSphere(data.pos, data.radius, 30, 30, Color(255, 255, 255, 50))

            -- Draw the capture time and current owner
            local ang = LocalPlayer():EyeAngles()
            ang:RotateAroundAxis(ang:Forward(), 90)
            ang:RotateAroundAxis(ang:Right(), 90)
            cam.Start3D2D(data.pos, Angle(0, ang.y, 90), 1)
                draw.SimpleText("Capture Time: " .. (data.captureTime or 0), "DermaLarge", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText("Owner: " .. (team.GetName(data.owner) or "None"), "DermaLarge", 0, 30, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            cam.End3D2D()
        end
    end)
end
