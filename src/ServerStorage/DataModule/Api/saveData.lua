local DataStoreService = game:GetService("DataStoreService")

local DataModule = script:FindFirstAncestor("DataModule")
local DataManger = require(DataModule.Modules.DataManger)

local function saveData(CachedData)
	--[[
		Forces to saves the player's data to the datastore without cleans up any data
		associated with them

		Parameters:
		player: The player to save data for and clean up resources for
	]]
	return function(userId, dataKey)
		local playerData = CachedData.data[userId]
		
		if not playerData then
			warn(string.format("User with ID %d not found in cached data", userId))
			return
		end

		if playerData then
			for dataStore, data in pairs(playerData) do
				if data[dataKey] then
					local success, errorMessage = pcall(function()
						-- Get Global DataStore
						local dataStore = DataStoreService:GetDataStore(dataStore)
						return DataManger.updateDataAsync(dataStore, userId, data)
					end)

					if not success then
						warn(errorMessage)
					end
					
					return true
				end
			end
		end
	end
end

return saveData
