-- "gamemodes\\mafiarp\\plugins\\medical\\items\\base\\sh_medical.lua"

ITEM.name = "Medical Base"
ITEM.model = "models/healthvial.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.desc = "A medical item."
ITEM.healAmount = 50
ITEM.healSeconds = 10
ITEM.flag = "v"
ITEM.category = "Medical"
ITEM.color = Color(232, 0, 0)
ITEM.quantity2 = 1

--ITEM.useTime = 5
--ITEM.useText = ""

--ITEM.targetOnly = true

--ITEM.restore = {}
--ITEM.injFix = {}

local function onUse(client)
	--client:EmitSound("items/medshot4.wav", 80, 110)
	--client:ScreenFade(1, Color(0, 255, 0, 100), .4, 0)
end

local function healPlayer(client, target, amount, seconds)
	hook.Run("OnPlayerHeal", client, target, amount, seconds)

	if (client:Alive() and target:Alive()) then
		local id = "nutHeal_"..FrameTime()
		timer.Create(id, 1, seconds, function()
			if !IsValid(target) then return end
			if (!target:IsValid() or !target:Alive()) then
				timer.Destroy(id)
				return
			end

			target:SetHealth(math.Clamp(target:Health() + (amount/seconds), 0, target:GetMaxHealth()))
		end)
		
		onUse(target)
	end
end

ITEM.functions.use = { -- sorry, for name order.
	name = "Use",
	tip = "useTip",
	icon = "icon16/add.png",
	onRun = function(item)
		local client = item.player
		if (client:Alive()) then
			if(item.useText) then
				nut.chat.send(client, "me", item.useText)
			end

			local speed = client:GetRunSpeed()
			local speed2 = client:GetWalkSpeed()

			client:SetRunSpeed(speed2 - 35)
			client:SetWalkSpeed(speed2 - 35)

			if(item.useSound) then
				client:EmitSound(item.useSound)
			end
			
			client:setAction("Applying " ..item.name.. "..." , item.useTime or 0, function()
				client:SetRunSpeed(speed)
				client:SetWalkSpeed(speed2)
				
				if item.healAmount and item.healAmount > 0 then
					healPlayer(client, client, item.healAmount, item.healSeconds)
				end
				
				if(item.injFix) then
					for _,injury in ipairs(item.injFix) do
						if client:hasInjury(injury) then
							client:getChar():takeInjury(injury)
						end
					end
				end
				
				if(item.useText) then
					nut.chat.send(client, "me", "finishes applying " ..item.name.. ".")
				end
				
				local quantity2 = item:getData("quantity2", item.quantity2)
				if(tonumber(quantity2) > 1) then
					item:setData("quantity2", quantity2 - 1)
					return false
				else
					if(item.container) then
						local position = client:getItemDropPos()
						nut.item.spawn(item.container, position)
					end
					
					if(item.charges) then
						return false
					else
						item:remove()
					end
				end
			end)
			
			return false
		end
	end,
	onCanRun = function(item)
		if(item.targetOnly) then
			return false
		end
		
		local quantity2 = item:getData("quantity2", item.quantity2 or 1)
		if(quantity2 <= 0) then
			return false
		end
		
		return true
    end
}

ITEM.functions.usef = { -- sorry, for name order.
	name = "Use Forward",
	tip = "useTip",
	icon = "icon16/arrow_up.png",
	onRun = function(item)
		local client = item.player
		local position = client:getItemDropPos()
		local trace = client:GetEyeTraceNoCursor() -- We don't need cursors.
		local target = trace.Entity

		if (IsValid(target) and (target:IsPlayer() or target:getNetVar("player"))) then
			target = target:getNetVar("player", target) --makes it so we can do this to ragdolled people too
		
			if(item.useText) then
				nut.chat.send(client, "me", item.useText.. ".")
			end
			
			if(item.useSound) then
				client:EmitSound(item.useSound)
			end
		
			client:setAction("Applying " ..item.name.. "..." , item.useTime or 0)
			target:setAction("Someone is applying " ..item.name.. "..." , item.useTime or 0)
			client:doStaredAction(target, function()
				if item.healAmount and item.healAmount > 0 then
					healPlayer(client, target, item.healAmount, item.healSeconds)
				end
				
				if(item.injFix) then
					for _,injury in ipairs(item.injFix) do
						if target:hasInjury(injury) then
							target:getChar():takeInjury(injury)
						end
					end
				end
				
				if(item.useText) then
					nut.chat.send(client, "me", "finishes applying " ..item.name.. ".")
				end
				
				local quantity2 = item:getData("quantity2", item.quantity2 or 1)
				if(tonumber(quantity2) > 1) then
					item:setData("quantity2", quantity2 - 1)
					return false
				else
					if(item.container) then
						nut.item.spawn(item.container, position)
					end
					
					if(item.charges) then
						return false
					else
						item:remove()
					end
				end
		
			end, item.useTime or 0, 
			function()
				client:setAction()
				target:setAction()
			end)
		end

		return false
	end,
	onCanRun = function(item)
		local quantity2 = item:getData("quantity2", item.quantity2 or 1)
		if(quantity2 <= 0) then
			return false
		end
	
		if(IsValid(item.entity)) then
			return false
		end
	
		return true
	end
}

function ITEM:getDesc(partial)
	local desc = self.desc
	
	if(!partial) then
		if(self:getData("quantity2", self.quantity2) != nil) then
			desc = desc.. "\nRemaining Uses: " ..self:getData("quantity2", self.quantity2)
		end
	end
	
	return Format(desc)
end

function ITEM:getName()
	local name = self.name
	
	return Format(name)
end

if (CLIENT) then
	function ITEM:paintOver(item, w, h)
		local quantity2 = item:getData("quantity2", item.quantity2)

		if (tonumber(quantity2) > 1) then
			draw.SimpleText(quantity2, "DermaDefault", w - 12, h - 14, Color(255,50,50), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black)
		end
	end
end