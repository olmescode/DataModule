local function retrieveData(CachedData)
	--[[
		Allows to retrieve data from CahedData

		Parameters:
		userId: The player userId to get the data from
		dataKey: The name of the data in the cache
	]]
	return function(userId, dataKey)
		assert(type(userId) == "number", "userId should be a number")
		assert(type(dataKey) == "string", "data key should be a string")
		
		local playerData = CachedData._playerData[userId]
		
		if not playerData then
			warn(string.format("User with ID %d not found in cached data", userId))
			return
		end

		for dataStore, data in pairs(playerData) do
			if data[dataKey] then
				return data[dataKey]
			end
		end
		
		-- Value not found in cache
		warn(string.format("User with ID %d does not have %s in the cache", userId, dataKey))
		return false
	end
end

return retrieveData
