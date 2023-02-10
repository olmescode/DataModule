local CachedData = {}
CachedData.callbacks = {}

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
--[[
	Fires when the value of a specific instance is changed

	Parameters:
	dataKey: The name of the instance in the cache
]]
function CachedData.onUpdate(dataKey, callback)
	CachedData.callbacks[dataKey] = callback
end

return CachedData
