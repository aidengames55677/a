-- "gamemodes\\mafiarp\\plugins\\payphones\\items\\sh_phone.lua"

ITEM.name = "Motorola DynaTAC 8000X"
ITEM.category = "Communication"
ITEM.cost = 50
ITEM.model = "models/unconid/phones/motorola_dynatac_8000x.mdl"
ITEM.width = 1
ITEM.height = 2
ITEM.phone = true
ITEM.exRender = true
ITEM.iconCam = {
	pos = Vector(241.42430114746, 202.62442016602, 153.45616149902),
	ang = Angle(25, 220, 0),
	fov = 1.2748167331371
}
ITEM.desc = "A commercial portable cellular phone, its name is an abbreviation of 'Dynamic Adaptive Total Area Coverage.'"

function ITEM:onCanBeTransfered(oldInventory, newInventory)
	if self:getData("enabled") then
		return false
	end
end

function ITEM:getDesc()
	if IsValid(self.entity) then return self.desc end

	if self:getData("number") then
		return (self.desc.." This phone's number is: "..self:getData("number"))
	end

	return self.desc
end

function ITEM:PaintOver(item, w, h)
    if (item:getData("enabled")) then
        surface.SetDrawColor(110, 255, 110, 100)
        surface.DrawRect(w - 14, h - 14, 8, 8)
    end
end

ITEM.functions.enable = {
	name = "Enable",
	sound = 'tools/ifm/beep.wav',
	icon = "icon16/phone_add.png",
	onRun = function(item)
		for _, v in pairs(item.player:getChar():getInv():getItems()) do
			local itemTable = nut.item.instances[v.id]
			if (itemTable:getData("enabled")) then
				item.player:notify("You already have an enabled phone!")
				return false
			end
		end
		
		item:setData('enabled', true)
		item.player:SetNW2Int("nutPhoneCall", 0) -- reset the call var
        
		return false
	end,
	onCanRun = function(item)
		return !IsValid(item.entity) and item:getOwner() and !item:getData('enabled')
	end,
}

ITEM.functions.disable = {
	name = "Disable",
	sound = 'tools/ifm/beep.wav',
	icon = "icon16/phone.png",
	onRun = function(item)
		item:setData('enabled', false)

		return false
	end,
	onCanRun = function(item)
		local owner = item.getOwner and item:getOwner() or false
		local allow = owner and owner:GetNW2Int("IsPhoneCall", 0) == 0
		return !IsValid(item.entity) and item:getData('enabled') and allow
	end,
}

ITEM.functions.numberchange = {
	name = "Type Number",
	sound = 'tools/ifm/beep.wav',
	icon = "icon16/cog_edit.png",
	onRun = function(item)
		local client = item.player
		if client:GetNW2Int("IsPhoneCall", 0) == 0 && client:GetNW2Int("IsRadioCall", 0) == 0 then
			net.Start("nutPhoneDermaMenu")
			net.Send(client)
		else
			client:notify('You cannot make a call whilst on the radio!')
		end
        
		return false
	end,
	onCanRun = function(item)
		local owner = item.getOwner and item:getOwner() or false
		local allow = owner and owner:GetNW2Int("IsPhoneCall", 0) == 0
		return !IsValid(item.entity) and item:getData('enabled') and allow
	end,
}

ITEM.functions.numbercopy = {
	name = "Copy Number",
	sound = 'tools/ifm/beep.wav',
	icon = "icon16/cog_edit.png",
	onRun = function(item)
		local client = item.player
		local num = tostring(item:getData("number"))
		net.Start("nutPhoneCopyNumber")
			net.WriteString( num )
		net.Send(client)

        client:ChatPrint("Number copied to clipboard.")
		return false
	end,
	onCanRun = function(item)
		local owner = item.getOwner and item:getOwner() or false
		local allow = owner and owner:GetNW2Int("IsPhoneCall", 0) == 0
		return !IsValid(item.entity) and item:getData('enabled') and allow
	end,
}

ITEM.functions.savenumber = {
	name = "Save Number",
	sound = 'tools/ifm/beep.wav',
	icon = "icon16/cog_edit.png",
	onRun = function(item)
		net.Start("nutPhoneSaveNumber")
		net.Send(item.player)
        
		return false
	end,
	onCanRun = function(item)
		return !IsValid(item.entity) and item:getData('enabled') and item:getOwner()
	end,
}

ITEM.functions.cancelcall = {
	name = "End call",
	sound = 'tools/ifm/beep.wav',
	icon = "icon16/cog_edit.png",
	onRun = function(item)
		local currentCall = item.player:GetNW2Int("nutPhoneCall", 0)
		if currentCall > 0 then
			nut.plugin.list.payphones:LeaveCall(currentCall, item.player, true)
			item.player:SetNW2Int("IsPhoneCall", 0);
		end
        
		return false
	end,
	onCanRun = function(item)
		if not item then return end
		if not item.getOwner then return end
		if not item:getOwner() then return end
		
		local owner = item:getOwner() or false
		local allow = owner and owner:GetNW2Int("IsPhoneCall", 0) == 1
		return !IsValid(item.entity) and item:getData('enabled') and allow
	end,
}

ITEM.functions.drop.onCanRun = function(item)
	local owner = item.getOwner and item:getOwner() or false
	local allow = owner and owner:GetNW2Int("IsPhoneCall", 0) == 0
	return allow and !item:getData('enabled')
end

local function setRandomNumber(item)
	local phoneNumber = ""..math.random(1000000, 9999999)
	nut.db.query(Format("SELECT `_itemID` FROM `nut_items` WHERE `_data` LIKE '%%\"number\":\"%s\"%%'", phoneNumber), function(data)
		if data == nil or #data == 0 then
			local phone = nut.plugin.list.payphones:FindPhone(phoneNumber)
			
			if !IsValid(phone) then
				item:setData("number", phoneNumber)
				return
			end
		end

		setRandomNumber(item)
	end)
end

function ITEM:onInstanced()
	if !self:getData("number") then
		setRandomNumber(self)
	end
end

function ITEM:onRestored()
	if !self:getData("number") then
		setRandomNumber(self)
	end
end