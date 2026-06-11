-- "gamemodes\\mafiarp\\plugins\\customcontext\\sh_plugin.lua"

local PLUGIN = PLUGIN
PLUGIN.name = "Custom Context Menu"
PLUGIN.author = "rusty"
PLUGIN.desc = "Custom context menu used to interact with entities."

function CarGetAllPassengers(ent)
	if !ent.IsSimfphyscar then return {} end

	local passengers = {}
	for i,seat in ipairs(ent:GetChildren()) do
		if !seat:GetClass("prop_vehicle_prisoner_pod") then continue end
		if !seat:IsVehicle() then continue end
		if seat:GetDriver() == ent:GetDriver() then continue end

		if IsValid(seat) then
			local Passenger = seat:GetDriver()

			if IsValid(Passenger) then
				table.insert(passengers, Passenger)
			end
		end
	end

	return passengers
end

local function CarIsPassenger(ent, ply)
	local passengers = CarGetAllPassengers(ent)
	for _,passenger in ipairs(passengers) do
		if passenger == ply then
			return true
		end
	end

	return false
end

local police = {
	[FACTION_POLICE] = true,
	[FACTION_STAFF] = true
}
local govFacs = {[FACTION_GOVERNMENT] = true, [FACTION_GOVERNMENTSTATE] = true, [FACTION_POLICE] = true}
PLUGIN.MaxInteractDistance = 250*250 -- we always have to square this value because we use DistToSqr
PLUGIN.ContextOptions = {
	giveMoney = {
		text = "Give money",
		icon = "icon16/money_add.png",
		optionOverride = function(option)
			/*
				Closures, JIT compiler hates me!
			*/
			Derma_StringRequest(
				"Give money", 
				"How much would you like to give?", 
				"0", 
				function(text)
					nut.command.send("givemoney", text)
				end, 
				function() 
					gui.EnableScreenClicker(false)
				end
			)
		end,
		canRun = function(ply, ent)
			return ent:IsPlayer()
		end
	},
	openTrunk = {
		text = "Open Trunk",
		icon = "icon16/table.png",
		optionOverride = function(option)
			local plugin = nut.plugin.list.customcontext
			local entity = plugin.ContextMenu.Entity

			net.Start("vehicleAction")
				net.WriteString("openInv")
				net.WriteUInt(entity:GetNW2Int("VehicleID"), 32)
			net.SendToServer()
		end,
		canRun = function(ply, ent)
			return ent.IsSimfphyscar and ent:GetNW2Int("VehicleID", 0) ~= 0 && ply:GetPos():Distance(ent:GetPos()) < 100
		end
	},
	carRadio = {
		text = "Car Radio",
		icon = "icon16/sound.png",
		optionOverride = function(option)
			local plugin = nut.plugin.list.customcontext
			local entity = plugin.ContextMenu.Entity
			nut.plugin.list.cassette_player:OpenCassetteMenu(entity)
		end,
		canRun = function(ply, ent)
			return ent.IsSimfphyscar && LocalPlayer():GetSimfphys() == ent
		end
	},
	toggleLock = {
		text = "Toggle Lock",
		icon = "icon16/lock_open.png",
		onRun = function(ply, ent)
			if ent.IsLocked then
				ent:UnLock()
				ent:EmitSound("doors/door_latch1.wav")
			else
				ent:Lock()
				ent:EmitSound("doors/door_latch3.wav")
			end

		end,
		canRun = function(ply, ent)
			return ent.IsSimfphyscar && ent:GetDriver() == ply
		end
	},
	allowRecognize = {
		text = "Allow Recognition",
		icon = "icon16/user_go.png",
		optionOverride = function(option)
			netstream.Start("rgn", 1)
		end,
		canRun = function(ply, ent)
			return ent:IsPlayer()
		end
	},
	dragPlayer = {
		text = "Drag",
		icon = "icon16/link.png",
		onRun = function(ply, ent)
			SetDrag(ent, ply)
		end,
		canRun = function(ply, ent)
			if !ent:IsPlayer() then return end
			if IsValid(ply:GetNW2Entity("Dragging", nil)) then return false end
		
			if IsValid(ply:GetActiveWeapon()) && !ply:InVehicle() && !IsBeingDragged(ply) then
				if ent:IsPlayer() && ent:GetPos():DistToSqr(ply:GetPos()) <= DRAGGING_START_RANGE * DRAGGING_START_RANGE && ent:getNetVar("restricted") && !ent:InVehicle() && !IsBeingDragged(ent) then
					if ent:getNetVar("cuffed") && !govFacs[ply:Team()] then
						return false
					end
					return true
				end
			end
		
			return false
		end,
		
	},
	undragPlayer = {
		text = "Stop Dragging",
		icon = "icon16/link_break.png",
		onRun = function(ply, ent)
			SetDrag(ent, nil)
		end,
		canRun = function(ply, ent)
			local dragging = ply:GetNW2Entity("Dragging", nil)
			if IsValid(dragging) and dragging == ent then return true end

			return false
		end,
	},
	blindFold = {
		text = "Blind Fold",
		icon = "icon16/link_break.png",
		onRun = function(ply, ent)
			ent:setNetVar("blindFolded", true)
            ent:SendLua([[hook.Add( "RenderScreenspaceEffects", "BlindFold"..LocalPlayer():UserID(), function() surface.SetDrawColor(Color( 0, 0, 0, 255 )) surface.DrawRect( 0, 0, ScrW(), ScrH()) end )]])
			SAdmin:AddLog("Tying", ent:Nick().." was blindfolded by by "..ply:Nick().. " "..ply:SteamID(), ent:SteamID())
		end,
		canRun = function(ply, ent)
			return ent:IsPlayer() and ent:getNetVar("restricted") and !ent:getNetVar("blindFolded") and !ent:getNetVar("cuffed")
		end,
	},
	unBlindFold = {
		text = "Remove Blindfold",
		icon = "icon16/link_break.png",
		onRun = function(ply, ent)
			ent:setNetVar("blindFolded", false)
            ent:SendLua([[hook.Remove( "RenderScreenspaceEffects", "BlindFold"..LocalPlayer():UserID())]])
			SAdmin:AddLog("Tying", ent:Nick().." was unblindfolded by by "..ply:Nick().. " "..ply:SteamID(), ent:SteamID())
		end,
		canRun = function(ply, ent)
			return ent:IsPlayer() and ent:getNetVar("restricted") and ent:getNetVar("blindFolded")
		end,
	},
	requestSearch = {
		text = "Request Search",
		icon = "icon16/magnifier.png",
		onRun = function(ply, ent)
			nut.command.run(ply, "requestsearch", {})
		end,
		canRun = function(ply, ent)
			return ent:IsPlayer() and !ent:getNetVar("restricted")
		end,
	},
	showID = {
		text = "Show ID",
		icon = "icon16/magnifier.png",
		onRun = function(ply, ent)
			local target = ent
			
			if (ply.NextDocumentCheck && ply.NextDocumentCheck > SysTime()) then ply:notify("You can't show documents that quickly...") return false end
			
			if not target:IsPlayer() or not IsValid(target) or target:GetPos():Distance(ply:GetPos()) > 500 then return end
	
			net.Start("nutRequestID")
			net.Send(target)
	
			ply:notify("Request to show ID sent.")
	
			target.SearchID = ply
			ply.SearchID = target
	
			ply.NextDocumentCheck = SysTime() + 5
			return false
		end,
		canRun = function(ply, ent)
			return IsValid(ent) and ent:IsPlayer()
		end,
	},
	viewID = {
		text = "View ID",
		icon = "icon16/magnifier.png",
		onRun = function(ply, ent)
			netstream.Start( ply, "OpenCharInfoDisplay", ent, ent:getChar():getID() )
			ply:getChar():recognize( ent:getChar():getID() )
			return false
		end,
		canRun = function(ply, ent)
			if ent:IsPlayer() and ent:getNetVar("cuffed") and not govFacs[ply:Team()] then return false end
			return ent:IsPlayer() and ent:getNetVar("restricted") and not ply:getNetVar("restricted")
		end,
	},
	forceSearch = {
		text = "Search Player",
		icon = "icon16/magnifier.png",
		onRun = function(ply, ent)
			nut.command.run(ply, "charsearch", {})
		end,
		canRun = function(ply, ent)
			return ent:IsPlayer() and ent:getNetVar("restricted")
		end,
	},
	forceIntoVeh = {
		text = "Force Dragged into Vehicle",
		icon = "icon16/car_add.png",
		onRun = function(ply, ent)
			local target = ply:GetNW2Entity("Dragging", nil)

			if !IsValid(target) then return end

			if ent.PassengerSeats then
				local closestSeat = ent:GetClosestSeat(target)

				if not closestSeat or IsValid(closestSeat:GetDriver()) then
					for i,seat in ipairs(ent.pSeat) do
						if IsValid(seat) then
							local HasPassenger = IsValid(seat:GetDriver())

							if not HasPassenger then
								SetDrag(target, nil)
								target:EnterVehicle(seat)
								break
							end
						end
					end
				else
					SetDrag(target, nil)
					target:EnterVehicle(closestSeat)
				end
			end
		end,
		canRun = function(ply, ent)
			return ent.IsSimfphyscar and IsValid(ply:GetNW2Entity("Dragging", nil))
		end,
	},
	--[[forceTiedFromVeh = {
		createOption = function(menu)
			local submenu = menu:AddSubMenu("Force Tied From Vehicle")
			local passengers = CarGetAllPassengers(menu.Entity)

			for i,ply in ipairs(passengers) do
				if !ply:getNetVar("restricted") then continue end

				submenu:AddOption(i..": "..(hook.Run("GetDisplayedName", ply) or "Unknown"), function()
					net.Start("nutRunContextFunction")
						net.WriteString("forceTiedFromVeh")
						net.WriteEntity(menu.Entity)
						net.WriteEntity(ply)
					net.SendToServer()
				end)
			end

			return submenu
		end,
		onRun = function(ply, ent)
			local target = net.ReadEntity()

			if !CarIsPassenger(ent, target) then return end
			if !target:getNetVar("restricted") then return end

			target:ExitVehicle()
		end,
		canRun = function(ply, ent)
			return ent.IsSimfphyscar and #CarGetAllPassengers(ent) > 0 and ent:GetDriver()
		end,
	},--]]
	
	forceFromVeh = {
		createOption = function(menu)
			local submenu1 = menu:AddSubMenu("Force From Vehicle")
			local passengerss = CarGetAllPassengers(menu.Entity)

			for i,ply in ipairs(passengerss) do

				submenu1:AddOption(i..": "..(hook.Run("GetDisplayedName", ply) or "Unknown"), function()
					net.Start("nutRunContextFunction")
						net.WriteString("forceFromVeh")
						net.WriteEntity(menu.Entity)
						net.WriteEntity(ply)
					net.SendToServer()
				end)
			end

			return submenu1
		end,
		onRun = function(ply, ent)
			local target = net.ReadEntity()

			if !CarIsPassenger(ent, target) then return end

			target:ExitVehicle()
		end,
		canRun = function(ply, ent)
			return ent.IsSimfphyscar and #CarGetAllPassengers(ent) > 0 and ent:GetDriver() == ply
		end,
	},
	tiePlayer = {
		text = "Tie Player",
		icon = "icon16/attach.png",
		onRun = function(ply, ent)
			local item = ply:getChar():getInv():getFirstItemOfType("tie")
			item:interact("Use", ply)
		end,
		canRun = function(ply, ent)
			return ent:IsPlayer() and !ent:getNetVar("restricted") and ply:getChar():getInv():hasItem("tie")
		end,
	},
	checkRecords = {
		text = "View Records",
		icon = "icon16/application_form_magnify.png",
		onRun = function(ply, ent)
			nut.command.run(ply, "checkrecords", ent:SteamID())
		end,
		canRun = function(ply, ent)
			return ent:IsPlayer() && ent:getChar() && police[ply:Team()]
		end,
	},
	checkPlates = {
		text = "Check Plates",
		icon = "icon16/application_form_magnify.png",
		onRun = function(ply, ent)
			nut.command.run(ply, "checkplates")
		end,
		canRun = function(ply, ent)
			return ent:IsVehicle() && ent.IsSimfphyscar && ent:GetNW2Int("VehicleID") != 0 && police[ply:Team()] && ent:GetPos():Distance(ply:GetPos()) < 175
		end,
	},
	recruit = {
		text = "Recruit",
		icon = "icon16/group_add.png",
		onRun = function(ply, ent)
			nut.command.run(ply, "recruit", "@")
		end,
		canRun = function(ply, ent)
			return ent:GetPos():Distance(ply:GetPos()) < 175 && ply:getChar():getData("recruit") && ent:IsPlayer()
		end,
	},
	addKeys = {
		text = "Manage Keys",
		icon = "icon16/key.png",
		optionOverride = function(option)
			net.Start("vehicleKeysRetrieveData")
				net.WriteUInt(LocalPlayer():GetEyeTrace().Entity:GetNW2Int("VehicleID"), 32)
			net.SendToServer()
		end,
		canRun = function(ply, ent)
			local vehID = ent:GetNW2Int("VehicleID")
			local veh = nut.plugin.list.cardealer.loaded_vehicles[vehID]
			return ent.IsSimfphyscar && vehID != 0 && veh
		end,
	},
	robClothes = {
		text = "Rob Clothes",
		icon = "icon16/briefcase.png",
		onRun = function(ply, ent)
			nut.command.run(ply, "robclothes", {})
		end,
		canRun = function(ply, ent)
			return ent:IsPlayer() and ent:getNetVar("restricted") and !ent:getNetVar("cuffed")
		end,
	},
	apply_firstaidkit = {
		text = "Apply First Aid Kit",
		icon = "icon16/heart.png",
		onRun = function(ply, ent)
			local item = ply:getChar():getInv():getFirstItemOfType("firstaidkit")
			item:interact("use", ply)
		end,
		canRun = function(ply, ent)
			return ent:IsPlayer() and ply:getChar():getInv():hasItem("firstaidkit")
		end,
	},
	apply_bandages = {
		text = "Apply Bandages",
		icon = "icon16/heart.png",
		onRun = function(ply, ent)
			local item = ply:getChar():getInv():getFirstItemOfType("bandages")
			item:interact("use", ply)
		end,
		canRun = function(ply, ent)
			return ent:IsPlayer() and ply:getChar():getInv():hasItem("bandages")
		end,
	},
	apply_stitches = {
		text = "Apply Stitches",
		icon = "icon16/heart.png",
		onRun = function(ply, ent)
			local item = ply:getChar():getInv():getFirstItemOfType("stitches")
			item:interact("use", ply)
		end,
		canRun = function(ply, ent)
			return ent:IsPlayer() and ply:getChar():getInv():hasItem("stitches")
		end,
	},
	apply_splint = {
		text = "Apply Splint",
		icon = "icon16/heart.png",
		onRun = function(ply, ent)
			local item = ply:getChar():getInv():getFirstItemOfType("splint")
			item:interact("use", ply)
		end,
		canRun = function(ply, ent)
			return ent:IsPlayer() and ply:getChar():getInv():hasItem("splint")
		end,
	},
	
}

nut.util.include("cl_plugin.lua")
nut.util.include("sv_plugin.lua")