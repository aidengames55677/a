--[[ net.Receive("OpenClothingVendor", function(_, ply)
    if IsValid(ply) and ply:IsPlayer() then
        net.Start("OpenClothingVendor")
        net.Send(ply)
    end
end)

util.AddNetworkString("OpenClothingVendor")
]]