print("Required ModuleData")
local RunService = game:GetService("RunService")

local CachedData = require(script.Components.CachedData)
local onPlayerAdded = require(script.Components.onPlayerAdded)
local onPlayerRemoved = require(script.Components.onPlayerRemoved)
local onBindToClose = require(script.Components.onBindToClose)
local autosave = require(script.Components.autosave)
local retrieveData = require(script.Api.retrieveData)
local updateData = require(script.Api.updateData)
local setData = require(script.Api.setData)
local deleteData = require(script.Api.deleteData)
local saveData = require(script.Api.saveData)
local callbacks = require(script.callbacks)
local isLoadingData = require(script.Api.isLoadingData)

local serverConfig = nil
if RunService:IsServer() then
	serverConfig = require(script.serverConfig)
end

local DataModule = {
	-- Configurations
	config = serverConfig,
	
	-- Functions
	loadDataAsync = onPlayerAdded(CachedData, serverConfig),
	saveDataAsync = onPlayerRemoved(CachedData),
	onServerShutdown = onBindToClose(CachedData),
	autosaveData = autosave(CachedData),
	
	-- Server APIs
	saveData = saveData(CachedData),
	
	-- Client APIs
	
	-- Server and client APIs
	setData = setData(CachedData, serverConfig),
	retrieveData = retrieveData(CachedData),
	updateData = updateData(CachedData, serverConfig),
	deleteData = deleteData(CachedData, serverConfig),
	
	isLoadingData = isLoadingData,
	
	-- Callbacks
	onUpdateData = callbacks.updateDataCallback.setCallback,
	onSetData = callbacks.setDataCallback.setCallback,
	onDeleteData = callbacks.deleteDataCallvack.setCallback,

	--[[
		Fires when the value of a specific data in the cache is changed
	]]
	onUpdate = callbacks.addCallback
	
}

-- Initialize the cached data when the module is first required
CachedData.init()

return DataModule
