local CachedData = {}

function CachedData.init()
	CachedData.data = {}
end

--[[
	Cleans up resources used by this player

	Parameters:
	userId: The userId of the player to clean up resources for
]]
function CachedData.clearCache(userId)
	CachedData.data[userId] = nil
end

return CachedData
