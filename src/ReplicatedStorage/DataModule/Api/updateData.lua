local Players = game:GetService("Players")

local DataModule = script:FindFirstAncestor("DataModule")
local callbacks = require(DataModule.callbacks)

local remotes = DataModule.Remotes

local function updateData(CachedData, serverConfig)
	--[[
		Allows to update data to CahedData

		Parameters:
		player: The player  to update data for
		valueName: The name of the instance in the cache
		value: The value of the data
	]]
	return function(player: Player, valueName: string, value: any)
		assert(player:IsA("Player"), "player should be a Player")
		assert(type(valueName) == "string", "data key should be a string")
		assert(type(value) ~= "nil", "newValue should be provided")
		
		local playerData = CachedData._playerData[player]
		local callback = callbacks[valueName]

		if not playerData then
			warn(string.format("Player %s not found in cached data", player.Name))
			return
		end

		for dataStore, data in pairs(playerData) do
			if data[valueName] then
				data[valueName] = value
				if callbacks.updateDataCallback.isCallbackSet() then
					callbacks.updateDataCallback.fireCallback(player, valueName, value)
				end
				if callback then
					callback(player, valueName, value)
				end
				
				if serverConfig then
					-- Update the player data to the client
					remotes.UpdateData:FireClient(player, valueName, value)
				end
				
				return true
			end
		end

		-- Value not found in cache
		warn(string.format("Value %s does not exist in the data for player %s", valueName, player.Name))
		return false
	end
end

return updateData
