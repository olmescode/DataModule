local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataModule = require(ReplicatedStorage:WaitForChild("DataModule"))
--local DataModuleAPI = require(DataModule)
--local onPlayerAdded = require(DataModule.Api.onPlayerAdded)

DataModule.init()

local DataStores = {
	ExampleDataStore1 = {
		Playtime = 10,
		HalloweenCandies = 0
	},
	ExampleDataStore2 = {
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
		DataModule.loadDataAsync(player, dataStore, data)
		--onPlayerAdded(player, dataStore, data)(player)
	end
end)

--Players.PlayerAdded:Connect(onPlayerAdded(player, DataStores))

Players.PlayerRemoving:Connect(function(player)
	DataModule.clearData(player)
end)

--[[
local playTime = DataModule.retrieveData(player.UserId, "Playtime")
print(playTime) -- Output: 10

local updatedPlayTime = DataModule.updateData(player.UserId, "Playtime", 20)
print(updatedPlayTime) -- Output: 20

local newEvent = DataModule.setData(player.UserId, "ExampleDataStore1", "NewEvent", "true")
print(newEvent) -- Output: "true"

local deletedData = DataModule.deleteData(player.UserId, "ExampleDataStore1")
print(deletedData) -- Output: true
]]


--Make the function when player is leaving with updateAsyn, a function to force update using setAsync and bindtoclose
--Set callbacks funtions on client and server