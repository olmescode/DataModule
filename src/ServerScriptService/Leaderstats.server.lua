local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local DataStoreService = game:GetService("DataStoreService")
local dataStore = DataStoreService:GetDataStore("ExampleDataStore3") -- Global DataStore
local orderedDataStore = DataStoreService:GetOrderedDataStore("ExampleDataStore3") -- OrdererDataStore

local ServerStorage = game:GetService("ServerStorage")
local ModuleData = require(ServerStorage:WaitForChild("ModuleData"))

local function format(Int)
	return string.format("%i", Int) --%02i
end

local function convert(Minutes)
	--local Minutes = math.floor(Seconds/60)
	--Seconds = Seconds - Minutes*60
	local Minutes = Minutes

	local Hours = math.floor(Minutes/60)
	Minutes = Minutes - Hours*60

	local Days = math.floor(Hours/24)
	Hours = Hours - Days*24

	if Days < 1 then
		return format(Hours).."h "..format(Minutes).."m"
	elseif  Days >= 1 then
		return format(Days).."d "..format(Hours).."h"
	end
end

local function saveData(player)
	local PlayerData = player:FindFirstChild("PlayerData")
	local Playtime = PlayerData.Playtime
	local DATA = {}

	if PlayerData then
		--DATA["Playtime"] = Playtime.Value
		--ModuleData.saveData(dataStore, player.UserId, DATA)
		ModuleData.saveOrderedDataAsync(orderedDataStore, player.UserId, Playtime.Value)
	end
end

local function autosaving(player)
	local leaderstats = player:FindFirstChild("leaderstats")
	local Playtime = player.PlayerData.Playtime
	local playTime = player.leaderstats.Playtime
	
	while true do
		task.wait(60)
		Playtime.Value += 1
		playTime.Value = convert(Playtime.Value)

		saveData(player)
	end
end

local function newLeaderstat(player)
	local Playtime = ModuleData.getData(player, "Playtime")
	
	if Playtime == false then return end
	
	-- Leaderstats
	local leaderStats = Instance.new("Folder")
	leaderStats.Name = "leaderstats"

	local stringValue = Instance.new("StringValue")
	stringValue.Name = "Playtime"
	
	stringValue.Value = convert(Playtime.Value)
	stringValue.Parent = leaderStats
	leaderStats.Parent = player
	
	autosaving(player)
end

local function onShutdown()
	if RunService:IsStudio() then return end
	coroutine.wrap(saveData)
end

Players.PlayerAdded:Connect(newLeaderstat)
--Players.PlayerRemoving:Connect(saveData)
--game:BindToClose(onShutdown)