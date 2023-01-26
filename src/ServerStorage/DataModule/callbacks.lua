local createCallback = require(script.Parent.Modules.createCallback)

local callbacks = {
	updateDataCallback = createCallback(),
	setDataCallback = createCallback(), 
	deleteDataCallvack = createCallback()
}

function callbacks.addCallback(dataKey, callback)
	callbacks[dataKey] = callback
end

return callbacks
