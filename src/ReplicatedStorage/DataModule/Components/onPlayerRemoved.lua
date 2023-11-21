local DataStoreService = game:GetService("DataStoreService")

local DataModule = script:FindFirstAncestor("DataModule")

local DataManger = require(DataModule.Modules.DataManger)
local getDatastoreKeyForPlayer = require(DataModule.Modules.getDatastoreKeyForPlayer)

local function onPlayerRemoved(CachedData)
	--[[
		Saves the player's data to the datastore and cleans up any data
		associated with them

		Parameters:
		player: The player to save data for and clean up resources for
		resetOnPlayerRemoving: A boolean that determines if the player's data should be reset
		when they leave the game.
	]]
	return function(player: Player, resetOnPlayerRemoving: boolean?)
		local playerData = CachedData._playerData[player]
		
		if playerData then
			for dataStore, data in pairs(playerData) do
				local key = getDatastoreKeyForPlayer(player)
				local dataStore = DataStoreService:GetDataStore(dataStore)
				local success = nil
				local errorMessage
				
				if resetOnPlayerRemoving then
					success, errorMessage = pcall(function()
						DataManger.removeDataAsync(dataStore, key)
					end)
				else
					success, errorMessage = pcall(function()
						DataManger.updateDataAsync(dataStore, key, data)
					end)
				end
				
				if not success then
					warn(errorMessage)
				end
			end
		end
		
		-- Clear out saved values for this player to avoid memory leaks
		CachedData.clearCache(player)
	end
end

return onPlayerRemoved
