local function getDatastoreKeyForPlayer(player: Player)
	return tostring(player.UserId)
end

return getDatastoreKeyForPlayer
