local function isLoadingData(CachedData)
	--[[
		Returns true if the server is currently loading the player's data

		Parameters:
		player: The player to check if data has loaded for
	]]
	return function(player: Player)
		local threadsPendingLoad = CachedData._threadsPendingPlayerDataLoad[player]

		if threadsPendingLoad then
			return true
		end

		return false
	end
end

return isLoadingData
