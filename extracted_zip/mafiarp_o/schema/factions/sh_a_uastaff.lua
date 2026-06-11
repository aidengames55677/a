FACTION.name = "UpperAdministration on Duty"
FACTION.desc = "UA"
FACTION.color = Color(119, 0, 255)
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

FACTION_UASTAFF = FACTION.index