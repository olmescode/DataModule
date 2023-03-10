local DataStoreService = game:GetService("DataStoreService")

local DataModule = script:FindFirstAncestor("DataModule")
local DataManger = require(DataModule.Modules.DataManger)

local remotes = DataModule.Remotes

local function setExtraPlayerData(playerData, allPlayerData)
	for dataStoreKey, dataStoreValue in pairs(allPlayerData) do
		if not playerData[dataStoreKey] then
			playerData[dataStoreKey] = dataStoreValue
		end
	end

	return playerData
end

local function onPlayerAdded(CachedData)
	--[[
		Loads the data that the player has and sends that data
		to the client

		Parameters:
		player: The player to send data to
	]]
	return function(dataStore, userId, data)
		local success, playerData = pcall(function()
			-- Get Global DataStore
			local dataStore = DataStoreService:GetDataStore(dataStore)
			return DataManger.loadDataAsync(dataStore, userId)
		end)
		
		if success then
			if not playerData then
				warn(string.format("User %d does not have registered data in DataStore %s", userId, dataStore))
				playerData = {}
			end
			-- Fill
			playerData = setExtraPlayerData(playerData, data)
			
			CachedData.data[userId] = CachedData.data[userId] or {}
			CachedData.data[userId][dataStore] = playerData

			--remotes.onPlayerAdded:FireClient(player, playerData)
		else
			local warning = "There was an error getting the data for the "
				.. "player with UserId: "
				.. userId
				.. ".\n\nIf you are running in Studio, make sure is enabled "
				.. "'Studio Access to API Services'"

			warn(warning)
			--playerDataRemote:FireClient(player, {})
		end
	end
end

return onPlayerAdded
