local PLUGIN = PLUGIN
PLUGIN.name = "Medical System"
PLUGIN.author = "rusty"

/*
	Permission Tables
*/

local isStaff = {
	founder = true,
	communitymanager = true,
	headadministrator = true
}

/*
	Functions
*/

nut = nut or {}
nut.medical = nut.medical or {}
nut.medical.injuryTypes = nut.medical.injuryTypes or {}

function nut.medical.createInjury(key, data)
	nut.medical.injuryTypes[key] = data

	if data.hooks then
        for hookName,func in next, data.hooks do
            hook.Add(hookName, "injury_"..key, func)
        end
    end
end

/*
	Metamethods
*/

local CHARACTER = nut.meta.character

function CHARACTER:giveInjury(key, noNetwork)
	local data = nut.medical.injuryTypes[key]
	if !data then return end

	local result = hook.Run("CharacterCanTakeInjury", self, key)
	if result == false then
		return
	end

	if SERVER then
		--self:setData("injury_"..key, true)
	end
	self:getPlayer():SetNW2Bool("injury_"..key, true)

	if data.duration then
		timer.Create("injury_"..key, data.duration, 1, function()
			self:takeInjury(key)
		end)
	end

	if SERVER and !noNetwork then
		net.Start("nutNetworkInjury")
			net.WriteString(key)
			net.WriteBool(true)
		net.Send(self:getPlayer())
	end

	hook.Run("CharacterInjuryGiven", self, key)
end

function CHARACTER:takeInjury(key, noNetwork)
	local data = nut.medical.injuryTypes[key]
	if !data then return end

	if SERVER then
		--self:setData("injury_"..key, nil)
	end
	self:getPlayer():SetNW2Bool("injury_"..key, nil)

	if data.duration and timer.Exists("injury_"..key) then
		timer.Destroy("injury_"..key)
	end

	if SERVER and !noNetwork then
		net.Start("nutNetworkInjury")
			net.WriteString(key)
			net.WriteBool(false)
		net.Send(self:getPlayer())
	end

	hook.Run("CharacterInjuryTaken", self, key)
end

local PLAYER = FindMetaTable("Player")

function PLAYER:hasInjury(key)
	return self:GetNW2Bool("injury_"..key, false)
end

/*
	Character Variables
*/

nut.char.registerVar("health", {
	field = "_health",
	default = 100
})

/*
	Hooks
*/

function PLUGIN:CharacterCanTakeInjury(character, injuryKey)
	local client = character:getPlayer()

	return client:Team() != FACTION_STAFF
end

/*
	Loading
*/

nut.util.include("cl_plugin.lua")
nut.util.include("sv_plugin.lua")

/*
	Commands
*/

nut.command.add("heal", {
	syntax = "<string name>",
	onCheckAccess = function(client)
		return isStaff[client:GetUserGroup()] || client:Team() == FACTION_STAFF
	end,
	onRun = function(client, arguments)
		local target = nut.command.findPlayer(client, arguments[1])	
		target:SetHealth(100)

		if target:hasInjury("bleeding") then
			target:getChar():takeInjury("bleeding")
		end

		if target:hasInjury("legShot") then
			target:getChar():takeInjury("legShot")
		end

		client:notify(target:Nick().. " has been cleared of all injuries and set to 100HP.")
	end
})