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
                    net.Start("AFKWarning")
                    net.WriteInt(timeLeft, 32)
                    net.Send(ply)
                end
            end
        end
    end
end)
