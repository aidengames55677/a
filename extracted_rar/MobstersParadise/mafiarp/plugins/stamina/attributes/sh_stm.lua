-- "gamemodes\\mafiarp\\plugins\\stamina\\attributes\\sh_stm.lua"

ATTRIBUTE.name = "Stamina"
ATTRIBUTE.desc = "Affects how fast you can run."

function ATTRIBUTE:onSetup(client, value)
	client:SetRunSpeed(nut.config.get("runSpeed", 235) + value)
end