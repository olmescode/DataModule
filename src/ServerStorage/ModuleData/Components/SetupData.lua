local ModuleData = script:FindFirstAncestor("ModuleData")
local PlayerDataStores = require(ModuleData.PlayerDataStores)

local function createDefaultValues(playerData, playerDataStore)
	local data = PlayerDataStores[playerDataStore]
	-- Create a default value
	for data, value in pairs(data) do
		if type(value) == "number" then
			local intValue = Instance.new("IntValue")
			intValue.Name = data
			intValue.Value = value
			intValue:SetAttribute("DataStore", playerDataStore)
			intValue.Parent = playerData
		elseif type(value) == "string" then
			local stringValue = Instance.new("StringValue")
			stringValue.Name = data
			stringValue.Value = value
			stringValue:SetAttribute("DataStore", playerDataStore)
			stringValue.Parent = playerData
		end
	end
end

local function addMissingValues(playerData, playerDataStore)
	local data = PlayerDataStores[playerDataStore]
	-- Add missing values
	for data, value in pairs(data) do
		if not playerData:FindFirstChild(data) then
			if type(value) == "number" then
				local intValue = Instance.new("IntValue")
				intValue.Name = data
				intValue.Value = value
				intValue:SetAttribute("DataStore", playerDataStore)
				intValue.Parent = playerData
			elseif type(value) == "string" then
				local stringValue = Instance.new("StringValue")
				stringValue.Name = data
				stringValue.Value = value
				stringValue:SetAttribute("DataStore", playerDataStore)
				stringValue.Parent = playerData
			end
		end
	end
end

local function setupData(player, DATA)
	local playerData = player:FindFirstChild("PlayerData")
	
	if not playerData then
		playerData = Instance.new("Folder")
		playerData.Name = "PlayerData"
	end
	-- Create values from DataStore
	for playerDataStore, data in pairs(DATA) do
		-- Checking if Data is not empy
		if next(data) ~= nil then
			for data, value in pairs(data) do
				if type(value) == "number" then
					local intValue = Instance.new("IntValue")
					intValue.Name = data
					intValue.Value = value
					intValue:SetAttribute("DataStore", playerDataStore)
					intValue.Parent = playerData
				end
				if type(value) == "string" then
					local stringValue = Instance.new("StringValue")
					stringValue.Name = data
					stringValue.Value = value
					stringValue:SetAttribute("DataStore", playerDataStore)
					stringValue.Parent = playerData
				end
			end
			
			addMissingValues(playerData, playerDataStore)
		else
			
			createDefaultValues(playerData, playerDataStore)
		end
	end
	
	playerData.Parent = player
end

return setupData
