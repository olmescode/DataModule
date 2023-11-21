local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataModule = require(ReplicatedStorage:WaitForChild("DataModule"))

local ProxyPrompt  = game.Workspace.SpawnLocation.ProximityPrompt

ProxyPrompt.Triggered:Connect(function(player)
	-- Yield until the Player's data has loaded.
	if not DataModule.hasLoaded(player) then
		DataModule.waitForDataLoadAsync(player)
	end
	
	-- Retrieve the current cash value for the player from the DataModule
	local cash = DataModule.retrieveData(player, "Cash")
	
	cash = cash + 10
	
	-- Update the cash value in the DataModule for the player
	DataModule.updateData(player, "Cash", cash)
end)

-- Register a callback for updates to the "Cash" data specifically
DataModule.onUpdate("Cash", function(player, valueName, value)
	print("Hey, got some cash for player", player, ":", valueName, "updated to", value)

end)

-- Register a general callback for any updates to player data
DataModule.onUpdateData(function(player, valueName, value)
	print("Data has been update for player", player, valueName, value)
end)
