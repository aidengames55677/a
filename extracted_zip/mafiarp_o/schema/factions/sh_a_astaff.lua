FACTION.name = "Staff on Duty"
FACTION.desc = "staff"
FACTION.color = Color(0, 165, 255)
FACTION.pay = 0
FACTION.isGloballyRecognized = true
FACTION.canRecognize = true
FACTION.isDefault = false
FACTION.health = 10000000
FACTION.armor = 10000000

function FACTION:onSpawn(client)
    client:SetHealth(self.health)
    client:SetArmor(self.armor)
end

FACTION.weapons = {"weapon_physgun", "gmod_tool", "adminstick"}

FACTION_STAFF = FACTION.index