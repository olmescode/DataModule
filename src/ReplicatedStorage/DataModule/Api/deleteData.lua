local Players = game:GetService("Players")

local DataModule = script:FindFirstAncestor("DataModule")
local callbacks = require(DataModule.callbacks)

local remotes = DataModule.Remotes

local function deleteData(CachedData, serverConfig)
	--[[
		Allows to update data to CahedData

		Parameters:
		player: The player to delete data for
		valueName: The name of the instance in the cache
	]]
	return function(player: Player, valueName: string)
		assert(player:IsA("Player"), "player should be a player")
		assert(type(valueName) == "string", "valueName should be a string")
		
		local playerData = CachedData._playerData[player]
		local callback = callbacks[valueName]
		
		if not playerData then
			warn(string.format("Player %s not found in cached data", player.Name))
			return
		end

		for dataStore, data in pairs(playerData) do
			if data[valueName] then
				data[valueName] = nil
				if callbacks.deleteDataCallvack.isCallbackSet() then
					callbacks.deleteDataCallvack.fireCallback(player, valueName)
				end
				if callback then
					callback(player, valueName)
				end
				
				if serverConfig then
					-- Update the player data to the client
					remotes.DeleteData:FireClient(player, valueName)
				end
				
				return true
			end
		end
		
		-- Value not found in cache
		warn(string.format("Value %s does not exist in the data for player %s", valueName, player.Name))
		return false
	end
end

return deleteData
