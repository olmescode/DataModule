local DataModule = script:FindFirstAncestor("DataModule")

local state = require(DataModule.state)

return function()
	return state.LoadingData
end
