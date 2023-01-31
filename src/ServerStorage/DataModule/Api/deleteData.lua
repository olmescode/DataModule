local DataModule = script:FindFirstAncestor("DataModule")
local callbacks = require(DataModule.callbacks)

local function deleteData(CachedData)
	--[[
		Allows to update data to CahedData

		Parameters:
		userId: The player userId to get the data from
		dataKey: The name of the instance in the cache
		dataValue: The value of the data
	]]
	return function(userId, dataKey)
		assert(type(userId) == "number", "userId should be a number")
		assert(type(dataKey) == "string", "data key should be a string")

		local playerData = CachedData.data[userId]
		local callback = callbacks[dataKey]
		
		if not playerData then
			warn(string.format("User with ID %d not found in cached data", userId))
			return
		end

		for dataStore, data in pairs(playerData) do
			if data[dataKey] then
				data[dataKey] = nil
				if callbacks.deleteDataCallvack.isCallbackSet() then
					callbacks.deleteDataCallvack.fireCallback(userId, dataKey)
				end
				if callback then
					callback(userId, dataKey)
				end
				return true
			end
		end
		-- Value not found in cache
		warn(string.format("User with ID %d does not have any data in the cache", userId))
		return false
	end
end

return deleteData
