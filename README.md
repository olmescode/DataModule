# DataModule
DataModule is a versatile and efficient Roblox Library that provides a central point to manage and cache storage players' data in Roblox games. The library includes configurations, server, and client APIs, and callbacks. 

## Features
The DataModule library offers a number of key features, including:

* Easy-to-use, clear, and modular API for data storage and retrieval.
* Server and client APIs for setting, retrieving, updating, and deleting data.
* Efficient data caching, with the library storing data in memory for quick access.
* Guaranteed consistency between server and client data.
* Event-based callbacks for changes to data, including updates, sets, and deletes.
* Default data options for players with no saved data in the DataStore.
* Autosaving feature to automatically save data changes in the DataStore.

## Usage
To use the DataModule library in your project, you need to require the DataModule script. This ModuleScript contains the main functionalities of the library, including the configuration, functions, server APIs, client APIs, and callbacks.

## Setting up
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

startAutosave()
~~~
## API Documentation

### Configurations
* `config`: A module that holds the server configurations.

### API Functions
* `loadDataAsync(dataStore, userId, data)`: loads the data of a player when they join the game
* `saveDataAsync(userId, resetOnPlayerRemoving)`: saves the data of a player when they leave the game
* `onServerShutdown()`: saves the data of all players when the server shuts down
* `autosaveData()`: saves the data of all players periodically

### Server APIs
* `saveData(userId, dataKey)`: A function that saves the data of a specific player

### Server and Client APIs
* `setData(userId, dataStore, dataKey, dataValue)`: allows the server and client to set new data in the cache for a specific player
* `retrieveData(userId, dataKey)`: allows the server and client to retrieve data from the cache of a specific player
* `updateData(userId, dataKey)`: allows the server and client to update the data in the cache of a specific player
* `deleteData(userId, dataKey)`: allows the server and client to delete the data in the cache of a specific player

## Callbacks
The DataModule Library offers callbacks to handle the changes made in the cache and DataStore. These callbacks are available for the update, set, and delete operations.

* `onUpdateData(callback)`: A callback that fires when the value of a specific data in the cache is changed.
* `onSetData(callback)`: A callback that fires when the data of a specific player is set.
* `onDeleteData(callback)`: A callback that fires when the data of a specific player is deleted.
* `onUpdate(dataKey, callback)`: A callback that fires when any data in the cache is changed.

## Additional Information
Please note that the DataModule library will only persist data changes made through the `setData`, `updateData`, and `deleteData` methods when called from the server. These changes will be saved in the designated DataStore.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
