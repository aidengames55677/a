function PLUGIN:PlayerInitialSpawn(player)
	-- Initialize the player's sub-faction to a default value when they spawn.
	self:setPlayerSubFaction(player, "default")
end
