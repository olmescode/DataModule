local RunService = game:GetService("RunService")
local DataStoreService = game:GetService("DataStoreService")

local DataModule = script:FindFirstAncestor("DataModule")
local DataManger = require(DataModule.Modules.DataManger)

local function savePlayerDataAsync(userId, playerData)
	for dataStore, data in pairs(playerData) do
		-- Get Global DataStore
		local dataStore = DataStoreService:GetDataStore(dataStore)
		return DataManger.updateDataAsync(dataStore, userId, data)
	end
end

local function onBindToClose(CachedData)
	--[[
		Saves the player's data to the datastore and cleans up any data
		associated with them

		Parameters:
		player: The player to save data for and clean up resources for
	]]
	return function()
		if RunService:IsStudio() then
			-- Avoid writing studio data to production and stalling test session closing
			return
		end
		-- Reference for yielding and resuming later
		local mainThread = coroutine.running()

		-- Counts up for each new thread, down when the thread finishes. When 0 is reached,
		-- the individual thread knows it's the last thread to finish and should resume the main thread
		local numThreadsRunning = 0
		
		-- Calling this function later starts on a new thread because of coroutine.wrap
		local startSaveThread = coroutine.wrap(function(userId, playerData)
			-- Perform the save operation
			local success, errorMessage = pcall(savePlayerDataAsync, userId, playerData)
			if not success then
				warn(string.format("Failed to save %d's data: %s", userId, errorMessage))
			end

			-- Thread finished, decrement counter
			numThreadsRunning -= 1

			if numThreadsRunning == 0 then
				-- This was the last thread to finish, resume main thread
				coroutine.resume(mainThread)
			end
		end)
		
		-- Iterates over all the data of players still in the game that hasn't been saved
		for userId, playerData in pairs(CachedData) do
			numThreadsRunning += 1

			-- This loop finishes running and counting numThreadsRunning before any of
			-- the save threads start because coroutine.wrap has built-in deferral on start
			startSaveThread(userId, playerData)
		end

		if numThreadsRunning > 0 then
			-- Stall shutdown until save threads finish. Resumed by the last save thread when it finishes
			coroutine.yield()
		end
	end
end

return onBindToClose
