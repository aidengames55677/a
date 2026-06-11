-- "gamemodes\\mafiarp\\plugins\\pcasinos\\perfectcasino_entities\\entities\\pcasino_wheel_slot_machine\\shared.lua"

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Wheel Slot Machine"
ENT.Author = "Owain Owjo & The One Free-Man"
ENT.Category = "pCasino"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "CurrentJackpot")
end

PerfectCasino.Core.RegisterEntity("pcasino_wheel_slot_machine", {
	-- General data
	general = {
		limitUse = {d = true, t = "bool"}
	},
	-- Bet data
	bet = {
		default = {d = 5, t = "num"}, -- The default bet
	},
	-- Combo data
	combo = {
		{c = {"gold", "gold", "gold"}, p = 0.5, j = false},
		{c = {"coins", "coins", "coins"}, p = 0.8, j = false},
		{c = {"emerald", "emerald", "emerald"}, p = 1, j = false},
		{c = {"bag", "bag", "bag"}, p = 1.6, j = false},
		{c = {"bar", "bar", "bar"}, p = 2, j = false},
		{c = {"coin", "coin", "coin"}, p = 2.5, j = false},
		{c = {"coin", "coin", "anything"}, p = 2, j = false},
		{c = {"anything", "coin", "coin"}, p = 2, j = false},
		{c = {"vault", "vault", "vault"}, p = 2.8, j = false},
		{c = {"chest", "anything", "anything"}, p = 0, j = true},
		{c = {"anything", "chest", "anything"}, p = 0, j = true},
		{c = {"anything", "anything", "chest"}, p = 0, j = true},
	},
	-- Combo data
	wheel = {
		{n = "$500", f = "money", i = 500, p = "dolla"},
		{n = "$1,000", f = "money", i = 1000, p = "dolla"},
		{n = "$2,000", f = "money", i = 2000, p = "dolla"},
		{n = "$5,000", f = "money", i = 5000, p = "dolla"},
		{n = "Jackpot!", f = "jackpot", i = 7500, p = "diamond"},
		{n = "Nothing", f = "nothing", i = 1, p = "melon"},
		{n = "$10", f = "money", i = 10, p = "dolla"},
		{n = "$50", f = "money", i = 50, p = "dolla"},
		{n = "$100", f = "money", i = 100, p = "dolla"},
		{n = "$200", f = "money", i = 200, p = "dolla"},
		{n = "Nothing", f = "nothing", i = 1, p = "melon"},
		{n = "$1", f = "money", i = 1, p = "dolla"}
	},
	-- Jackpot data
	jackpot = {
		toggle = {d = true, t = "bool"}, -- The bell chance
		startValue = {d = 100, t = "num"}, -- The bell chance
		betAdd = {d = 0.3, t = "num"}, -- The % of the bet to add to the jackpot
	},
	-- Chance data
	chance = {
		gold = {d = 15},
		coins = {d = 10},
		emerald = {d = 9},
		bag = {d = 8},
		bar = {d = 8},
		coin = {d = 8},
		vault = {d = 5},
		chest = {d = 0.1},
	},
},
"models/freeman/owain_slotmachine_wheel.mdl")