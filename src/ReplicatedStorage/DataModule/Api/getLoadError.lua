local DataModule = script:FindFirstAncestor("DataModule")
local PlayerDataErrorType = require(DataModule.PlayerDataErrorType)

local function getLoadError(CachedData)
	--[[
		Returns the error type encountered while loading. 
		Will return nil if PlayerDataClient.hasLoadingErrored returns false

		Parameters:
		player: The player to check if data has loaded for
	]]
	return function(player: Player)
		return CachedData._playerDataLoadErrors[player.UserId] :: PlayerDataErrorType.EnumType?
	end
end

return getLoadError
