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
	-- CRUD (create, read, update, and delete)
	-- Server APIs
	loadDataAsync = onPlayerAdded(CachedData), 
	saveDataAsync = onPlayerRemoved(CachedData),
	onBindToClose = onBindToClose(CachedData),
	autosave = autosave(CachedData),
	config = config,
	
	-- Client APIs
	
	-- Server and client APIs
	retrieveData = retrieveData(CachedData),
	updateData = updateData(CachedData),
	setData = setData(CachedData),
	deleteData = deleteData(CachedData),
	saveData = saveData(CachedData),
	
	-- Callbacks
	onUpdateData = callbacks.updateDataCallback.setCallback,
	onSetData = callbacks.setDataCallback.setCallback,
	onDeleteData = callbacks.deleteDataCallvack.setCallback,
	
	onUpdate = callbacks.addCallback
	
}

function DataModule.init()
	assert(RunService:IsServer(), "DataModule must be called on server")
	
	CachedData.init()
end

DataModule.init()

return DataModule
