local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataModule = require(ReplicatedStorage:WaitForChild("DataModule"))

local ProxyPrompt  = game.Workspace.SpawnLocation.ProximityPrompt

ProxyPrompt.Triggered:Connect(function(player)
	local playTime = DataModule.retrieveData(player.UserId, "Playtime")
	
	playTime = playTime + 10
	print("You got +10 points!", playTime)
	
	DataModule.updateData(player.UserId, "Playtime", playTime)
end)


DataModule.onUpdate("Playtime", function(userId, dataKey, dataValue)
	print("Playtime for player " .. userId .. " has been updated to " .. dataValue)
end)


DataModule.onUpdateData(function(userId, dataKey, dataValue)
	print("Data has been update for user", userId, dataKey, dataValue)
end)
