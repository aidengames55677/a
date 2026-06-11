-- "gamemodes\\mafiarp\\plugins\\pcasinos\\perfectcasino_entities\\entities\\pcasino_mystery_wheel\\shared.lua"

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Mysterly Wheel"
ENT.Author = "Owain Owjo & The One Free-Man"
ENT.Category = "pCasino"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Spawnable = false
ENT.AdminSpawnable = false

PerfectCasino.Core.RegisterEntity("pcasino_mystery_wheel", {
	general = {
		useFreeSpins = {d = true, t = "bool"} -- Can you use free spins on this machine
	},
	buySpin = {
		buy = {d = false, t = "bool"}, -- Can you buy a spin on this machine
		cost = {d = 1000000, t = "int"}, 
	},
	-- Combo data
	wheel = { -- I know, 20 slots :O
		{n = "$1", f = "money", i = 1, p = "dolla"},
		{n = "Nothing", f = "nothing", i = "nil", p = "melon"},
		{n = "$250,000", f = "money", i = 250000, p = "dolla"},
		{n = "Spin Again", f = "prize_wheel", i = "nil", p = "mystery_1"},
		{n = "$1,000,000", f = "money", i = 1000000, p = "dolla"},
		{n = "$50,000", f = "money", i = 50000, p = "dolla"},
		{n = "Nothing", f = "nothing", i = "nil", p = "melon"},
		{n = "$100,000", f = "money", i = 100000, p = "dolla"},
		{n = "Nothing", f = "nothing", i = "nil", p = "melon"},
		{n = "$10,000", f = "money", i = 10000, p = "dolla"},
		{n = "Nothing", f = "nothing", i = "nil", p = "melon"},
		{n = "$5,000", f = "money", i = 5000, p = "dolla"},
		{n = "Nothing", f = "nothing", i = "nil", p = "melon"},
		{n = "$500", f = "money", i = 500, p = "dolla"},
		{n = "Nothing", f = "nothing", i = "nil", p = "melon"},
		{n = "$7,500", f = "money", i = 7500, p = "dolla"},
		{n = "Nothing", f = "nothing", i = "nil", p = "melon"},
		{n = "$2,500", f = "money", i = 2500, p = "dolla"},
		{n = "Nothing", f = "nothing", i = "nil", p = "melon"},
		{n = "$1,000", f = "money", i = 1000, p = "dolla"},
		{n = "Nothing", f = "nothing", i = "nil", p = "melon"},
	}
},
"models/freeman/owain_mystery_wheel.mdl")