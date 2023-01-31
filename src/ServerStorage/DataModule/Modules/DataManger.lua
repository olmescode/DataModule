local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local DataManger = {}

-- Function to yield if there's a lot of budget on the queue
local function waitForRequestBudget(requestType)
	while DataStoreService:GetRequestBudgetForRequestType(requestType) < 1 do
		task.wait(6)
	end
end

-- Getting data
function DataManger.loadDataAsync(dataStore, playerKey)
	local tries = 0
	local success = nil
	local playerData = nil
	local dataStoreKeyInfo = nil
	local lastSession = nil

	repeat
		tries = tries + 1
		waitForRequestBudget(Enum.DataStoreRequestType.GetAsync)
		success, playerData, dataStoreKeyInfo = pcall(dataStore.GetAsync, dataStore, playerKey)
		--print(dataStoreKeyInfo.Version)
		--print(dataStoreKeyInfo.CreatedTime)
		--print(dataStoreKeyInfo.UpdatedTime)
		if success and playerData == nil and dataStoreKeyInfo == nil then
			return nil
		end
		
		if dataStoreKeyInfo then
			lastSession = os.time() - (dataStoreKeyInfo.UpdatedTime/1000)
			-- Wait if the data was updated less than 30 seconds ago
			if lastSession < 30 then
				task.wait(3)
			end
		end
	until success and lastSession > 30 or not Players:GetPlayerByUserId(playerKey) or tries == 10

	if success then
		return playerData
	else
		warn(string.format("Failed to save %d's data: %s", playerKey))
	end
end

-- Saving data
function DataManger.saveDataAsync(dataStore, playerKey, playerData)
	local tries = 0
	local success = nil
	local errorMessage = nil

	repeat
		tries = tries + 1
		waitForRequestBudget(Enum.DataStoreRequestType.SetIncrementAsync)
		success, errorMessage = pcall(dataStore.SetAsync, dataStore, playerKey, playerData)
	until success or tries == 5

	if not success then
		warn(string.format("Failed to save %d's data: %s", playerKey, errorMessage))
	end
end

-- Updating data
function DataManger.updateDataAsync(dataStore, playerKey, playerData)
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
		waitForRequestBudget(Enum.DataStoreRequestType.UpdateAsync)
		success, errorMessage = pcall(updatePlayerDataAsync, playerKey, playerData)
	until success or tries == 5

	if not success then
		warn(string.format("Failed to update %d's data: %s", playerKey, errorMessage))
	end
end

-- Ordered Data Stores
function DataManger.saveOrderedDataAsync(orderedDataStore, playerKey, playerData)
	local tries = 0
	local success = nil
	local errorMessage = nil

	repeat
		tries = tries + 1
		waitForRequestBudget(Enum.DataStoreRequestType.SetIncrementSortedAsync)
		success, errorMessage = pcall(orderedDataStore.SetAsync, orderedDataStore, playerKey, playerData)
	until success or tries == 5
	
	if not success then
		warn(string.format("Failed to save %d's data: %s", playerKey, errorMessage))
	end
end

-- Removing data
function DataManger.removeData(dataStore, playerKey)
	local tries = 0
	local success = nil
	local errorMessage = nil
	repeat
		success, errorMessage = pcall(dataStore.removeData, dataStore, playerKey)
	until success or tries == 5
	
	if not success then
		warn(string.format("Failed to remove %d's data: %s", playerKey, errorMessage))
	end
end

return DataManger
