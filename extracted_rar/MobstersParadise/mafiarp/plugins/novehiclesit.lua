PLUGIN.name = "No vehicle sit"
PLUGIN.desc = "Disallow sitting on vehicle"
PLUGIN.author = "Robert Berason"

hook.Add("CheckValidSit", "noVehSit", function(ply, trace)
    local ent = trace.Entity
    if ent:IsVehicle() then return false end
end)