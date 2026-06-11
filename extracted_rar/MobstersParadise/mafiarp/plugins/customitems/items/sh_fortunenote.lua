-- "gamemodes\\mafiarp\\plugins\\customitems\\items\\sh_fortunenote.lua"

ITEM.name = "Fortune Note"
ITEM.model = "models/props_c17/paper01.mdl"
ITEM.price = 2500
ITEM.category = "Other"
ITEM.noSpawning = true

function ITEM:getDesc()
	local desc = self.desc

    if self:getData( "msg" ) then
        desc = "A note from a fortune cookie. It reads: \n\n" .. self:getData("msg")
    else
        desc = "This fortune is blank."
    end
	
	return Format( desc )
end
