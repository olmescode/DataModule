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
function DataManger.loadDataAsync(dataStore, userId)
	local tries = 0
	local success = nil
	local playerData = nil
	local dataStoreKeyInfo = nil
	local lastSession = nil

	repeat
		tries = tries + 1
		waitForRequestBudget(Enum.DataStoreRequestType.GetAsync)
		success, playerData, dataStoreKeyInfo = pcall(dataStore.GetAsync, dataStore, userId)
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
	until success and lastSession > 30 or not Players:GetPlayerByUserId(userId) or tries == 10

	if success then
		return playerData
	else
		warn(string.format("Failed to save %d's data: %s", userId))
	end
end

-- Saving data
function DataManger.saveDataAsync(dataStore, userId, playerData)
	local tries = 0
	local success = nil
	local errorMessage = nil

	repeat
		tries = tries + 1
		waitForRequestBudget(Enum.DataStoreRequestType.SetIncrementAsync)
		success, errorMessage = pcall(dataStore.SetAsync, dataStore, userId, playerData)
	until success or tries == 5

	if not success then
		warn(string.format("Failed to save %d's data: %s", userId, errorMessage))
	end
end

-- Updating data
function DataManger.updateDataAsync(dataStore, userId, playerData)
	local tries = 0
	local success = nil
	local errorMessage = nil

	local function updatePlayerDataAsync(userId, data)
		return dataStore:UpdateAsync(userId, function(oldData, DataStoreKeyInfo)
			return data or oldData
		end)
	end

	repeat
		tries = tries + 1
		waitForRequestBudget(Enum.DataStoreRequestType.UpdateAsync)
		success, errorMessage = pcall(updatePlayerDataAsync, userId, playerData)
	until success or tries == 5

	if not success then
		warn(string.format("Failed to update %d's data: %s", userId, errorMessage))
	end
end

-- Ordered Data Stores
function DataManger.saveOrderedDataAsync(orderedDataStore, userId, playerData)
	local tries = 0
	local success = nil
	local errorMessage = nil

	repeat
		tries = tries + 1
		waitForRequestBudget(Enum.DataStoreRequestType.SetIncrementSortedAsync)
		success, errorMessage = pcall(orderedDataStore.SetAsync, orderedDataStore, userId, playerData)
	until success or tries == 5
	
	if not success then
		warn(string.format("Failed to save %d's data: %s", userId, errorMessage))
	end
end

-- Removing data
function DataManger.removeData(dataStore, userId)
	local tries = 0
	local success = nil
	local errorMessage = nil
	repeat
		success, errorMessage = pcall(dataStore.removeData, dataStore, userId)
	until success or tries == 5
	
	if not success then
		warn(string.format("Failed to remove %d's data: %s", userId, errorMessage))
	end
end

return DataManger
