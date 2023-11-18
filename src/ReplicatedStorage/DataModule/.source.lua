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
local waitForDataLoadAsync = require(script.Api.waitForDataLoadAsync)
local hasLoaded = require(script.Api.hasLoaded)
local hasLoadingErrored = require(script.Api.hasLoadingErrored)
local getLoadError = require(script.Api.getLoadError)

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
	isLoadingData = isLoadingData(CachedData),
	waitForDataLoadAsync = waitForDataLoadAsync(CachedData),
	
	-- Client APIs
	
	-- Server and client APIs
	setData = setData(CachedData, serverConfig),
	retrieveData = retrieveData(CachedData),
	updateData = updateData(CachedData, serverConfig),
	deleteData = deleteData(CachedData, serverConfig),
	hasLoaded = hasLoaded(CachedData),
	getLoadError = getLoadError(CachedData),
	hasLoadingErrored = hasLoadingErrored(CachedData),
	
	-- Callbacks
	onUpdateData = callbacks.updateDataCallback.setCallback,
	onSetData = callbacks.setDataCallback.setCallback,
	onDeleteData = callbacks.deleteDataCallvack.setCallback,
	
	-- Events
	loadedData = script.Remotes.LoadedData.Event,

	--[[
		Fires when the value of a specific data in the cache is changed
	]]
	onUpdate = callbacks.addCallback
	
}

-- Initialize the cached data when the module is first required
CachedData.init()

return DataModule
