-- "gamemodes\\mafiarp\\plugins\\pcasinos\\perfectcasino_entities\\entities\\pcasino_blackjack_table\\shared.lua"

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Blackjack Table"
ENT.Author = "Owain Owjo & The One Free-Man"
ENT.Category = "pCasino"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "StartRoundIn")
end

function ENT:GetPadByName(padName)
	if not self.padCache then
		self:GetCurrentPad(Vector(0, 0, 0)) -- Generate the cache
	end

	for i, _ in ipairs(self.padCache) do
		for k, v in pairs(_) do
			if k == padName then
				return k, v
			end
		end
	end
end

PerfectCasino.Core.RegisterEntity("pcasino_blackjack_table", {
	-- Bet data
	bet = {
		default = {d = 200, t = "num"}, -- The default bet
		max = {d = 300, t = "num"}, -- The default bet
		min = {d = 100, t = "num"}, -- The default bet
		iteration = {d = 25, t = "num"} -- The default bet
	},
	turn = {
		timeout = {d = 15, t = "num"}
	},
	payout = {
		win = {d = 2, t = "num"},
		blackjack = {d = 2.5, t = "num"}
	},
	general = {
		betPeriod = {d = 15, t = "num"} -- The default bet
	}
},
"models/freeman/owain_blackjack_table.mdl")