local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local DataModule = script:FindFirstAncestor("DataModule")

local DataManger = require(DataModule.Modules.DataManger)
local resumeThreadsPendingLoad = require(DataModule.Modules.resumeThreadsPendingLoad)
local setPlayerDataAsErrored = require(DataModule.Modules.setPlayerDataAsErrored)
local PlayerDataErrorType = require(DataModule.PlayerDataErrorType)

local remotes = DataModule.Remotes

export type PlayerData = { [string]: any }

local function setExtraPlayerData(playerData, defaultData)
	for dataStoreKey, dataStoreValue in pairs(defaultData) do
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
	return function(dataStoreName: string, userId: number, data: PlayerData)
		if not serverConfig then
			-- Store the player data in CachedData
			CachedData._playerData[userId] = CachedData._playerData[userId] or {}
			CachedData._playerData[userId][dataStoreName] = data
			return
		end
		
		local hasErrored = false
		local errorType = PlayerDataErrorType.DataStoreError
		local player = Players:GetPlayerByUserId(userId)
		
		local success, playerData = pcall(function()
			-- Get Global DataStore
			local dataStore = DataStoreService:GetDataStore(dataStoreName)
			return DataManger.loadDataAsync(dataStore, userId)
		end)
		
		if success then
			playerData = playerData or {}
			
			-- Fill missing data
			playerData = setExtraPlayerData(playerData, data)
			
			-- Store the player data in CachedData
			CachedData._playerData[userId] = CachedData._playerData[userId] or {}
			CachedData._playerData[userId][dataStoreName] = playerData
			
			-- Send the player data to the client
			remotes.LoadData:FireClient(player, dataStoreName, playerData)
		else
			local warning = "There was an error getting the data for the "
				.. "player with UserId: "
				.. userId
				.. ".\n\nIf you are running in Studio, make sure is enabled "
				.. "'Studio Access to API Services'"

			warn(warning)
			
			hasErrored = true
			remotes.LoadData:FireClient(player, dataStoreName, {})
		end
		
		if hasErrored then
			setPlayerDataAsErrored(CachedData)(player, errorType)
		end
		
		-- Resume any threads that were yielded by PlayerDataServer.waitForDataLoadAsync
		resumeThreadsPendingLoad(CachedData)(player)
	end
end

return onPlayerAdded
