local Players = game:GetService("Players")
local player = Players.LocalPlayer

type PlayerData = { [string]: any }

local Conductor = {}

local DataModule = script:FindFirstAncestor("DataModule")
local DataModuleAPI = require(DataModule)

local enums = require(DataModule.enums)

Conductor.IsLoadingDataModule = require(DataModule.Modules.IsLoadingDataModule)

-- Events
Conductor.LoadData = DataModule.Remotes.LoadData
Conductor.UpdateData = DataModule.Remotes.UpdateData
Conductor.SetData = DataModule.Remotes.SetData
Conductor.DeleteData = DataModule.Remotes.DeleteData
Conductor.IsLoadingData = DataModule.Remotes.IsLoadingData

-- Function to handle the LoadData event
Conductor.handleLoadData = function(dataStoreName: string, data: PlayerData)
	DataModuleAPI.loadDataAsync(dataStoreName, player.UserId, data)
end

-- Function to handle the UpdateData event
Conductor.handleUpdateData = function(dataKey: string, dataValue: any)
	DataModuleAPI.updateData(player.UserId, dataKey, dataValue)
end

-- Function to handle the SetData event
Conductor.handleSetData = function(dataStoreName: string, dataKey: string, dataValue: any)
	DataModuleAPI.setData(player.UserId, dataStoreName, dataKey, dataValue)
end

-- Function to handle the DeleteData event
Conductor.handleDeleteData = function(dataKey: string)
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
	
	-- Is Loading Data: Lets people know if SSF is loading a data
	Conductor.handleIsLoadingData = Conductor.IsLoadingDataModule
	Conductor.IsLoadingData.OnInvoke = Conductor.handleIsLoadingData

	hasBeenCalled = true
	script:SetAttribute(enums.Attribute.FrameworkReady, true)

	return Conductor
end
