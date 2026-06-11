-- "gamemodes\\mafiarp\\plugins\\flashlight\\items\\sh_flashlight.lua"

ITEM.name = "Flashlight"
ITEM.model = "models/maxofs2d/lamp_flashlight.mdl"
ITEM.desc = "A regular flashlight with batteries included. Allows you to use your flashlight key.\nIf this doesn't work, type r_shadows 1 in console."
ITEM.price = 20
ITEM.permit = "misc"
ITEM.noBusiness = true

ITEM:hook("drop", function(item)
	if (item.player:FlashlightIsOn()) then
		item.player:Flashlight(false)
	end
end)

function ITEM:onTransfered()
	local client = self:getOwner()

	if (IsValid(client) and client:FlashlightIsOn()) then
		client:Flashlight(false)
	end
end