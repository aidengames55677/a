-- "gamemodes\\mafiarp\\plugins\\payphones\\items\\sh_radio.lua"

ITEM.name = "Radio"
ITEM.model = "models/gibs/shield_scanner_gib1.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Communication"
ITEM.price = 150
ITEM.noBusiness = true

function ITEM:onCanBeTransfered(oldInventory, newInventory)
	if self:getData("power") then
		return false
	end
end

if SERVER then
	local PLUGIN = nut.plugin.list.payphones
	PLUGIN.RadioCallMap = PLUGIN.RadioCallMap or {}
end

function ITEM:getDesc()
	local str
	
	if (!self.entity or !IsValid(self.entity)) then
		str = "A device that allows you to send a radio signal to other characters.\nPower: %s\nFrequency: %s"
		return Format(str, (self:getData("power") and "On" or "Off"), self:getData("freq", "000.0"))
	else
		local data = self.entity:getData()
		
		str = "A radio. Power: %s Frequency: %s"
		return Format(str, (self.entity:getData("power") and "On" or "Off"), self.entity:getData("freq", "000.0"))
	end
end

if (CLIENT) then
	function ITEM:paintOver(item, w, h)
		if (item:getData("power", false)) then
			surface.SetDrawColor(110, 255, 110, 100)
		else
			surface.SetDrawColor(255, 110, 110, 100)
		end

		surface.DrawRect(w - 14, h - 14, 8, 8)
	end

	local GLOW_MATERIAL = Material("sprites/glow04_noz.vmt")
	local COLOR_ACTIVE = Color(0, 255, 0)
	local COLOR_INACTIVE = Color(255, 0, 0)

	function ITEM:drawEntity(entity, item)
		entity:DrawModel()
		local rt = RealTime()*100
		local position = entity:GetPos() + entity:GetForward() * 0 + entity:GetUp() * 2 + entity:GetRight() * 0

		if (entity:getData("power", false) == true) then
			if (math.ceil(rt/14)%10 == 0) then
				render.SetMaterial(GLOW_MATERIAL)
				render.DrawSprite(position, rt % 14, rt % 14, entity:getData("power", false) and COLOR_ACTIVE or COLOR_INACTIVE)
			end
		end
	end
end

ITEM.functions.drop.onCanRun = function(item)
	local owner = item.getOwner and item:getOwner() or false
	return owner and !item:getData('power')
end

ITEM.functions.toggle = { -- sorry, for name order.
	name = "Toggle",
	tip = "useTip",
	icon = "icon16/connect.png",
	onRun = function(item)
		for _, v in pairs(item.player:getChar():getInv():getItems()) do
			local itemTable = nut.item.instances[v.id]
			if (itemTable:getData("power") and !item:getData("power", false)) or (item.player:GetNW2Int("IsPhoneCall", 0) == 1) then
				item.player:notify("You already have an enabled radio or you are in a phone call!")
				return false
			end
		end

		item:setData("power", !item:getData("power", false), player.GetAll(), false, true)
		
		if item:getData("power") == true then
			item.player:SetNW2Int("IsRadioCall", 1);
		elseif item:getData("power") == false then
			item.player:SetNW2Int("IsRadioCall", 0);
		end

		local PLUGIN = nut.plugin.list.payphones
		PLUGIN.RadioCallMap = PLUGIN.RadioCallMap or {}

		local mapKey = item:getData("freq", "000.0")..":"..item:getData("channel", 1);

		if PLUGIN.RadioCallMap[mapKey] then
			PLUGIN[item:getData("power") && "JoinCall" || "LeaveCall"](PLUGIN, PLUGIN.RadioCallMap[mapKey], item.player)
		else
			PLUGIN.RadioCallMap[mapKey] = PLUGIN:CreateCall(item.player, 2);
		end

		item.player:EmitSound("buttons/button14.wav", 70, 150)

		return false
	end,
	onCanRun = function(item)
		if not item then return end
		if not item.getOwner then return end
		if not item:getOwner() then return end
		
		local allowedTeams = { [FACTION_POLICE] = true}
		if item:getData("freq", "000.0") == "911.1" && !allowedTeams[item.player:getChar():getFaction()] then return end
		
		local owner = item:getOwner() or false
		return !IsValid(item.entity) and owner
	end,
}

ITEM.functions.use = { -- sorry, for name order.
	name = "Freq",
	tip = "useTip",
	icon = "icon16/wrench.png",
	onRun = function(item)
		netstream.Start(item.player, "radioAdjust", item:getData("freq", "000,0"), item.id, item:getData("channel", 1))

		return false
	end,
	onCanRun = function(item)
		if not item then return end
		if not item.getOwner then return end
		if not item:getOwner() then return end
		
		local owner = item:getOwner() or false
		return !IsValid(item.entity) and owner and item:getData("power")
	end,
}
