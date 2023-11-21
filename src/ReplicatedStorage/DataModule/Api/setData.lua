local Players = game:GetService("Players")

local DataModule = script:FindFirstAncestor("DataModule")
local callbacks = require(DataModule.callbacks)

local remotes = DataModule.Remotes

local function setData(CachedData, serverConfig)
	--[[
		Allows to set new data in CahedData

		Parameters:
		player: The player  whose data is being set
		dataStore: The name of the dataStore
		valueName: The name of the instance in the cache
		value: The value of the data
	]]
	return function(player: Player, dataStore: string, valueName: string, value: any)
		assert(player:IsA("Player"), "player should be a player")
		assert(type(dataStore) == "string", "dataStore should be a string")
		assert(type(valueName) == "string", "valueName should be a string")
		assert(type(value) ~= "nil", "value should be provided")
		
		local playerData = CachedData._playerData[player]
		
		if not playerData then
			warn(string.format("Player %s not found in cached data", player.Name))
			return
		end
		
		if playerData then
			if playerData[dataStore] then
				playerData[dataStore][valueName] = value
			else
				playerData[dataStore] = {
					[valueName] = value
				}
			end
			if callbacks.setDataCallback.isCallbackSet() then
				callbacks.setDataCallback.fireCallback(player, dataStore, valueName, value)
			end
		else
			CachedData._playerData[player] = {
				[dataStore] = {
					[valueName] = value
				}
			}
			if callbacks.setDataCallback.isCallbackSet() then
				callbacks.setDataCallback.fireCallback(player, dataStore, valueName, value)
			end
		end
		
		if serverConfig then
			-- Set the new player data to the client
			remotes.SetData:FireClient(player, dataStore, valueName, value)
		end
	end
end

return setData
