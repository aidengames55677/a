-- "gamemodes\\1942rp\\plugins\\drugs\\items\\base\\sh_drug.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ITEM.name = "Drug Base"
ITEM.model = "models/items/grenadeammo.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.desc = "A drug that does drug things."
ITEM.addictChance = 10 --the chance of addiction
ITEM.addiction = "drug_generic" --the withdrawal effect
ITEM.effect = "drug_weed" --the effect
ITEM.flag = "9"

local function onUse(item)
	item.player:EmitSound("ambient/voices/cough1.wav", 80, 110)
	item.player:ScreenFade(1, Color(150, 0, 0, 100), .8, 0)
end

ITEM:hook("_use", onUse)

ITEM.functions._use = { 
	name = "Use",
	tip = "useTip",
	icon = "icon16/bug.png",
	onRun = function(item)
		local client = item.player
		local char = client:getChar()
		if (char and client:Alive()) then
			if(math.random(1,100) < item.addictChance) then --chance of becoming an addict
				local drugW = DISEASES.diseases[item.effect]
				drugW.effect(client, char) --runs the drugs start function
				char:setData(item.addiction, CurTime()) --addiction debuff
				client:notify("You are now addicted to " .. item.name .. ".")
			end
			
			char:setData(item.effect, CurTime())
			local drug = DISEASES.diseases[item.effect]
			drug.effect(client, char) --runs the drugs start function
			
			return true
		end
		return false
	end,
	onCanRun = function(item)
		return (!IsValid(item.entity))
	end
}