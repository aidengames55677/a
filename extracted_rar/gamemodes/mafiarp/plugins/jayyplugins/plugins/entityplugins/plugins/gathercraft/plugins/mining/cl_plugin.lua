function PLUGIN:PreDrawHalos()
    if not IsValid(LocalPlayer()) then return end
    if LocalPlayer():GetActiveWeapon() == NULL then return end
    for _, ent in pairs(ents.FindInSphere(LocalPlayer():GetPos(), 1500)) do
        if table.HasValue(nut.config.rockEnts, ent:GetClass()) and LocalPlayer():GetActiveWeapon():GetClass() == nut.config.get("PickAxeSWEP") then
            halo.Add({ent}, Color(0, 255, 0), 5, 5, 2)
            continue
        end
    end
end