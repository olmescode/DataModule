local createCallback = require(script.Parent.Modules.createCallback)

local callbacks = {
	updateDataCallback = createCallback(),
	setDataCallback = createCallback(), 
	deleteDataCallvack = createCallback()
}

--[[
	Fires when the value of a specific instance is changed

	Parameters:
	valueName: The name of the instance in the cache
	callback: The function to be added as a callback
]]
function callbacks.addCallback(valueName: string, callback: any)
	callbacks[valueName] = callback
end

return callbacks
