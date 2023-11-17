local Players = game:GetService("Players")

local DataModule = script:FindFirstAncestor("DataModule")
local callbacks = require(DataModule.callbacks)

local remotes = DataModule.Remotes

local function updateData(CachedData, serverConfig)
	--[[
		Allows to update data to CahedData

		Parameters:
		userId: The player userId to get the data from
		dataKey: The name of the instance in the cache
		dataValue: The value of the data
	]]
	return function(userId, dataKey, dataValue)
		assert(type(userId) == "number", "userId should be a number")
		assert(type(dataKey) == "string", "data key should be a string")
		assert(type(dataValue) ~= "nil", "newValue should be provided")
		
		local player = Players:GetPlayerByUserId(userId)
		local playerData = CachedData._playerData[userId]
		local callback = callbacks[dataKey]

		if not playerData then
			warn(string.format("User with ID %d not found in cached data", userId))
			return
		end

		for dataStore, data in pairs(playerData) do
			if data[dataKey] then
				data[dataKey] = dataValue
				if callbacks.updateDataCallback.isCallbackSet() then
					callbacks.updateDataCallback.fireCallback(userId, dataKey, dataValue)
				end
				if callback then
					callback(userId, dataKey, dataValue)
				end
				
				if serverConfig then
					-- Update the player data to the client
					remotes.UpdateData:FireClient(player, dataKey, dataValue)
				end
				
				return true
			end
		end

		-- Value not found in cache
		warn(string.format("Key %s does not exist in the data for user %d", dataKey, userId))
		return false
	end
end

return updateData
