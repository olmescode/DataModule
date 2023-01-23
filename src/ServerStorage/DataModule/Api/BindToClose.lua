local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")

local playerDataStore = DataStoreService:GetDataStore("PlayerData")

local allPlayerSessionDataCache = {}

local function savePlayerDataAsync(userId, data)
	return playerDataStore:UpdateAsync(userId, function(oldData)
		return data
	end)
end

local function onServerShutdown()
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
	local startSaveThread = coroutine.wrap(function(userId, sessionData)
		-- Perform the save operation
		local success, result = pcall(savePlayerDataAsync, userId, sessionData)
		if not success then
			-- Could implement a retry
			warn(string.format("Failed to save %d's data: %s", userId, result))
		end

		-- Thread finished, decrement counter
		numThreadsRunning -= 1

		if numThreadsRunning == 0 then
			-- This was the last thread to finish, resume main thread
			coroutine.resume(mainThread)
		end
	end)

	-- This assumes playerData gets cleared from the data table during a final save on PlayerRemoving,
	-- so this is iterating over all the data of players still in the game that hasn't been saved
	for userId, sessionData in pairs(allPlayerSessionDataCache) do
		numThreadsRunning += 1

		-- This loop finishes running and counting numThreadsRunning before any of
		-- the save threads start because coroutine.wrap has built-in deferral on start
		startSaveThread(userId, sessionData)
	end

	if numThreadsRunning > 0 then
		-- Stall shutdown until save threads finish. Resumed by the last save thread when it finishes
		coroutine.yield()
	end
end

--game:BindToClose(onServerShutdown)

return onServerShutdown
