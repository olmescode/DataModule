export type PlayerData = { [string]: any }

local CachedData = {}

function CachedData.init()
	CachedData._playerData = {} :: { [string]: PlayerData }
	CachedData._threadsPendingPlayerDataLoad = {} :: { [string]: { thread } }
	CachedData._playerDataLoadErrors = {} :: { [string]: string }
end

--[[
	Cleans up resources used by this player

	Parameters:
	userId: The userId of the player to clean up resources for
]]
function CachedData.clearCache(userId)
	CachedData._playerData[userId] = nil
end

return CachedData
