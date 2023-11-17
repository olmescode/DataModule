local function setPlayerDataAsErrored(CachedData)
	--[[
		We need to mark their profile as errored so we can disable purchases 
		and prevent their save from being overwritten.

		Parameters:
		player: The player to check if data has loaded for
		errorType: 
	]]
	return function(player: Player, errorType: string)
		CachedData._playerDataLoadErrors[player.UserId] = errorType
	end
end

return setPlayerDataAsErrored
