export type PlayerData = { [string]: any }

local CachedData = {}

function CachedData.init()
	CachedData._playerData = {} :: { [Player]: PlayerData }
	CachedData._threadsPendingPlayerDataLoad = {} :: { [Player]: { thread } }
	CachedData._playerDataLoadErrors = {} :: { [Player]: string }
end

--[[
	Cleans up resources used by this player

	Parameters:
	key: The key of the player to clean up resources for
]]
function CachedData.clearCache(player: Player)
	CachedData._playerData[player] = nil
	CachedData._playerDataLoadErrors[player] = nil
	CachedData._threadsPendingPlayerDataLoad[player] = nil
end

return CachedData
