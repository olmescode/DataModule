local Players = game:GetService("Players")
local player = Players.LocalPlayer

local Conductor = {}

local DataModule = script:FindFirstAncestor("DataModule")
local DataModuleAPI = require(DataModule)

local enums = require(DataModule.enums)

-- Events
Conductor.LoadData = DataModule.Remotes.LoadData
Conductor.UpdateData = DataModule.Remotes.UpdateData
Conductor.SetData = DataModule.Remotes.SetData
Conductor.DeleteData = DataModule.Remotes.DeleteData

-- Function to handle the LoadData event
Conductor.handleLoadData = function(dataStore, playerData)
	DataModuleAPI.loadDataAsync(dataStore, player.UserId, playerData)
end

-- Function to handle the UpdateData event
Conductor.handleUpdateData = function(dataKey, dataValue)
	DataModuleAPI.updateData(player.UserId, dataKey, dataValue)
end

-- Function to handle the SetData event
Conductor.handleSetData = function(dataStore, dataKey, dataValue)
	DataModuleAPI.setData(player.UserId, dataStore, dataKey, dataValue)
end

-- Function to handle the DeleteData event
Conductor.handleDeleteData = function(dataKey)
	DataModuleAPI.deleteData(player.UserId, dataKey)
end

local hasBeenCalled = false

return function(stubs)
	if hasBeenCalled then
		error("Conductor has already been called")
		return
	end
	
	-- Used for testing only
	if stubs then
		for i, v in pairs(stubs) do
			Conductor[i] = v
		end
	end

	-- Connect events
	Conductor.LoadData.OnClientEvent:Connect(Conductor.handleLoadData)
	Conductor.UpdateData.OnClientEvent:Connect(Conductor.handleUpdateData)
	Conductor.SetData.OnClientEvent:Connect(Conductor.handleSetData)
	Conductor.DeleteData.OnClientEvent:Connect(Conductor.handleDeleteData)

	hasBeenCalled = true
	script:SetAttribute(enums.Attribute.FrameworkReady, true)

	return Conductor
end
