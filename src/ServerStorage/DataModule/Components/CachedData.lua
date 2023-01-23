local CachedData = {}

function CachedData.init()
	CachedData.data = {}
end

function CachedData.clearCache(userId)
	CachedData.data[userId] = nil
end

return CachedData
