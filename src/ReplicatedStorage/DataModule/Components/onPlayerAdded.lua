local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local DataModule = script:FindFirstAncestor("DataModule")

local DataManger = require(DataModule.Modules.DataManger)
local state = require(DataModule.state)

local remotes = DataModule.Remotes

local function setExtraPlayerData(playerData, allPlayerData)
	for dataStoreKey, dataStoreValue in pairs(allPlayerData) do
		if not playerData[dataStoreKey] then
			playerData[dataStoreKey] = dataStoreValue
		end
	end

	return playerData
end

local function onPlayerAdded(CachedData, serverConfig)
	--[[
		Loads the data that the player has and sends that data
		to the client

		Parameters:
		dataStore: The DataStore to retrieve data from
		userId: The player userId
		data: Additional data to load
	]]
	return function(dataStore, userId, data)
		if not serverConfig then
			-- Store the player data in CachedData
			CachedData.data[userId] = CachedData.data[userId] or {}
			CachedData.data[userId][dataStore] = data
			
			return
		end
		
		if state.LoadingData then
			warn("Data is already loading")
			return
		end
		state.LoadingData = true
		
		local player = Players:GetPlayerByUserId(userId)
		local success, playerData = pcall(function()
			-- Get Global DataStore
			local dataStore = DataStoreService:GetDataStore(dataStore)
			return DataManger.loadDataAsync(dataStore, userId)
		end)
		
		if success then
			playerData = playerData or {}
			
			-- Fill missing data
			playerData = setExtraPlayerData(playerData, data)
			
			-- Store the player data in CachedData
			CachedData.data[userId] = CachedData.data[userId] or {}
			CachedData.data[userId][dataStore] = playerData
			
			-- Send the player data to the client
			remotes.LoadData:FireClient(player, dataStore, playerData)
		else
			local warning = "There was an error getting the data for the "
				.. "player with UserId: "
				.. userId
				.. ".\n\nIf you are running in Studio, make sure is enabled "
				.. "'Studio Access to API Services'"

			warn(warning)
			remotes.LoadData:FireClient(player, dataStore, {})
		end
		
		state.LoadingData = false
	end
end

return onPlayerAdded
