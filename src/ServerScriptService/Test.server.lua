local ServerStorage = game:GetService("ServerStorage")
local DataModule = require(ServerStorage:WaitForChild("DataModule"))
--local CachedData = require(ServerStorage.DataModule.Components.CachedData)

local ProxyPrompt  = game.Workspace.SpawnLocation.ProximityPrompt

ProxyPrompt.Triggered:Connect(function(player)
	local playTime = DataModule.retrieveData(player.UserId, "Playtime")
	
	playTime = playTime + 10
	print("You got +10 points!")
	
	DataModule.updateData(player.UserId, "Playtime", playTime)
end)

DataModule.onUpdateData("Playtime", function(userId, dataKey, dataValue)
	print("Playtime for player " .. userId .. " has been updated to " .. dataValue)
end)

DataModule.onUpdateData(function(userId, dataKey, dataValue)
	print("Data has been update for user", userId, dataKey, dataValue)
end)
