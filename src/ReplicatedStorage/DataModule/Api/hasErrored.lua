local function hasErrored(CachedData)
	--[[
		Returns true if PlayerDataServer was unable to load the player's 
		data (typically due to a DataStoreService or session lock error)

		Parameters:
		player: The player to check if data has loaded for
	]]
	return function(player: Player)
		return CachedData._playerDataLoadErrors[player.UserId] and true or false
	end
end

return hasErrored
