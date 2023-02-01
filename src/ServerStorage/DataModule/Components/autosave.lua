local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local DataModule = script:FindFirstAncestor("DataModule")
local DataManger = require(DataModule.Modules.DataManger)

local function autosave(CachedData)
	--[[
	Saves the player data for all players currently connected periodically.
	This reduces player data loss in the event of a server crash
	]]
	return function()
		for _, player in ipairs(Players:GetPlayers()) do
			local playerData = CachedData.data[player.UserId]
			
			if playerData then
				for dataStore, data in pairs(playerData) do
					local success, errorMessage = pcall(function()
						-- Get Global DataStore
						local dataStore = DataStoreService:GetDataStore(dataStore)
						return DataManger.updateDataAsync(dataStore, player.UserId, data)
					end)

					if not success then
						warn(string.format("Failed to save %d's data: %s", player.UserId, errorMessage))
					end
				end
			end
		end
	end
end

return autosave
