local Players = game:GetService("Players")

local DataModule = script:FindFirstAncestor("DataModule")
local callbacks = require(DataModule.callbacks)

local remotes = DataModule.Remotes

local function setData(CachedData, serverConfig)
	--[[
		Allows to set new data in CahedData

		Parameters:
		userId: The player userId to get the data from
		dataStore: The name of the dataStore
		dataKey: The name of the instance in the cache
		dataValue: The value of the data
	]]
	return function(userId, dataStore, dataKey, dataValue)
		assert(type(userId) == "number", "userId should be a number")
		assert(type(dataStore) == "string", "dataStore should be a string")
		assert(type(dataKey) == "string", "data key should be a string")
		assert(type(dataValue) ~= "nil", "value should be provided")
		
		local player = Players:GetPlayerByUserId(userId)
		local playerData = CachedData._playerData[userId]
		
		if not playerData then
			warn(string.format("User with ID %d not found in cached data", userId))
			return
		end
		
		if playerData then
			if playerData[dataStore] then
				playerData[dataStore][dataKey] = dataValue
			else
				playerData[dataStore] = {
					[dataKey] = dataValue
				}
			end
			if callbacks.setDataCallback.isCallbackSet() then
				callbacks.setDataCallback.fireCallback(userId, dataStore, dataKey, dataValue)
			end
		else
			CachedData._playerData[userId] = {
				[dataStore] = {
					[dataKey] = dataValue
				}
			}
			if callbacks.setDataCallback.isCallbackSet() then
				callbacks.setDataCallback.fireCallback(userId, dataStore, dataKey, dataValue)
			end
		end
		
		if serverConfig then
			-- Set the new player data to the client
			remotes.SetData:FireClient(player, dataStore, dataKey, dataValue)
		end
	end
end

return setData
