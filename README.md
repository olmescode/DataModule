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

**Before the first use for a given player, always ensure the data has loaded:**

~~~
-- Server:
if not PlayerDataServer.hasLoaded(player) then
    PlayerDataServer.waitForDataLoadAsync(player)
end

-- Client: 
if not PlayerDataClient.hasLoaded() then
    PlayerDataClient.loaded:Wait()
end
~~~

## Setting up
~~~
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
		DataModule.loadDataAsync(dataStore, player.UserId, data)
	end
end)

Players.PlayerRemoving:Connect(function(player)
	-- Save the player's data when they leave
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
~~~

## API Documentation

### Configurations
* `config`: A module that holds the server configurations.

### API Functions
* `loadDataAsync(dataStore, player, data)`: loads the data of a player when they join the game
* `saveDataAsync(player, resetOnPlayerRemoving)`: saves the data of a player when they leave the game
* `onServerShutdown()`: saves the data of all players when the server shuts down
* `autosaveData()`: saves the data of all players periodically

### Server APIs
* `saveData(player, valueName)`: A function that saves the data of a specific player

### Server and Client APIs
* `setData(player, dataStore, valueName, value)`: allows the server and client to set new data in the cache for a specific player
* `retrieveData(player, valueName)`: allows the server and client to retrieve data from the cache of a specific player
* `updateData(player, valueName, value)`: allows the server and client to update the data in the cache of a specific player
* `deleteData(player, valueName)`: allows the server and client to delete the data in the cache of a specific player

### New APIs
* `isLoadingData(player)`: Returns true if the server is currently loading the player's data
* `waitForDataLoadAsync(player)`: Yields until the player's data has loaded.
* `hasLoaded(player)`: Returns true if the server has finished loading the player's data.
* `hasLoadingErrored(player)`: Returns true if PlayerDataServer was unable to load the player's data.
* `getLoadError(player)`: Returns the error type encountered while loading.
* `loadedData`: A new Event that fires when the player's data has finished loading.

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
