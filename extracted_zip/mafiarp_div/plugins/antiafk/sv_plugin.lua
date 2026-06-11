util.AddNetworkString("DAfk")

hook.Add("PlayerInitialSpawn", "AntiAFKSpawn", function(ply)
    ply.AFKTime = 0
end)

hook.Add("Tick", "AntiAFKTick", function()
    if #player.GetActive() >= nut.config.get("aa_playercount") then
        for _, ply in ipairs(player.GetActive()) do
            if ply.AFKTime and ply.AFKTime >= nut.config.get("aa_interval") then
                net.Start("DAfk")
                net.WriteBool(false)
                net.Send(ply)
                ply.AFKTime = 0
            else
                ply.AFKTime = (ply.AFKTime or 0) + 1
            end
        end
    end
end)

net.Receive("DAfk", function(len, ply)
    ply.AFKTime = 0
end)
