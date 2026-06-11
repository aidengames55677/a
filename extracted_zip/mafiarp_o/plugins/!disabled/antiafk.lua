PLUGIN.name = "Anti-AFK"
PLUGIN.author = "JayyKashtaCodes"
PLUGIN.desc = "kicks afk"

nut.config.add("antiafk", true, "Whether Anti AFK is active.", nil, {
    category = "AntiAFK",
})

nut.config.add("antiafk_maxPlayers", 40, "How many players before kick script activates.", nil, {
    category = "AntiAFK",
    data = {min = 10, max = 128}
})

nut.config.add("antiafk_afkTime", 60, "How long before kick.", nil, {
    category = "AntiAFK",
    data = {min = 10, max = 10000}
})

-- Create a timer that checks for AFK players every minute
timer.Create("AntiAFK", 60, 0, function()
    -- Only check for AFK players if the player count is above the maximum and AntiAFK is active
    if nut.config.get("antiafk") and #player.GetAll() > nut.config.get("antiafk_maxPlayers") then
        for _, ply in pairs(player.GetAll()) do
            local afkTime = ply:AFKTime()
            -- If a player has been AFK for longer than the time limit, kick them
            if afkTime > nut.config.get("antiafk_afkTime") then
                ply:Kick("Kicked for being AFK.")
            else
                -- Send a notification to the player each minute down to the kick
                local timeLeft = nut.config.get("antiafk_afkTime") - afkTime
                if timeLeft % 60 == 0 then
                    local minutes = math.floor(timeLeft / 60)
                    local seconds = timeLeft % 60
                    ply:notify("You have " .. minutes .. ":" .. seconds .. " until you will be kicked for being AFK.")
                end
            end
        end
    end
end)
