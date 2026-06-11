local NUT_CVAR_LOWER2 = CreateClientConVar("nut_usealtlower", "1", true)

function SCHEMA:LoadFonts(font)
	surface.CreateFont("nutAmmoFont", {
		font = "Roboto Cn",
		size = 28,
		weight = 100
	})
	
	surface.CreateFont("nutItalic", {
		font = "Segoe UI",
		size = 22,
		weight = 1000,
		shadow = true,
		italic = true
	})
	
	surface.CreateFont("nutChat", {
		font = "Segoe UI",
		size = math.max(ScreenScale(7), 17),
		weight = 200
	})
	
	surface.CreateFont("nutYell", {
	    font = "Roboto Cn",
		size = 24,
		weight = 1000,
		shadow = true
	})

	surface.CreateFont("nutWhisper", {
	    font = "Segoe UI",
		size = 17,
		weight = 1000,
		shadow = true
	})
	
	surface.CreateFont("nutObjDescFont", {
		font = "Roboto",
		size = 22,
		weight = 1000,
		shadow = true
	})
	
	surface.CreateFont("nutESPFont", {
		font = "Segoe UI",
		size = 17,
		weight = 1000,
		extended = true
	})
   

	surface.CreateFont("nut3D2DFont", {
		font = "Type-Ra",
		size = 2048,
		weight = 1000
	})

	surface.CreateFont("nutTitleFont", {
		font = "Type-Ra",
		size = ScreenScale(30),
		weight = 1000
	})

	surface.CreateFont("nutSubTitleFont", {
		font = "Roboto Cn",
		size = ScreenScale(10),
		weight = 500
	})

	surface.CreateFont("nutMenuButtonFont", {
		font = "Type-Ra",
		size = ScreenScale(10),
		weight = 400
	})
	
	surface.CreateFont("nutMenuButtonFontNew", {
		font = "Type-Ra",
		size = ScreenScale(10),
		weight = 400
	})

	surface.CreateFont("nutMenuButtonLightFont", {
		font = font,
		size = ScreenScale(10),
		weight = 200
	})

	surface.CreateFont("nutToolTipText", {
		font = font,
		size = 20,
		weight = 500
	})

	surface.CreateFont("nutDynFontSmall", {
		font = font,
		size = ScreenScale(22),
		weight = 1000
	})

	surface.CreateFont("nutDynFontMedium", {
		font = font,
		size = ScreenScale(28),
		weight = 1000
	})

	surface.CreateFont("nutDynFontBig", {
		font = font,
		size = ScreenScale(48),
		weight = 1000
	})

	-- The more readable font.
	font = "Roboto Cn"

	surface.CreateFont("nutCleanTitleFont", {
		font = font,
		size = 200,
		weight = 1000
	})

	surface.CreateFont("nutHugeFont", {
		font = "Roboto Cn",
		size = 72,
		weight = 1000
	})

	surface.CreateFont("nutBigFont", {
		font = "Roboto Cn",
		size = 36,
		weight = 1000
	})

	surface.CreateFont("nutMediumFont", {
		font = "Roboto Cn",
		size = 25,
		weight = 1000
	})

	surface.CreateFont("nutMediumLightFont", {
		font = "Roboto Cn",
		size = 25,
		weight = 200
	})

	surface.CreateFont("nutGenericFont", {
		font = "Roboto Cn",
		size = 20,
		weight = 1000
	})

	-- surface.CreateFont("nutChatFont", {
		-- font = font,
		-- size = math.max(ScreenScale(7), 17),
		-- weight = 200
	-- })

	-- surface.CreateFont("nutChatFontItalics", {
		-- font = font,
		-- size = math.max(ScreenScale(7), 17),
		-- weight = 200,
		-- italic = true
	-- })
	
	   
	surface.CreateFont("nutChatFont", {
	    font = "Roboto",
		size = 17,
		weight = 1000,
		shadow = true
	})
	
	surface.CreateFont("nutChatFontItalics", {
		font = "Roboto",
		size = 17,
		weight = 1000,
		italic = true,
		shadow = true
	})

	surface.CreateFont("nutSmallFont", {
		font = font,
		size = math.max(ScreenScale(6), 17),
		weight = 500
	})

	surface.CreateFont("nutSmallBoldFont", {
		font = font,
		size = math.max(ScreenScale(8), 20),
		weight = 800
	})

	-- Introduction fancy font.
	font = "Roboto Cn"

	surface.CreateFont("nutIntroTitleFont", {
		font = font,
		size = 200,
		weight = 1000
	})

	surface.CreateFont("nutIntroBigFont", {
		font = font,
		size = 48,
		weight = 1000
	})

	surface.CreateFont("nutIntroMediumFont", {
		font = font,
		size = 28,
		weight = 1000
	})

	surface.CreateFont("nutIntroSmallFont", {
		font = font,
		size = 22,
		weight = 1000
	})

	surface.CreateFont("nutIconsSmall", {
		font = "fontello",
		size = 22,
		weight = 500
	})

	surface.CreateFont("nutIconsMedium", {
		font = "fontello",
		size = 28,
		weight = 500
	})

	surface.CreateFont("nutIconsBig", {
		font = "fontello",
		size = 48,
		weight = 500
	})
end


--disables kill feed
function SCHEMA:DrawDeathNotice() 
	return false
end

--disables ammo pickup notifications
function SCHEMA:HUDAmmoPickedUp() 
	return false
end

--disables weapon pickup notifications
function SCHEMA:HUDDrawPickupHistory()
	return false
end

--disables target identification (name percent health)
function SCHEMA:HUDDrawTargetID()
	return false
end

function SCHEMA:PlayerBindPress(client, bind, pressed)
	bind = bind:lower()
	
	if ((bind:find("use") or bind:find("attack")) and pressed) then
		if (bind:find("use") and pressed) then
			local data = {}
				data.start = client:GetShootPos()
				data.endpos = data.start + client:GetAimVector()*96
				data.filter = client
			local trace = util.TraceLine(data)
			local entity = trace.Entity
			if (IsValid(client) and entity:IsPlayer()) then
				hook.Run("ShowPlayerCard", entity )
			end
		end
	end
end

function SCHEMA:SetupQuickMenu(menu)
	local button = menu:addButton("Clear Icon Cache", function(panel, state)
		RunConsoleCommand("nut_flushicon", "1")
	end)
				
	menu:addSpacer()
	
	local button = menu:addCheck("Multi-core Rendering", function(panel, state)
		if (state) then
			RunConsoleCommand("gmod_mcore_test", "1")
		else
			RunConsoleCommand("gmod_mcore_test", "0")
		end
	end, GetConVar("gmod_mcore_test"):GetBool())
end

netstream.Hook("strQuery", function(time, query, title, default)
	--[[
	if (title:sub(1, 1) == "@") then
		title = L(title:sub(2))
	end

	if (subTitle:sub(1, 1) == "@") then
		subTitle = L(subTitle:sub(2))
	end
	--]]

	Derma_Query(query, title, "Yes", function(text)
		netstream.Start("strQuery", time, text)
	end,
	"No"
	)
end)