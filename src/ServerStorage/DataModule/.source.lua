print("Required ModuleData")
local RunService = game:GetService("RunService")

local loadDataAsync = require(script.Api.loadDataAsync)
local DataManager = require(script.Modules.DataManger)
local CachedData = require(script.Components.CachedData)

local DataModule = {}
-- CRUD (create, read, update, and delete)

-- Retrieve data
function DataModule.retrieveData(userId, key)
	assert(type(userId) == "number", "userId should be a number")
	assert(type(key) == "string", "value should be a string")

	local data = CachedData.data[userId]
	if not data then
		warn(string.format("User with ID %d not found in cached data", userId))
		return
	end
	
	for dataStore, data in pairs(data) do
		if data[key] then
			return data[key]
		end
	end
	-- Value not found in cache
	warn(string.format("User with ID %d does not have %s in the cache", userId, key))
	return false
end

-- Update data
function DataModule.updateData(userId, key, newValue)
	assert(type(userId) == "number", "userId should be a number")
	assert(type(key) == "string", "value should be a string")
	assert(type(newValue) ~= "nil", "newValue should be provided")
	
	local data = CachedData.data[userId]
	if not data then
		warn(string.format("User with ID %d not found in cached data", userId))
		return
	end

	for dataStore, data in pairs(data) do
		if data[key] then
			data[key] = newValue
			return true
		end
	end
	-- Value not found in cache
	warn(string.format("Key %s does not exist in the data for user %d", key, userId))
	return false
end

-- Set new data
function DataModule.satData(userId, dataStore, key, value)
	assert(type(userId) == "number", "userId should be a number")
	assert(type(dataStore) == "string", "dataStore should be a string")
	assert(type(key) == "string", "key should be a string")
	assert(type(value) ~= "nil", "value should be provided")
	
	local playerData = CachedData.data[userId]
	if playerData then
		if playerData[dataStore] then
			playerData[dataStore][key] = value
		else
			playerData[dataStore] = {
				[key] = value
			}
		end
	else
		CachedData.data[userId] = {
			[dataStore] = {
				[key] = value
			}
		}
	end
end

-- Delete data
function DataModule.deleteData(userId, key)
	assert(type(userId) == "number", "userId should be a number")
	assert(type(key) == "string", "key should be a string")
	
	local data = CachedData.data[userId]
	if not data then
		warn(string.format("User with ID %d not found in cached data", userId))
		return
	end
	
	for dataStore, data in pairs(data) do
		if data[key] then
			data[key] = nil
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
