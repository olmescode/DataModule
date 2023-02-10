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
local config = require(script.serverConfig)
local callbacks = require(script.callbacks)

local DataModule = {
	-- Configurations
	config = config,
	
	-- Functions
	loadDataAsync = onPlayerAdded(CachedData), 
	saveDataAsync = onPlayerRemoved(CachedData),
	onServerShutdown = onBindToClose(CachedData),
	autosaveData = autosave(CachedData),
	
	-- Server APIs
	saveData = saveData(CachedData),
	
	-- Client APIs
	
	-- Server and client APIs
	setData = setData(CachedData),
	retrieveData = retrieveData(CachedData),
	updateData = updateData(CachedData),
	deleteData = deleteData(CachedData),
	
	-- Callbacks
	onUpdateData = callbacks.updateDataCallback.setCallback,
	onSetData = callbacks.setDataCallback.setCallback,
	onDeleteData = callbacks.deleteDataCallvack.setCallback,

	--[[
		Fires when the value of a specific data in the cache is changed
	]]
	onUpdate = callbacks.addCallback
	
}

function DataModule.init()
	assert(RunService:IsServer(), "DataModule must be called on server")
	
	CachedData.init()
end

DataModule.init()

return DataModule
