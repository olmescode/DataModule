local ServerStorage = game:GetService("ServerStorage")
local DataModule = require(ServerStorage:WaitForChild("DataModule"))
local CachedData = require(ServerStorage.DataModule.Components.CachedData)

local ProxyPrompt  = game.Workspace.SpawnLocation.ProximityPrompt

ProxyPrompt.Triggered:Connect(function(player)
	local playTime = DataModule.retrieveData(player.UserId, "Playtime")
	
	task.wait(1)
	playTime = playTime + 10
	DataModule.updateData(player.UserId, "Playtime", playTime)
	
	print(DataModule.retrieveData(player.UserId, "Playtime"))
end)

CachedData.onUpdate("Playtime", function(userId, dataKey, dataValue)
	print("Playtime for player " .. userId .. " has been updated to " .. dataValue)
end)
