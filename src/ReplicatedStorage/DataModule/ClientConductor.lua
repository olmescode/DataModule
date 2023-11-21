local Players = game:GetService("Players")
local player = Players.LocalPlayer

type PlayerData = { [string]: any }

local Conductor = {}

local DataModule = script:FindFirstAncestor("DataModule")
local DataModuleAPI = require(DataModule)

local enums = require(DataModule.enums)
local PlayerDataErrorType = require(script.Parent.PlayerDataErrorType)

-- Events
Conductor.LoadData = DataModule.Remotes.LoadData
Conductor.UpdateData = DataModule.Remotes.UpdateData
Conductor.SetData = DataModule.Remotes.SetData
Conductor.DeleteData = DataModule.Remotes.DeleteData

-- Function to handle the LoadData event
Conductor.handleLoadData = function(dataStoreName: string, data: PlayerData, errorType: PlayerDataErrorType.EnumType?)
	DataModuleAPI.loadDataAsync(dataStoreName, player, data, errorType)
end

-- Function to handle the UpdateData event
Conductor.handleUpdateData = function(valueName: string, value: any)
	DataModuleAPI.updateData(player, valueName, value)
end

-- Function to handle the SetData event
Conductor.handleSetData = function(dataStoreName: string, valueName: string, value: any)
	DataModuleAPI.setData(player, dataStoreName, valueName, value)
end

-- Function to handle the DeleteData event
Conductor.handleDeleteData = function(valueName: string)
	DataModuleAPI.deleteData(player, valueName)
end


local hasBeenCalled = false

return function(stubs)
	if hasBeenCalled then
		error("Conductor has already been called")
		return
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
