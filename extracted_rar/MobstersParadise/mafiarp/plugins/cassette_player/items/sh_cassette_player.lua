-- "gamemodes\\mafiarp\\plugins\\cassette_player\\items\\sh_cassette_player.lua"

ITEM.name = "Cassette Player"
ITEM.model = "models/devcon/mrp/props/player_2.mdl"
ITEM.desc = "A type of tape machine used for playing audio cassettes."
ITEM.category = "Cassette"
ITEM.uniqueID = "cassette_player"

ITEM.functions.use = {
	name = "Place",
	onRun = function(item)
		local cassettePlayer = ents.Create("cassette_player")
		cassettePlayer:SetPos(item.player:getItemDropPos())
		cassettePlayer:Spawn()
		cassettePlayer:Activate()
		cassettePlayer:GetPhysicsObject():EnableMotion(true)
		return true
	end
}
