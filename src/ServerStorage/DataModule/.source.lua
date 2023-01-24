print("Required ModuleData")
local RunService = game:GetService("RunService")

local loadDataAsync = require(script.Api.loadDataAsync)
local DataManager = require(script.Modules.DataManger)
local CachedData = require(script.Components.CachedData)

local playerDataRemote = script.Remotes.playerDataRemote

local DataModule = {}
-- CRUD (create, read, update, and delete)

-- Retrieve data
function DataModule.retrieveData(userId, dataKey)
	assert(type(userId) == "number", "userId should be a number")
	assert(type(dataKey) == "string", "value should be a string")

	local data = CachedData.data[userId]
	if not data then
		warn(string.format("User with ID %d not found in cached data", userId))
		return
	end
	
	for dataStore, data in pairs(data) do
		if data[dataKey] then
			return data[dataKey]
		end
	end
	-- Value not found in cache
	warn(string.format("User with ID %d does not have %s in the cache", userId, dataKey))
	return false
end

-- Update data
function DataModule.updateData(userId, dataKey, dataValue)
	assert(type(userId) == "number", "userId should be a number")
	assert(type(dataKey) == "string", "value should be a string")
	assert(type(dataValue) ~= "nil", "newValue should be provided")
	
	local data = CachedData.data[userId]
	local callback = CachedData.callbacks[dataKey]
	
	if not data then
		warn(string.format("User with ID %d not found in cached data", userId))
		return
	end

	for dataStore, data in pairs(data) do
		if data[dataKey] then
			data[dataKey] = dataValue
			if callback then
				callback(userId, dataKey, dataValue)
			end
			return true
		end
	end
	
	--CachedData.callbacks.onUpdate(userId, dataKey, dataValue)
	
	-- Value not found in cache
	warn(string.format("Key %s does not exist in the data for user %d", dataKey, userId))
	return false
end

-- Set new data
function DataModule.satData(userId, dataStore, dataKey, dataValue)
	assert(type(userId) == "number", "userId should be a number")
	assert(type(dataStore) == "string", "dataStore should be a string")
	assert(type(dataKey) == "string", "key should be a string")
	assert(type(dataValue) ~= "nil", "value should be provided")
	
	local playerData = CachedData.data[userId]
	if playerData then
		if playerData[dataStore] then
			playerData[dataStore][dataKey] = dataValue
		else
			playerData[dataStore] = {
				[dataKey] = dataValue
			}
		end
	else
		CachedData.data[userId] = {
			[dataStore] = {
				[dataKey] = dataValue
			}
		}
	end
end

-- Delete data
function DataModule.deleteData(userId, dataKey)
	assert(type(userId) == "number", "userId should be a number")
	assert(type(dataKey) == "string", "key should be a string")
	
	local data = CachedData.data[userId]
	if not data then
		warn(string.format("User with ID %d not found in cached data", userId))
		return
	end
	
	for dataStore, data in pairs(data) do
		if data[dataKey] then
			data[dataKey] = nil
			return true
		end
	end
	-- Value not found in cache
	warn(string.format("User with ID %d does not have any data in the cache", userId))
	return false
end

function DataModule.loadDataAsync(player, DataStores)
	local playerData = nil
	
	local success, result = pcall(function()
		playerData = loadDataAsync(player, DataStores)
		
	end)
	if not success then
		warn(string.format("Failed to save %d's data: %s", player.UserId, result))
		return
	end
	
	CachedData.data[player.UserId] = playerData
	
	playerDataRemote:FireClient(player, playerData)
end

function DataModule.clearData(player)
	CachedData.clearCache(player.UserId)
	CachedData.data[player.UserId] = nil
end

function DataModule.init()
	assert(RunService:IsServer(), "DataModule must be called on server")
	
	CachedData.init()
end

return DataModule
