local DataModule = script:FindFirstAncestor("DataModule")
local callbacks = require(DataModule.callbacks)

local function setData(CachedData)
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

		local playerData = CachedData.data[userId]
		
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
			CachedData.data[userId] = {
				[dataStore] = {
					[dataKey] = dataValue
				}
			}
			if callbacks.setDataCallback.isCallbackSet() then
				callbacks.setDataCallback.fireCallback(userId, dataStore, dataKey, dataValue)
			end
		end
	end
end

return setData
