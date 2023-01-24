local CachedData = {}
CachedData.callbacks = {}

function CachedData.init()
	CachedData.data = {}
end

function CachedData.clearCache(userId)
	CachedData.data[userId] = nil
end

function CachedData.onUpdate(dataKey, callback)
	CachedData.callbacks[dataKey] = callback
end

return CachedData
