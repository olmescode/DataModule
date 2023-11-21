local function retrieveData(CachedData)
	--[[
		Allows to retrieve data from CahedData

		Parameters:
		player: The player whose data to retrieve
		valueName: The name of the data in the cache
	]]
	return function(player: Player, valueName: string)
		assert(player:IsA("Player"), "player should be a Player")
		assert(type(valueName) == "string", "valueName should be a string")
		
		local playerData = CachedData._playerData[player]
		
		if not playerData then
			warn(string.format("Player %s not found in cached data", player.Name))
			return
		end

		for dataStore, data in pairs(playerData) do
			if data[valueName] then
				return data[valueName]
			end
		end
		
		-- Value not found in cache
		warn(string.format("Player %s does not have %s in the cache", player.Name, valueName))
		return false
	end
end

return retrieveData
