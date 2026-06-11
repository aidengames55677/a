-- "gamemodes\\mafiarp\\schema\\items\\sh_hifi.lua"

ITEM.name = "Hi-Fi"
ITEM.desc = "A machine that can play music."
ITEM.model = "models/polievka/1950shifi.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.entdrop = "hifi"
ITEM.limits = true
ITEM.limit = 1

ITEM.functions = {}
ITEM.functions.Drop = nil
ITEM.functions.Use = {
	name = "Use",
	icon = "icon16/cursor.png",
	onRun = function(item, player, client)
	local client = item.player
	
if item.limits == true then
	local NumEnts = 0	
	for k, v in pairs( ents.FindByClass( item.entdrop ) ) do
		if v.SteamID == client:SteamID() then
			NumEnts = NumEnts + 1
		end
	end
		if NumEnts >= item.limit then
			client:notify("You have reached maximum amount of " .. item.name .. "s." )
			return false
		end
		
		item.player:EmitSound( "physics/flesh/flesh_bloody_break.wav", 75, 200 )		
		local ent = ents.Create( item.entdrop )
		ent:SetPos(item.player:EyePos() + ( item.player:GetAimVector() * 50))
		ent:Spawn()
		ent.Owner = client
		ent.SteamID = client:SteamID()
		return true
		
	else
		item.player:EmitSound( "physics/flesh/flesh_bloody_break.wav", 75, 200 )
			local ent = ents.Create( item.entdrop )
			ent:SetPos(item.player:EyePos() + ( item.player:GetAimVector() * 50))
			ent:Spawn()
			ent.Owner = client
			ent.SteamID = client:SteamID()
			
	return true
	end
end
}