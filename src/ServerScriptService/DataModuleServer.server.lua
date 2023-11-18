local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataModule = require(ReplicatedStorage:WaitForChild("DataModule"))
local AUTOSAVE_INTERVAL = 300 -- 5 minutes

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
		DataModule.loadDataAsync(dataStore, player.UserId, data)
	end
end)

Players.PlayerRemoving:Connect(function(player)
	DataModule.saveDataAsync(player.UserId)
end)

--[[
	An infinite loop that saves the data of all players currently in the
	experience every AUTOSAVE_INTERVAL
]]
local function startAutosave()
	task.spawn(function()
		while true do
			task.wait(AUTOSAVE_INTERVAL)

			DataModule.autosaveData()
		end
	end)
end

game:BindToClose(function()
	DataModule.onServerShutdown()
end)
