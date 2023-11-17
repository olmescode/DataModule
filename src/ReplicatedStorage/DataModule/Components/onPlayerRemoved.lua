local DataStoreService = game:GetService("DataStoreService")

local DataModule = script:FindFirstAncestor("DataModule")
local DataManger = require(DataModule.Modules.DataManger)

local function onPlayerRemoved(CachedData)
	--[[
		Saves the player's data to the datastore and cleans up any data
		associated with them

		Parameters:
		player: The player to save data for and clean up resources for
	]]
	return function(userId, resetOnPlayerRemoving)
		local playerData = CachedData.data[userId]
		
		if playerData then
			for dataStore, data in pairs(playerData) do
				local dataStore = DataStoreService:GetDataStore(dataStore)
				local success = nil
				local errorMessage
				
				if resetOnPlayerRemoving then
					success, errorMessage = pcall(function()
						DataManger.removeDataAsync(dataStore, userId)
					end)
				else
					success, errorMessage = pcall(function()
						DataManger.updateDataAsync(dataStore, userId, data)
					end)
				end
				
				if not success then
					warn(errorMessage)
				end
			end
		end
		
		-- Clear out saved values for this player to avoid memory leaks
		CachedData.clearCache(userId)
		CachedData._threadsPendingPlayerDataLoad[userId] = nil
		CachedData._playerDataLoadErrors[userId] = nil
	end
end

return onPlayerRemoved
