local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local ModuleData = {}

-- Function to yield if there's a lot of budget on the queue
local function waitForRequestBudget(requestType)
	local currentBudget = DataStoreService:GetRequestBudgetForRequestType(requestType)	
	while currentBudget < 1 do
		currentBudget = DataStoreService:GetRequestBudgetForRequestType(requestType)
		task.wait(6)
	end
end

-- Getting data
function ModuleData.loadDataAsync(dataStore, userId)
	local tries = 0
	local success = nil
	local result = nil
	local dataStoreKeyInfo = nil
	local session = nil
	local lastSession = nil

	repeat
		tries = tries + 1
		waitForRequestBudget(Enum.DataStoreRequestType.GetAsync)
		success, result, dataStoreKeyInfo = pcall(dataStore.GetAsync, dataStore, userId)
		--print(dataStoreKeyInfo.Version)
		--print(dataStoreKeyInfo.CreatedTime)
		--print(dataStoreKeyInfo.UpdatedTime)
		if success and result == nil and dataStoreKeyInfo == nil then return end

		if dataStoreKeyInfo then
			session = os.time()
			lastSession = (session - dataStoreKeyInfo.UpdatedTime/1000)
			-- If lastSession is less than 30 seconds it will yiel
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
function ModuleData.saveDataAsync(dataStore, userId, playerData)
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

-- Actualizando los datos
function ModuleData.updateDataAsync(dataStore, userId, playerData)
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
function ModuleData.saveOrderedDataAsync(orderedDataStore, userId, playerData)
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

-- Removiendo los datos
function ModuleData.removeData(dataStore, userId)
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

return ModuleData
