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
	return function(player, resetOnPlayerRemoving)
		local playerData = CachedData.data[player.UserId]
		
		if playerData then
			for dataStore, data in pairs(playerData) do
				local dataStore = DataStoreService:GetDataStore(dataStore)
				local success = nil
				local errorMessage
				
				if resetOnPlayerRemoving then
					success, errorMessage = pcall(function()
						DataManger.removeDataAsync(dataStore, player.UserId)
					end)
				else
					success, errorMessage = pcall(function()
						DataManger.updateDataAsync(dataStore, player.UserId, data)
					end)
				end
				
				if not success then
					warn(errorMessage)
				end
			end
		end
		
		CachedData.clearCache(player.UserId)
	end
end

return onPlayerRemoved
