FACTION.name = "FDNY - Emergency Medical Services"
FACTION.desc = FACTION.name
FACTION.color = Color(187,34,1)
FACTION.pay = 35
FACTION.payTime = 600
FACTION.weapons = {
  "qtg_weapon_medkit"
}

FACTION_EMT = FACTION.index

--Private
FACTION.isPublic = false
FACTION.isGloballyRecognized = true
FACTION.isDefault = false

local POLICE_MODELS = {
	"models/player/portal/male_02_medic.mdl",
	"models/player/portal/male_04_medic.mdl",
  "models/player/portal/male_05_medic.mdl",
  "models/player/portal/male_06_medic.mdl",
  "models/player/portal/male_07_medic.mdl",
  "models/player/portal/male_08_medic.mdl",
  "models/player/portal/male_09_dode.mdl",
  "models/player/portal/male_09_medic.mdl",
}
FACTION.models = POLICE_MODELS
