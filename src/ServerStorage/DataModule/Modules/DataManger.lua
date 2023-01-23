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
	local result = nil
	local dataStoreKeyInfo = nil
	local lastSession = nil

	repeat
		tries = tries + 1
		waitForRequestBudget(Enum.DataStoreRequestType.GetAsync)
		success, result, dataStoreKeyInfo = pcall(dataStore.GetAsync, dataStore, userId)
		--print(dataStoreKeyInfo.Version)
		--print(dataStoreKeyInfo.CreatedTime)
		--print(dataStoreKeyInfo.UpdatedTime)
		if success and result == nil and dataStoreKeyInfo == nil then 
			warn("User does not have registered a data in this DataStore")
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
		return result
	else
		warn(string.format("Failed to save %d's data: %s", userId, result))
		return false
	end
end

-- Saving data
function DataManger.saveDataAsync(dataStore, userId, playerData)
	local tries = 0
	local success = nil
	local result = nil

	repeat
		tries = tries + 1
		waitForRequestBudget(Enum.DataStoreRequestType.SetIncrementAsync)
		success, result = pcall(dataStore.SetAsync, dataStore, userId, playerData)
	until success or tries == 5

	if not success then
		warn(string.format("Failed to save %d's data: %s", userId, result))
		return false
	end
end

-- Updating data
function DataManger.updateDataAsync(dataStore, userId, playerData)
	local tries = 0
	local success = nil
	local result = nil

	local function updatePlayerDataAsync(userId, data)
		return dataStore:UpdateAsync(userId, function(oldData, DataStoreKeyInfo)
			return data or oldData
		end)
	end

	repeat
		tries = tries + 1
		waitForRequestBudget(Enum.DataStoreRequestType.UpdateAsync)
		success, result = pcall(updatePlayerDataAsync, userId, playerData)
	until success or tries == 5

	if not success then
		warn(string.format("Failed to update %d's data: %s", userId, result))
		return false
	end
end

-- Ordered Data Stores
function DataManger.saveOrderedDataAsync(orderedDataStore, userId, playerData)
	local tries = 0
	local success = nil
	local result = nil

	repeat
		tries = tries + 1
		waitForRequestBudget(Enum.DataStoreRequestType.SetIncrementSortedAsync)
		success, result = pcall(orderedDataStore.SetAsync, orderedDataStore, userId, playerData)
	until success or tries == 5

	if success then
		return true
	else
		warn(string.format("Failed to save %d's data: %s", userId, result))
		return false
	end
end

-- Removing data
function DataManger.removeData(dataStore, userId)
	local tries = 0
	local success = nil
	local result = nil
	repeat
		success, result = pcall(dataStore.removeData, dataStore, userId)
	until success or tries == 5

	if success then
		return true
	else
		warn(string.format("Failed to remove %d's data: %s", userId, result))
		return false
	end
end

return DataManger
