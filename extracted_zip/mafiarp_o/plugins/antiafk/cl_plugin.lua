net.Receive("AFKWarning", function()
    local timeLeft = net.ReadInt(32)
    local minutes = math.floor(timeLeft / 60)
    local seconds = timeLeft % 60
    LocalPlayer():notify("You have " .. minutes .. ":" .. seconds .. " until you will be kicked for being AFK.")
end)
