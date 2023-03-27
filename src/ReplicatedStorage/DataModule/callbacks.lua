local createCallback = require(script.Parent.Modules.createCallback)

local callbacks = {
	updateDataCallback = createCallback(),
	setDataCallback = createCallback(), 
	deleteDataCallvack = createCallback()
}

--[[
	Fires when the value of a specific instance is changed

	Parameters:
	dataKey: The name of the instance in the cache
]]
function callbacks.addCallback(dataKey, callback)
	callbacks[dataKey] = callback
end

return callbacks
