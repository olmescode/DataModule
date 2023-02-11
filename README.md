## DataModule
DataModule is a versatile and efficient Roblox Library that provides a central point to manage and cache storage players' data in Roblox games The library includes configurations, server, and client APIs, and callbacks. 

### Features
The DataModule library offers a number of key features, including:

* Easy-to-use, clear and modular API for data storage and retrieval.
* Server and client APIs for setting, retrieving, updating, and deleting data.
* Efficient data caching, with the library storing data in memory for quick access.
* Guaranteed consistency between server and client data
* Event-based callbacks for changes to data, including updates, sets, and deletes
* Default data options for players with no saved data in the DataStore
* Autosaving feature to automatically save data changes in the DataStore.

### Usage
To use the DataModule library in your project, you need to require the DataModule script. This script contains the main functionality of the library, including the configuration, functions, server APIs, client APIs, and callbacks.

### SetUp
~~~
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local DataModule = require(ServerStorage:WaitForChild("DataModule"))
local AUTOSAVE_INTERVAL = 300 -- 5 minutes

local DataStores = {
	ExampleDataStore = {
		Playtime = 10,
		PlayerPoints = 0
	},
	ExampleDataStore2 = {
		CurrentEvent = "HalloweenEvent",
		Banned = true,
		ExampleInventory = {
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
	DataModule.saveDataAsync(player.UserId, DataModule.config.resetOnPlayerRemoving)
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
~~~
### API Functions
* `addConfiguration()`: Passes in a table with the desired properties for the design of the overhead GUI
* `createOverheadGUI(player)`: Creates and displays the overhead GUI above the player's character
* `hasVipPass(player, vipPassId)`: Returns whether the player owns the specified VIP game pass
* `isTopPlayer(player)`: Returns whether the player is in the top 10 of the specified DataStore leaderboard
* `tweenUiGradient(uiGradient)`: Applies a looping animation to the specified UI gradient object

### Additional Information


### Note
