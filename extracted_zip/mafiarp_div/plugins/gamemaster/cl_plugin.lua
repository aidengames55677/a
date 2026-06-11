-- "gamemodes\\mafiarp\\plugins\\gamemaster\\cl_plugin.lua"

local PLUGIN = PLUGIN

/*
	Networking
*/

local function nutGamemasterInfo(len)
	local count = net.ReadUInt(32)
	for i = 1, count do
		PLUGIN.Gamemasters[net.ReadString()] = net.ReadBool() and true or nil
	end
end
net.Receive("nutGamemasterInfo", nutGamemasterInfo)

local function nutOpenGamemasters(len)
	vgui.Create("nutGamemasters")
end
net.Receive("nutOpenGamemasters", nutOpenGamemasters)

local function nutGamemasterLogs(len)
	local dataLength = net.ReadUInt(32)
	local data = net.ReadData(dataLength)
	local decodedData = pon.decode(data)

	local pnl = vgui.Create("nutGMLogs")
	pnl:PopulateData(decodedData)
end
net.Receive("nutGamemasterLogs", nutGamemasterLogs)

/*
	this sucks.
*/

local function OpenAcknowledgements(spawnReason, isEventItem, target, item)
	Derma_Query(
		"Do you acknowledge that this spawning will be logged and available to be viewed by UA, as well as the answers you have provided?", 
		"Acknowledgement", 
		"Yes", 
		function() 
			Derma_Query(
				"Do you acknowledge that if this item was unjustly spawned you may be subject to punishment?", 
				"Acknowledgement", 
				"Yes", 
				function() 
					net.Start("nutItemSpawnPrompt")
						net.WriteBool(true)
						net.WriteBool(isEventItem)
						net.WriteString(spawnReason)
						net.WriteString(item)
					net.SendToServer()

					nut.command.send("chargiveitem", target, item)
				end, 
				"No", 
				function() 
					net.Start("nutItemSpawnPrompt")
						net.WriteBool(false)
						net.WriteBool(false)
						net.WriteString("")
					net.SendToServer()
				end
			)
		end, 
		"No", 
		function() 
			net.Start("nutItemSpawnPrompt")
				net.WriteBool(false)
				net.WriteBool(false)
				net.WriteString("")
			net.SendToServer()
		end
	)
end

local function nutItemSpawnPrompt(len)
	local target = net.ReadString()
	local item = net.ReadString()

	Derma_StringRequest(
		"Spawn Item", 
		"Why are you spawning this item? (Describe)", 
		"", 
		function(text)
			Derma_Query(
				"Is this item being used for an event?", 
				"Item Use Case", 
				"Yes", 
				function() 
					OpenAcknowledgements(text, true, target, item)
				end, 
				"No", 
				function() 
					Derma_Query(
						"Are you sure you still want to spawn this item, even though it's not being used for an event?", 
						"Are you sure?", 
						"Yes", 
						function() 
							OpenAcknowledgements(text, false, target, item)
						end, 
						"No",
						function()
							net.Start("nutItemSpawnPrompt")
								net.WriteBool(false)
								net.WriteBool(false)
								net.WriteString("")
							net.SendToServer()
						end
					)
				end
			)
		end, 
		function()
			net.Start("nutItemSpawnPrompt")
				net.WriteBool(false)
				net.WriteBool(false)
				net.WriteString("")
			net.SendToServer()
		end, 
		"Next"
	)
end
net.Receive("nutItemSpawnPrompt", nutItemSpawnPrompt)

/*
	Hooks
*/

function PLUGIN:InitPostEntity()
	net.Start("nutGamemasterInfo")
	net.SendToServer()
end

/*
	Commands
*/

nut.command.add("gamemasteradd", {
	syntax = "<string steamID>",
	onRun = function() end
})

nut.command.add("gamemasterremove", {
	syntax = "<string steamID>",
	onRun = function() end
})

nut.command.add("gamemasters", {
	syntax = "<none>",
	onRun = function() end
})

nut.command.add("gamemasterlogs", {
	syntax = "",
	onRun = function() end
})