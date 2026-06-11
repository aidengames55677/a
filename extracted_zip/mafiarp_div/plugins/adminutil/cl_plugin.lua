-- "gamemodes\\mafiarp\\plugins\\adminutil\\cl_plugin.lua"

nut.command.add("utilwipelanguages", {
	syntax = "<string charID>",
	onRun = function(client, arguments)
	end
})

nut.command.add("utilwipevendors", {
	syntax = "",
	onRun = function(client, arguments)
	end
})

nut.command.add("utilcasssettesync", {
	syntax = "",
	onRun = function(client, arguments)
	end
})

concommand.Add("ugetpos", function(ply)
    local pos = ply:GetPos()
    local ang = ply:EyeAngles()

    -- Format the position coordinates with commas
    local posString = string.format("%.2f, %.2f, %.2f", pos.x, pos.y, pos.z)

    -- Format the angle coordinates with new lines
    local angString = string.format("Pitch: %.2f\nYaw: %.2f\nRoll: %.2f", ang.p, ang.y, ang.r)

    -- Print the formatted position and angle information
    print("Position: " .. posString)
    print("Angles:\n" .. angString)
end)

concommand.Add("ugetpos_copy", function(ply)
    local pos = ply:GetPos()
    local ang = ply:EyeAngles()

    -- Format the position coordinates with commas
    local posString = string.format("%.2f, %.2f, %.2f", pos.x, pos.y, pos.z)
    SetClipboardText(posString)
	ply:ChatPrint("Copied to clipboard.")

    -- Format the angle coordinates with new lines
    local angString = string.format("Pitch: %.2f\nYaw: %.2f\nRoll: %.2f", ang.p, ang.y, ang.r)

    -- Print the formatted position and angle information
    print("Position: " .. posString)
    print("Angles:\n" .. angString)
end)