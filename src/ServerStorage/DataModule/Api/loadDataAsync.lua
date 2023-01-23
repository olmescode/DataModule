local DataStoreService = game:GetService("DataStoreService")

local DataModule = script:FindFirstAncestor("DataModule")
local DataManger = require(DataModule.Modules.DataManger)
local mergeTables = require(DataModule.Api.mergeTables)

local function loadData(player, DataStores)
	local CachedData = {}
	
	for playerDataStore, data in pairs(DataStores) do
		-- Get Global DataStore
		local dataStore = DataStoreService:GetDataStore(playerDataStore)
		local playerData = DataManger.loadDataAsync(dataStore, player.UserId)
		
		-- Data can also be false or nil
		if playerData then
			-- Fill
			playerData = mergeTables(playerData, DataStores[playerDataStore])
			
			CachedData[playerDataStore] = playerData
		else
			CachedData[playerDataStore] = DataStores[playerDataStore]
		end
	end
	
	return CachedData
end

return loadData
