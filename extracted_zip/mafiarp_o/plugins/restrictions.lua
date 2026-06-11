-- oink.industries
-- lua source: gamemodes/1942rp/plugins/restrictions.lua
PLUGIN.name = "SAM Restrictions fix."
PLUGIN.author = "GeFake"
PLUGIN.desc = "Fixes SAM restrictions not working."

if !FindMetaTable("Player").GetLimit then
	return
end

function PLUGIN:PlayerSpawnProp(client)
	local limit = client:GetLimit('props')
	if limit < 0 then return end
	local props = (client:GetCount('props') + 1)


	if client:getNutData('extraProps') then	
		if props > (limit + 50) then
			client:LimitHit('props')
			return false
		end
	else
		if props > limit then
			client:LimitHit('props')
			return false
		end
	end
end

function PLUGIN:PlayerCheckLimit(ply, name)
	if name == "props" then
		if ply:GetLimit('props') < 0 then return end
		if ply:getNutData('extraProps') then
			local limit = ply:GetLimit('props') + 50 
			local props = ply:GetCount('props')
			if props <= limit + 50 then
				return true
			end
		end
	end
end

function PLUGIN:PlayerSpawnRagdoll(ply, model)
	local limit = ply:GetLimit('ragdolls')
	if limit < 0 then return end
	local ragdolls = (ply:GetCount('ragdolls') + 1)

	if ragdolls > limit then
		ply:LimitHit('ragdolls')
		return false
	end
end
