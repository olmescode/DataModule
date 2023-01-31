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
		Iterates through each userId and playerData in the CachedData of players
		still in the game and save player data in a parallel manner which can
		improve the performance and speed of the save operation
		
		The number of running threads is tracked using the 'numThreadsRunning' variable
		when all the coroutines have finished, the main coroutine will be resumed
	]]
	return function()
		if RunService:IsStudio() then
			-- Avoid writing studio data to production and stalling test session closing
			return
		end
		-- Save the current coroutine for yielding and resuming later
		local mainThread = coroutine.running()

		local numThreadsRunning = 0
		
		-- A coroutine that wraps the `savePlayerDataAsync` to call on a new thread
		local startSaveThread = coroutine.wrap(function(userId, playerData)
			-- Perform the save operation
			local success, errorMessage = pcall(savePlayerDataAsync, userId, playerData)
			if not success then
				warn(string.format("Failed to save %d's data: %s", userId, errorMessage))
			end

			numThreadsRunning -= 1
			
			if numThreadsRunning == 0 then
				coroutine.resume(mainThread)
			end
		end)

		for userId, playerData in pairs(CachedData) do
			numThreadsRunning += 1

			-- This loop finishes running and counting numThreadsRunning before any of
			-- the save threads start because coroutine.wrap has built-in deferral on start
			startSaveThread(userId, playerData)
		end
		
		-- Stall shutdown until save threads finish
		if numThreadsRunning > 0 then
			coroutine.yield()
		end
	end
end

return onBindToClose
