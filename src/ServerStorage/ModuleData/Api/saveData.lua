local DataStoreService = game:GetService("DataStoreService")

local ModuleData = script:FindFirstAncestor("ModuleData")
local DataManger = require(ModuleData.Modules.DataManger)
local PlayerDataStores = require(ModuleData.PlayerDataStores)

local function saveData(player)
	local playerData = player:FindFirstChild("PlayerData")
	local DATA = {}
	
	for _playerDataStore, data in pairs(PlayerDataStores) do
		-- Get Global DataStore
		local playerDataStore = DataStoreService:GetDataStore(_playerDataStore)
		
		for _, instance in ipairs(playerData:GetChildren()) do
			-- Get current attribute value
			local dataStore = instance:GetAttribute("DataStore")
			
			if _playerDataStore == dataStore then
				DATA[instance.Name] = instance.Value
			end
		end
		if next(data) ~= nil then
			DataManger.updateDataAsync(playerDataStore, player.UserId, DATA)
		end

		for index, value in pairs(DATA) do
			DATA[index] = nil
		end
	end
end

return saveData
