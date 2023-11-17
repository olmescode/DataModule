local function waitForDataLoadAsync(CachedData)
	--[[
		Yields until the Player's data has loaded.
		If the player leaves before their data has loaded, the thread 
		will be discarded

		Parameters:
		player: The player to check if data has loaded for
	]]
	return function(player: Player)
		CachedData._threadsPendingPlayerDataLoad[player] = CachedData._threadsPendingPlayerDataLoad[player]
			or {}

		-- We'll store the thread and resume it in _resumeThreadsPendingLoad when the data loads
		table.insert(CachedData._threadsPendingPlayerDataLoad[player], coroutine.running())

		coroutine.yield()
	end
end

return waitForDataLoadAsync
