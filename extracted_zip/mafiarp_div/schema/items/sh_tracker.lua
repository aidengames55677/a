-- "gamemodes\\mafiarp\\schema\\items\\sh_tracker.lua"

ITEM.name = "Vehicle Locator"
ITEM.desc = "A small electronic device used for pinging the location of a vehicle."
ITEM.model = "models/gibs/metal_gib4.mdl"
ITEM.price = 40

ITEM.functions.Track = {
    icon = "icon16/briefcase.png",
    onRun = function(item)
        local client = item.player
        if (client.vehicleEnt != nil) then
            local vehicle = nut.plugin.list.cardealer.loaded_vehicles[client.vehicleEnt:GetNW2Int("VehicleID")]
            if (vehicle && vehicle:getData("tracker", false)) then
                net.Start("nutTrackCar")
                  net.WriteEntity(client.vehicleEnt)
                net.Send(client)
            end
        end
        return false
    end
}