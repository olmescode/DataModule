local DataStoreService = game:GetService("DataStoreService")

local ModuleData = script:FindFirstAncestor("ModuleData")
local DataManger = require(ModuleData.Modules.DataManger)
local SetupData = require(ModuleData.Components.SetupData)
local PlayerDataStores = require(ModuleData.PlayerDataStores)

local function loadData(player)
	local playerData = {}
	
	for _playerDataStore, data in pairs(PlayerDataStores) do
		-- Get Global DataStore
		local playerDataStore = DataStoreService:GetDataStore(_playerDataStore)
		local DATA = DataManger.loadDataAsync(playerDataStore, player.UserId)
		
		-- Data can also be nil or false or number from oldData
		if type(DATA) == "number" then
			local tempData = {}
			tempData["Playtime"] = DATA
			DATA = tempData
		end
		if DATA == false then continue end
		playerData[playerDataStore.Name] = DATA or {}
	end
	
	SetupData(player, playerData)
end

return loadData
