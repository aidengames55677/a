local PLUGIN = PLUGIN
PLUGIN.name = "Fix Character Networking"
PLUGIN.author = "rusty"

if SERVER then
	function PLUGIN:InitializedPlugins()
		function nut.plugin.list.multichar:PlayerNutDataLoaded(client)
			nut.char.restore(client, function(charList)
				if (!IsValid(client)) then return end

				MsgN(
					"Loaded ("..table.concat(charList, ", ")..") for "
					..client:Name()
				)

				local stack = util.Stack()
				client.characterNetworkStack = stack

				for k, v in ipairs(charList) do
					if (nut.char.loaded[v]) then
						stack:Push(nut.char.loaded[v])
					end
				end

				for k, v in ipairs(player.GetAll()) do
					if (v:getChar()) then
						stack:Push(v:getChar())
					end
				end

				hook.Add("Tick", client:SteamID().."characterNetwork", function()
					local stack = client.characterNetworkStack
					if stack and stack:Size() > 0 then
						local character = stack:Pop()
						character:sync(client)

						if stack:Size() == 0 then
							hook.Remove("Tick", client:SteamID().."characterNetwork")

							client.nutCharList = charList
							PLUGIN:syncCharList(client)
							client.nutLoaded = true

							client:setNutData("intro", true)
						end
					end
				end)
			end)
		end
	end
end