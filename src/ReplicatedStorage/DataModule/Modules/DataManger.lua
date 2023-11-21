local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local MIN_SESSION_DURATION = 30
local MAX_SESSION_DURATION = 60
local MAX_TRIES = 5

export type PlayerData = { [string]: any }

local DataManger = {}

-- Function to yield if there's a lot of budget on the queue
function DataManger.waitForRequestBudget(requestType)
	while DataStoreService:GetRequestBudgetForRequestType(requestType) < 1 do
		task.wait(6)
	end
end

-- Getting data
function DataManger.loadDataAsync(dataStore: GlobalDataStore, key: string)
	local tries = 0
	local success = nil
	local playerData = nil
	local dataStoreKeyInfo = nil
	local lastSession = nil

	repeat
		tries = tries + 1
		DataManger.waitForRequestBudget(Enum.DataStoreRequestType.GetAsync)
		success, playerData, dataStoreKeyInfo = pcall(dataStore.GetAsync, dataStore, key)
		--print(dataStoreKeyInfo.Version)
		--print(dataStoreKeyInfo.CreatedTime)
		--print(dataStoreKeyInfo.UpdatedTime)
		if success and playerData == nil and dataStoreKeyInfo == nil then
			return nil
		end

		if dataStoreKeyInfo then
			lastSession = os.time() - (dataStoreKeyInfo.UpdatedTime/1000)
			--[[
				If a player attempt to rejoin the game really quickly it ensures the data
				has been successfully updated in the last 30 seconds else it yields to give
				more time to the save process
			]]
			if lastSession <= MIN_SESSION_DURATION then
				break
			else
				task.wait(3)
			end
		end
	until success and lastSession > MAX_SESSION_DURATION or not Players:GetPlayerByUserId(tonumber(key)) or tries == 10

	if success then
		return playerData
	else
		warn(string.format("Failed to load %s's data: %s", key, playerData))
	end
end

-- Saving data
function DataManger.saveDataAsync(dataStore: GlobalDataStore, key: string, playerData: PlayerData)
	local tries = 0
	local success = nil
	local errorMessage = nil

	repeat
		tries = tries + 1
		DataManger.waitForRequestBudget(Enum.DataStoreRequestType.SetIncrementAsync)
		success, errorMessage = pcall(dataStore.SetAsync, dataStore, key, playerData)
	until success or tries == MAX_TRIES

	if not success then
		warn(string.format("Failed to save %s's data: %s", key, errorMessage))
	end
end

-- Updating data
function DataManger.updateDataAsync(dataStore: GlobalDataStore, key: string, playerData: PlayerData)
	local tries = 0
	local success = nil
	local errorMessage = nil

	local function updatePlayerDataAsync(playerKey, playerData)
		return dataStore:UpdateAsync(playerKey, function(oldPlayerData, DataStoreKeyInfo)
			return playerData or oldPlayerData
		end)
	end

	repeat
		tries = tries + 1
		DataManger.waitForRequestBudget(Enum.DataStoreRequestType.UpdateAsync)
		success, errorMessage = pcall(updatePlayerDataAsync, key, playerData)
	until success or tries == MAX_TRIES

	if not success then
		warn(string.format("Failed to update %s's data: %s", key, errorMessage))
	end
end

-- Removing data
function DataManger.removeDataAsync(dataStore: GlobalDataStore, key: string)
	local tries = 0
	local success = nil
	local errorMessage = nil
	
	repeat
		success, errorMessage = pcall(dataStore.RemoveAsync, dataStore, key)
	until success or tries == MAX_TRIES

	if not success then
		warn(string.format("Failed to remove %s's data: %s", key, errorMessage))
	end
end

-- Ordered Data Stores
function DataManger.saveOrderedDataAsync(orderedDataStore: OrderedDataStore, key: string, playerData: PlayerData)
	local tries = 0
	local success = nil
	local errorMessage = nil

	repeat
		tries = tries + 1
		DataManger.waitForRequestBudget(Enum.DataStoreRequestType.SetIncrementSortedAsync)
		success, errorMessage = pcall(orderedDataStore.SetAsync, orderedDataStore, key, playerData)
	until success or tries == MAX_TRIES

	if not success then
		warn(string.format("Failed to save %s's data: %s", key, errorMessage))
	end
end

return DataManger
