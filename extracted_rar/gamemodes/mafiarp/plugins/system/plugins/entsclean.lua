local PLUGIN = PLUGIN

PLUGIN.name = "Misc ents remove"
PLUGIN.author = "Dobytchick"
PLUGIN.desc = "Remove ragdolls, items and other shit."

PLUGIN.textToClean = "In 60 seconds Objects, Ragdolls and Money that is on the ground will be removed."

PLUGIN.EntsForClean = {}
PLUGIN.EntsForClean["prop_ragdoll"] = false
PLUGIN.EntsForClean["nut_item"] = true
PLUGIN.EntsForClean["nut_money"] = true

nut.config.add("cleanTime", 600, "Seconds before garbage disposal", nil, {
	data = {min = 1, max = 1000},
    category = "Misc Ents Remove",
})

if CLIENT then
    timer.Create("notify_1_minute", nut.config.get("cleanTime") - 60, 0, function()
        nut.util.notifyLocalized("[!] " .. PLUGIN.textToClean)
    end)
end

if SERVER then
    timer.Create("Timer", nut.config.get("cleanTime"), 0, function()
        for k,v in pairs(ents.GetAll()) do
            if PLUGIN.EntsForClean[v:GetClass()] then
                v:Remove()
            end
        end
    end)
end
