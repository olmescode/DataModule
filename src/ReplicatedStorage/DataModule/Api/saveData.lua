local DataStoreService = game:GetService("DataStoreService")

local DataModule = script:FindFirstAncestor("DataModule")
local DataManger = require(DataModule.Modules.DataManger)
local getDatastoreKeyForPlayer = require(DataModule.Modules.getDatastoreKeyForPlayer)

local function saveData(CachedData)
	--[[
		Forces to saves the player's data to the datastore without cleans up any data
		associated with them

		Parameters:
		player: The player to save data for
		valueName: The name of the instance in the cache
	]]
	return function(player: Player, valueName: string)
		assert(player:IsA("Player"), "player should be a player")
		assert(type(valueName) == "string", "valueName should be a string")
		
		local playerData = CachedData._playerData[player]
		
		if not playerData then
			warn(string.format("Player %s not found in cached data", player.Name))
			return
		end

		for dataStore, data in pairs(playerData) do
			if data[valueName] then
				local success, errorMessage = pcall(function()
					-- Get Global DataStore
					local key = getDatastoreKeyForPlayer(player)
					local dataStore = DataStoreService:GetDataStore(dataStore)
					return DataManger.saveDataAsync(dataStore, key, data)
				end)

				if not success then
					warn(string.format("Failed to save %s's data: %s", player.Name, errorMessage))
				end
				return 
			end
		end
		
		-- Value not found in cache
		warn(string.format("Value %s does not exist in the data for the player %s", valueName, player.Name))
		return false
	end
end

return saveData
