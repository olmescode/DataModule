local noop = function() end

local function createCallback()
	local callback = noop

	local function setCallback(newCallback)
		callback = newCallback
	end

	local function isCallbackSet()
		return callback ~= noop
	end

	local function fireCallback(...)
		return callback(...)
	end

	return {
		fireCallback = fireCallback,
		setCallback = setCallback,
		isCallbackSet = isCallbackSet,
	}
end

return createCallback
