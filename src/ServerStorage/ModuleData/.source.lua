local DataManager = require(script.Modules.DataManger)

local ModuleData = {}

-- Find for an instance inside the PlayerData folder
local function findData(playerDataFolder, data)
	for _, instance in ipairs(playerDataFolder:GetChildren()) do
		if instance.Name == data then
			-- Return the instance
			return instance
		end
	end
	return false
end

function ModuleData.getData(player, data)
	local playerDataFolder = player:WaitForChild("PlayerData")
	
	return findData(playerDataFolder, data)
end

function ModuleData.createRepo(player, playerDataName, playerDataType, dataStore)
	local playerDataFolder = player:WaitForChild("PlayerData")
	local instance = nil
	
	if playerDataFolder then
		for _, _instance in ipairs(playerDataFolder:GetChildren()) do
			if _instance.Name == playerDataName then
				instance = _instance
			end
		end
	end

	if not instance then
		if playerDataType == "number" then
			local instance = Instance.new("IntValue")
			instance.Name = playerDataName
			instance.Parent = playerDataFolder
		end
		if playerDataType == "string" then
			local instance = Instance.new("StringValue")
			instance.Name = playerDataName
			instance.Parent = playerDataFolder
		end
	end
end

function ModuleData.loadDataAsync(dataStore, userId)
	return DataManager.loadDataAsync(dataStore, userId)
end

function ModuleData.saveDataAsync(dataStore, userId, playerData)
	return DataManager.saveDataAsync(dataStore, userId, playerData)
end

function ModuleData.updateDataAsync(orderedDataStore, userId, playerData)
	return DataManager.updateDataAsync(orderedDataStore, userId, playerData)
end

function ModuleData.saveOrderedDataAsync(orderedDataStore, userId, playerData)
	return DataManager.saveOrderedDataAsync(orderedDataStore, userId, playerData)
end

return ModuleData
