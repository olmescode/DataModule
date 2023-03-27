local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

local DataModule = ReplicatedStorage:WaitForChild("DataModule")
local DataModuleAPI = require(DataModule)

local remotes = DataModule.Remotes

-- Listen to the SetData event fired from the server
remotes.LoadData.OnClientEvent:Connect(function(dataStore, playerData)
	DataModuleAPI.loadDataAsync(dataStore, player.UserId, playerData, true)
end)

-- Listen to the UpdateData event fired from the server
remotes.UpdateData.OnClientEvent:Connect(function(dataKey, dataValue)
	DataModuleAPI.updateData(player.UserId, dataKey, dataValue)
end)

-- Listen to the SetData event fired from the server
remotes.SetData.OnClientEvent:Connect(function(dataStore, dataKey, dataValue)
	DataModuleAPI.setData(player.UserId, dataStore, dataKey, dataValue)
end)

-- Listen to the DeleteData event fired from the server
remotes.DeleteData.OnClientEvent:Connect(function(dataKey)
	DataModuleAPI.deleteData(player.UserId, dataKey)
end)
