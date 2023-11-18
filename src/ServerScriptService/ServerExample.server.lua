local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataModule = require(ReplicatedStorage:WaitForChild("DataModule"))

local ProxyPrompt  = game.Workspace.SpawnLocation.ProximityPrompt

ProxyPrompt.Triggered:Connect(function(player)
	-- Yield until the Player's data has loaded.
	if not DataModule.hasLoaded(player) then
		DataModule.waitForDataLoadAsync(player)
	end
	
	-- Retrieve the current cash value for the player from the DataModule
	local cash = DataModule.retrieveData(player.UserId, "Cash")
	
	cash = cash + 10
	
	-- Update the cash value in the DataModule for the player
	DataModule.updateData(player.UserId, "Cash", cash)
end)

-- Register a callback for updates to the "Cash" data specifically
DataModule.onUpdate("Cash", function(userId, dataKey, dataValue)
	print("Cash for player " .. userId .. " has been updated to " .. dataValue)
end)

-- Register a general callback for any updates to player data
DataModule.onUpdateData(function(userId, dataKey, dataValue)
	print("Data has been update for user", userId, dataKey, dataValue)
end)
