local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local DataModule = require(ServerStorage:WaitForChild("DataModule"))
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
	DataModule.loadDataAsync(player, DataStores)
	task.wait(10)
	local banned = DataModule.retrieveData(player.UserId, "Banned")
	local playTime = DataModule.retrieveData(player.UserId, "Playtime")
	local items = DataModule.retrieveData(player.UserId, "Items")
	print(items)
	print(playTime)
	print(banned)
	
	task.wait(5)
	local updatedPlayTime = DataModule.updateData(player.UserId, "Playtime", 200)
	print(DataModule.retrieveData(player.UserId, "Playtime"))
end)

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