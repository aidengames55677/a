-- "gamemodes\\mafiarp\\plugins\\pcasinos\\perfectcasino\\config\\sh_config.lua"

-----------------------
--      IMPORTANT     -
-----------------------
-- The creation of the entities is done in-game with the toolgun.
-- This allows for you to easily have several of the same machine with different configurations,
-- making the addon easier to use in the process.


/* ============
 General Config
=============*/

-- Chat prefix
PerfectCasino.Config.PrefixColor = Color(175, 0, 0)
PerfectCasino.Config.Prefix = "[Casinos]"

--- The usergroups/SteamIDs that get access to the in-game entity maker
PerfectCasino.Config.AccessGroups = {}
PerfectCasino.Config.AccessGroups["founder"] = true
PerfectCasino.Config.AccessGroups["communitymanager"] = true
PerfectCasino.Config.AccessGroups["superadmin"] = true
PerfectCasino.Config.AccessGroups["headadministrator"] = true
PerfectCasino.Config.AccessGroups["superadministrator"] = true


-- The following functions are for developers to add support to the currency they're using. By default it's set up for DarkRP
function PerfectCasino.Config.AddMoney(ply, amount)
	ply:getChar():giveMoney(amount)
end
function PerfectCasino.Config.CanAfford(ply, amount)
	return ply:getChar() and ply:getChar():hasMoney(amount)
end
function PerfectCasino.Config.FormatMoney(amount)
	return nut.currency.get(amount)
end


-- These are the reward functions that are run when prize wheels are triggered
-- ply is the user that is receiving the reward.
-- ent is the entity that is linked to the win. Most likely a slot machine or a prize wheel.
-- inputValue is the custom input used in the in-game config menu. This way, you can have 1 function for giving money, and just
-- provide it with different inputs
-- You can also return a string that will be a custom message, otherwise it will default to a preset one in the language file.
PerfectCasino.Config.RewardsFunctions = {}

-- No reward
PerfectCasino.Config.RewardsFunctions["nothing"] = function(ply, ent, inputValue)
	-- They won nothing, do nothing
end
-- RP money
PerfectCasino.Config.RewardsFunctions["money"] = function(ply, ent, inputValue)
	local npc = CasinoNPC:GetNPC( machine:GetNW2Int( "npc", 0 ) )
	if IsValid( npc ) then
		if npc:GetBalance() >= inputValue then
			PerfectCasino.Config.AddMoney(ply, inputValue)
			CasinoNPC:PayoutMoneyToUser( ply, npc, inputValue )
		else
			PerfectCasino.Config.AddMoney(ply, npc:GetBalance())
			CasinoNPC:PayoutMoneyToUser( ply, npc, npc:GetBalance() )

			ply:notify("You've broken this casino's bank! You've been paid out all they had!")
		end
	end
end
-- The machines Jackpot. This will only work on machines with jackpots.
PerfectCasino.Config.RewardsFunctions["jackpot"] = function(ply, ent, inputValue)
	local jackpotAmount = ent:GetCurrentJackpot()
	local npc = CasinoNPC:GetNPC( machine:GetNW2Int( "npc", 0 ) )
	
	if IsValid( npc ) then
		if npc:GetBalance() >= jackpotAmount then
			PerfectCasino.Config.AddMoney(ply, jackpotAmount)
			ent:SetCurrentJackpot(ent.data.jackpot.startValue) -- Reset the jackpot
			CasinoNPC:PayoutMoneyToUser( ply, npc, inputValue )
		else
			PerfectCasino.Config.AddMoney(ply, npc:GetBalance())
			CasinoNPC:PayoutMoneyToUser( ply, npc, npc:GetBalance() )
			
			ply:notify("You've broken this casino's bank! You've been paid out all they had!")
			return ""
		end
	end

	return "You have hit the jackpot, the payout is "..PerfectCasino.Config.FormatMoney(jackpotAmount)
end
-- Prize Wheel
PerfectCasino.Config.RewardsFunctions["prize_wheel"] = function(ply, ent, inputValue)
	PerfectCasino.Core.GiveFreeSpin(ply)
end

if SERVER then return end
-- Here you can add custom icons that can be used in the prize wheels.
-- The formatting is as follows:
-- 1st argument: A unique name. This must be lowercase and have no spaces or special characters.
-- 2nd argument: This is the display name. This can be anything you like and will be what shows up the UIs
-- 3rd argument: This is the URL to the image. It must be a PNG and will be rescaled to a 1:1 aspect ration, so to provide it as a square image will help keep quality.
-- Example:

--PerfectCasino.Core.AddIcon("car", "Car", "https://0wain.xyz/icons/pcasino/car.png")
