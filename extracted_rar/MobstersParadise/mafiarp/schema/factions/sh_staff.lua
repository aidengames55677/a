FACTION.name = "Staff on Duty"
FACTION.desc = "Use @ to Contact Staff"
FACTION.color = Color(255, 0, 0)
FACTION.pay = 0
FACTION.isGloballyRecognized = true
FACTION.isDefault = false


function FACTION:onSpawn(client)
    local character = client:getChar()

    character:giveFlags("pet")
    client:SetHealth(5000)
    client:SetArmor(5000)
end

FACTION_STAFF = FACTION.index