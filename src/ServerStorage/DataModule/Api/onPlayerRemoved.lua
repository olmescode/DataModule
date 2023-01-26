local DataStoreService = game:GetService("DataStoreService")

local DataModule = script:FindFirstAncestor("DataModule")
local DataManger = require(DataModule.Modules.DataManger)

local function onPlayerRemoved(player, CachedData)
	--[[
		Saves the player's data to the datastore and cleans up any data
		associated with them

		Parameters:
		player: The player to save data for and clean up resources for
	]]
	return function(player)
		local playerData = CachedData.data[player.UserId]
		
		if playerData then
			for dataStore, data in pairs(playerData) do
				local success, errorMessage = pcall(function()
					-- Get Global DataStore
					local dataStore = DataStoreService:GetDataStore(dataStore)
					return DataManger.updateDataAsync(dataStore, player.UserId, data)
				end)

				if not success then
					warn(errorMessage)
				end
			end
		end
		
		CachedData.clearCache(player.UserId)
	end
end

return onPlayerRemoved
