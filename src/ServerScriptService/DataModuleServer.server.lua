local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Load the custom DataModule that handles player data
local DataModule = require(ReplicatedStorage:WaitForChild("DataModule"))

local AUTOSAVE_INTERVAL = 300 -- 5 minutes

-- Example data structures for different DataStores
local DataStores = {
	ExampleDataStore5 = {
		Playtime = 10,
		Cash = 10,
		HalloweenCandies = 0
	},
	ExampleDataStore6 = {
		Event = "HalloweenEvent",
		Banned = true,
		Items = {
			4343758,  -- ColdFyre Armor
			28521575  -- Slime Shield
		},
		Powers = {
			WalkSpeed = 100,
			JumpPower = 2000
		}
	}
}

Players.PlayerAdded:Connect(function(player)
	for dataStore, data in pairs(DataStores) do
		-- Load initial data for the player from predefined DataStores
		DataModule.loadDataAsync(dataStore, player, data)
	end
end)

Players.PlayerRemoving:Connect(function(player)
	-- Save the player's data when they leave
	DataModule.saveDataAsync(player)
end)

--[[
	An infinite loop that saves the data of all players currently in the
	experience every AUTOSAVE_INTERVAL
]]
local function startAutosave()
	task.spawn(function()
		while true do
			task.wait(AUTOSAVE_INTERVAL)
			-- Trigger autosave for all players in the game
			DataModule.autosaveData()
		end
	end)
end

game:BindToClose(function()
	-- Trigger onServerShutdown function to handle server shutdown and save data
	DataModule.onServerShutdown()
end)

startAutosave()
