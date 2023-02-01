local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local DataModule = require(ServerStorage:WaitForChild("DataModule"))
local AUTOSAVE_INTERVAL = 300 -- 5 minutes

local DataStores = {
	ExampleDataStore5 = {
		Playtime = 10,
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
		DataModule.loadDataAsync(dataStore, player, data)
	end
end)

--Players.PlayerAdded:Connect(onPlayerAdded(player, DataStores))

Players.PlayerRemoving:Connect(function(player)
	DataModule.saveDataAsync(player, DataModule.config.resetOnPlayerRemoving)
end)

--[[
	An infinite loop that saves the data of all players currently in the
	experience every AUTOSAVE_INTERVAL
]]
local function startAutosave()
	task.spawn(function()
		while true do
			task.wait(AUTOSAVE_INTERVAL)

			DataModule.autosave()
		end
	end)
end

game:BindToClose(function()
	DataModule.onBindToClose()
end)

--[[
local playTime = DataModule.retrieveData(player.UserId, "Playtime")
print(playTime) -- Output: 10

local updatedPlayTime = DataModule.updateData(player.UserId, "Playtime", 20)
print(updatedPlayTime) -- Output: 20

local newEvent = DataModule.setData(player.UserId, "ExampleDataStore1", "NewEvent", "true")
print(newEvent) -- Output: "true"

local deletedData = DataModule.deleteData(player.UserId, "Playtime")
print(deletedData) -- Output: true
]]

-- add enabled - disables
-- Set callbacks funtions on client
-- Delete callbacks not longer in use?
