local DataModule = script:FindFirstAncestor("DataModule")

local IsLoadingData = DataModule.Remotes.IsLoadingData

return function()
	IsLoadingData:Invoke()
end
