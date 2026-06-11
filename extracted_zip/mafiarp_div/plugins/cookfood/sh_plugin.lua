-- "gamemodes\\mafiarp\\plugins\\cookfood\\sh_plugin.lua"

local PLUGIN = PLUGIN
PLUGIN.name = "Cook Food"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "How about getting new foods in NutScript?"
PLUGIN.hungrySeconds = 7200 -- A player can stand up 7200 seconds without any foods

COOKLEVEL = {
	[1] = {"cookNever", 2, color_white},
	[2] = {"cookFailed", 1, Color(207, 0, 15)},
	[3] = {"cookWell", 3, Color(235, 149, 50)},
	[4] = {"cookDone", 4, Color(103, 128, 159)},
	[5] = {"cookGood", 6, Color(63, 195, 128)},
}
COOKER_MICROWAVE = 1
COOKER_STOVE = 2

nut.util.include("cl_vgui.lua")

local playerMeta = FindMetaTable("Player")
local entityMeta = FindMetaTable("Entity")

function playerMeta:getHunger()
	if (SERVER && self:getChar() && self:getChar():getFaction() == FACTION_STAFF or SERVER && self:getChar() && self:getNetVar("restricted") or SERVER && !self:getChar() or SERVER && self:IsFrozen()) then
		self:setNetVar("hunger", CurTime())
	end
	return (self:getNetVar("hunger")) or 0
end

function playerMeta:getHungerPercent()
	return math.Clamp(((CurTime() - self:getHunger()) / PLUGIN.hungrySeconds), 0 , 1)
end

function playerMeta:addHunger(amount)
	local curHunger = CurTime() - self:getHunger()

	self:setNetVar("hunger", 
		CurTime() - math.Clamp(math.min(curHunger, PLUGIN.hungrySeconds) - amount, 0, PLUGIN.hungrySeconds)
	)
end

function entityMeta:isStove()
	local class = self:GetClass()

	return (class == "nut_stove" or class == "nut_microwave")
end

-- Register HUD Bars.
if (CLIENT) then
	local color = Color(39, 174, 96)

	do
		nut.bar.add(function()
			return (1 - LocalPlayer():getHungerPercent())
		end, color, nil, "hunger")
	end

	local hungerBar, percent, wave
	function PLUGIN:Think()
		hungerBar = hungerBar or nut.bar.get("hunger")
		percent = (1 - LocalPlayer():getHungerPercent())

		if (percent < .33 || input.IsKeyDown(KEY_C) == true) then -- if hunger is 33%
			wave = math.abs(math.sin(RealTime()*5)*100)

			hungerBar.lifeTime = CurTime() + 1
			hungerBar.color = Color(color.r + wave, color.g - wave, color.b - wave)
		else
			hungerBar.color = color
		end
	end

	function PLUGIN:CreateInventoryPanel(inventory, parent)
		if (inventory.typeID ~= "stove") then
			return
		end

		local panel = vgui.Create("nutGridInventory", parent)
		panel:setInventory(inventory)
		panel:Center()
		
		return panel
	end

	local timers = {5, 15, 30}

	netstream.Hook("stvOpen", function(entity, index)
		local inventory = nut.item.inventories[index]

		if (IsValid(entity) and inventory) then
			local local_inv = nut.inventory.show(LocalPlayer():getChar():getInv())
			local_inv:ShowCloseButton(true)

			local panel = nut.inventory.show(inventory)
			panel:ShowCloseButton(true)
			panel:SetTitle("Cookable Object")
			panel:MoveLeftOf(local_inv, 4)
			panel.OnClose = function(this)
				if (IsValid(nut.gui.inv1) and !IsValid(nut.gui.menu)) then
					nut.gui.inv1:Remove()
				end

				netstream.Start("invExit")
			end
			
			function local_inv:OnClose()
				if (IsValid(panel) and !IsValid(nut.gui.menu)) then
					panel:Remove()
				end

				netstream.Start("invExit")
			end

			local actPanel = vgui.Create("DPanel")
			actPanel:SetDrawOnTop(true)
			actPanel:SetSize(100, panel:GetTall())
			actPanel.Think = function(this)
				if (!panel or !panel:IsValid() or !panel:IsVisible()) then
					this:Remove()

					return
				end

				local x, y = panel:GetPos()
				this:SetPos(x - this:GetWide() - 5, y)
			end

			for k, v in ipairs(timers) do
				local btn = actPanel:Add("DButton")
				btn:Dock(TOP)
				btn:SetText(v .. " Seconds")
				btn:DockMargin(5, 5, 5, 0)

				function btn.DoClick()
					netstream.Start("stvActive", entity, v)
				end
			end
		end
	end)
else
	local PLUGIN = PLUGIN
	
	function PLUGIN:CharacterPreSave(character)
		local savedHunger = math.Clamp(CurTime() - character.player:getHunger(), 0, PLUGIN.hungrySeconds)
		character:setData("hunger", savedHunger)
	end

	function PLUGIN:PlayerLoadedChar(client, character, lastChar)
		if (character:getData("hunger")) then
			client:setNetVar("hunger", CurTime() - character:getData("hunger"))
		else
			client:setNetVar("hunger", CurTime())
		end
	end

	function PLUGIN:PlayerDeath(client)
		client.refillHunger = true
	end

	function PLUGIN:PlayerSpawn(client)
		if (client.refillHunger) then
			client:setNetVar("hunger", CurTime())
			client.refillHunger = false
		end
	end

	function PLUGIN:PlayerPostThink(client)
		client.HungerthinkTime = client.HungerthinkTime or CurTime()
		client.HungerthinkTime2 = client.HungerthinkTime2 or CurTime()
		
		if (client.HungerthinkTime < CurTime()) then
			if(client:GetMoveType() != MOVETYPE_NOCLIP) then
			
				local percent = (1 - client:getHungerPercent())

				if (percent <= 0) then
					client:SetRunSpeed(nut.config.get("runSpeed")/2)
					client:SetWalkSpeed(nut.config.get("walkSpeed")/2)
					
					if(client.HungerthinkTime2 < CurTime()) then
						client:EmitSound("vo/npc/male01/moan0"..math.random(1,5)..".wav")
						client:TakeDamage( 10, client, client )
						client.HungerthinkTime2 = CurTime() + 120
					end
					
					timer.Simple(5, function()
						if IsValid(client) then
							client:SetRunSpeed(nut.config.get("runSpeed"))
							client:SetWalkSpeed(nut.config.get("walkSpeed"))
						end
					end)
				end
			end
			client.HungerthinkTime = CurTime() + 10
		end
	end
end
