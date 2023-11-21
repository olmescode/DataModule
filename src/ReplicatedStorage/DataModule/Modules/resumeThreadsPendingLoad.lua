local function resumeThreadsPendingLoad(CachedData)
	--[[
		Resumes any threads that were yielded by PlayerData:waitForDataLoadAsync()

		Parameters:
		player: The player to check if data has loaded for
	]]
	return function(player: Player)
		if CachedData._threadsPendingPlayerDataLoad[player] then
			for _, thread in ipairs(CachedData._threadsPendingPlayerDataLoad[player]) do
				task.spawn(thread)
			end
		end

		CachedData._threadsPendingPlayerDataLoad[player] = nil
	end
end

return resumeThreadsPendingLoad
