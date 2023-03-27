local DataStoreService = game:GetService("DataStoreService")

local DataModule = script:FindFirstAncestor("DataModule")
local DataManger = require(DataModule.Modules.DataManger)

local function saveData(CachedData)
	--[[
		Forces to saves the player's data to the datastore without cleans up any data
		associated with them

		Parameters:
		player: The player to save data for and clean up resources for
		dataKey: The name of the instance in the cache
	]]
	return function(userId, dataKey)
		assert(type(userId) == "number", "userId should be a number")
		assert(type(dataKey) == "string", "data key should be a string")
		
		local playerData = CachedData.data[userId]
		
		if not playerData then
			warn(string.format("User with ID %d not found in cached data", userId))
			return
		end

		for dataStore, data in pairs(playerData) do
			if data[dataKey] then
				local success, errorMessage = pcall(function()
					-- Get Global DataStore
					local dataStore = DataStoreService:GetDataStore(dataStore)
					return DataManger.saveDataAsync(dataStore, userId, data)
				end)

				if not success then
					warn(string.format("Failed to save %d's data: %s", userId, errorMessage))
				end
				return 
			end
		end
		
		-- Value not found in cache
		warn(string.format("Key %s does not exist in the data for user %d", dataKey, userId))
		return false
	end
end

return saveData
