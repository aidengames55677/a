-- "gamemodes\\mafiarp\\plugins\\pcasinos\\sh_plugin.lua"

local PLUGIN = PLUGIN
PLUGIN.name = "PCasinos"
PLUGIN.author = "Owain and rusty"
PLUGIN.desc = "The popular gmodstore addon ported to nutscript."

PerfectCasino = {}
PerfectCasino.Config = {}
PerfectCasino.Log = {}
PerfectCasino.Translation = {}
PerfectCasino.Core = {}
PerfectCasino.Sound = {}
PerfectCasino.UI = {}
PerfectCasino.Database = {}
PerfectCasino.Cooldown = {}
PerfectCasino.Chips = {}
PerfectCasino.Cards = {}
PerfectCasino.MachineLimits = {}
if CLIENT then
	PerfectCasino.Spins = 0
else
	PerfectCasino.Spins = {}
end

print("Loading PerfectCasino")

nut.util.includeDir(PLUGIN.path.."/perfectcasino", true, true)

function PLUGIN:OnLoaded()
	-- gotta load this ourselves because nutscript loads the folder too early
	nut.plugin.loadEntities(PLUGIN.path.."/perfectcasino_entities")
end

local path = PLUGIN.path.."/perfectcasino/"
if SERVER then
	--resource.AddWorkshop("2228228831")
end

if CLIENT then
	/*
	-- Font was loading funny and this seems to fix it
	hook.Add("PostDrawHUD", "_pcasino_fixfonts", function()
		include(path.."derma/cl_fonts.lua") 
		hook.Remove("PostDrawHUD", "_pcasino_fixfonts")
	end)
	*/
end
print("Loaded PerfectCasino")

/*
	Hooks
*/

function PLUGIN:pCasinoCanInteract(ply, entity, callback)
	local accountID = entity:GetNW2Int( "npc", 0 )

	if accountID == 0 then
		ply:notify("This casino table doesn't have an NPC assigned to it.")
		callback( false )
		return
	end

	local npc = CasinoNPC:GetNPC( accountID )
	if not IsValid( npc ) then
		ply:notify("This casino table's NPC is not active.")
		callback( false )
		return
	elseif npc:GetBalance() <= 0 then
		ply:notify("This casino doesn't have enough to play!")
		callback( false )
		return
	end

	CasinoNPC:GetPlayerPerms( ply, npc:GetCasinoID(), function( _, isBanned )
		if isBanned then
			ply:notify("You don't have permission to play at this casino!")
		end

		callback(not isBanned)
	end )
end

function PLUGIN:pCasinoOnBlackjackBet(ply, machine, betAmount)
	local npc = CasinoNPC:GetNPC( machine:GetNW2Int( "npc", 0 ) )
	if IsValid( npc ) then
		CasinoNPC:AcceptDepositFromUser( ply, npc, betAmount )
		ply.LastBet = CurTime()
	end
end

function PLUGIN:pCasinoOnBlackjackPayout(ply, machine, betAmount)
	local npc = CasinoNPC:GetNPC( machine:GetNW2Int( "npc", 0 ) )
	if IsValid( npc ) then
		CasinoNPC:PayoutMoneyToUser( ply, npc, betAmount )
	end
end

function PLUGIN:pCasinoOnMysteryWheelBet(ply, machine, betAmount)
	local npc = CasinoNPC:GetNPC( machine:GetNW2Int( "npc", 0 ) )
	if IsValid( npc ) then
		CasinoNPC:AcceptDepositFromUser( ply, npc, betAmount )
		ply.LastBet = CurTime()
	end
end

function PLUGIN:pCasinoOnRouletteBet(ply, machine, betAmount)
	local npc = CasinoNPC:GetNPC( machine:GetNW2Int( "npc", 0 ) )
	if IsValid( npc ) then
		CasinoNPC:AcceptDepositFromUser( ply, npc, betAmount )
		ply.LastBet = CurTime()
	end
end

function PLUGIN:pCasinoOnRoulettePayout(ply, machine, betAmount)
	local npc = CasinoNPC:GetNPC( machine:GetNW2Int( "npc", 0 ) )
	if IsValid( npc ) then
		CasinoNPC:PayoutMoneyToUser( ply, npc, betAmount )
	end
end

function PLUGIN:pCasinoOnBasicSlotMachineBet(ply, machine, betAmount)
	local npc = CasinoNPC:GetNPC( machine:GetNW2Int( "npc", 0 ) )
	if IsValid( npc ) then
		npc:SetBalance( npc:GetBalance() + betAmount )
		CasinoNPC:AcceptDepositFromUser( ply, npc, betAmount )
		ply.LastBet = CurTime()
	end
end

function PLUGIN:pCasinoOnBasicSlotMachinePayout(ply, machine, betAmount)
	local npc = CasinoNPC:GetNPC( machine:GetNW2Int( "npc", 0 ) )
	if IsValid( npc ) then
		CasinoNPC:PayoutMoneyToUser( ply, npc, betAmount )
	end
end

function PLUGIN:pCasinoOnBasicSlotMachineJackpot(ply, machine, betAmount)
	local npc = CasinoNPC:GetNPC( machine:GetNW2Int( "npc", 0 ) )
	if IsValid( npc ) then
		CasinoNPC:PayoutMoneyToUser( ply, npc, betAmount )
	end
end

function PLUGIN:pCasinoOnWheelSlotMachineBet(ply, machine, betAmount)
	local npc = CasinoNPC:GetNPC( machine:GetNW2Int( "npc", 0 ) )
	if IsValid( npc ) then
		CasinoNPC:AcceptDepositFromUser( ply, npc, betAmount )
		ply.LastBet = CurTime()
	end
end

function PLUGIN:pCasinoOnWheelSlotMachinePayout(ply, machine, betAmount)
	local npc = CasinoNPC:GetNPC( machine:GetNW2Int( "npc", 0 ) )
	if IsValid( npc ) then
		CasinoNPC:PayoutMoneyToUser( ply, npc, betAmount )
	end
end

function PLUGIN:CanPlayerUseChar(client, character)
	if client.LastBet and client.LastBet > CurTime() - 120 and client:getChar() then
		return false, "You can't switch characters this soon after making a bet!"	
	end
end

/*
	Commands
*/

local CanManagePCasino = {
	founder = true,
	communitymanager = true,
	headadministrator = true,
	superadministrator = true,
	superadmin = true,
}

nut.command.add("casinosetnpc", {
	syntax = "<number npcID>",
	onCheckAccess = function(client)
		return CanManagePCasino[client:GetUserGroup()]
	end,
	onRun = function(client, args)
		local npcID = tonumber(args[1])
		if !npcID then
			return "Invalid Casino NPC ID argument"
		end

		local target = client:GetEyeTraceNoCursor().Entity
		if !target or !target.DatabaseID then
			return "This is not a valid pCasino entity."
		end

		target:SetNW2Int("npc", npcID)
		PerfectCasino.Database.UpdateNPC(target.DatabaseID, npcID)

		return "Account successfully set for this casino entity."
	end,
})

nut.command.add("casinogetnpc", {
	onCheckAccess = function(client)
		return CanManagePCasino[client:GetUserGroup()]
	end,
	onRun = function(client, args)
		local target = client:GetEyeTraceNoCursor().Entity
		if !target or !target.DatabaseID then
			return "This is not a valid pCasino entity."
		end

		return "This casino entity is linked to Casino NPC #" .. target:GetNW2Int("npc", 0)
	end,
})