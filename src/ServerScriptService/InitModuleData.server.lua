local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local ModuleData = ServerStorage:WaitForChild("ModuleData")
require(ModuleData)

local loadData = require(ModuleData.Api.loadData)
local saveData = require(ModuleData.Api.saveData)
--ModuleData.Init()
Players.PlayerAdded:Connect(loadData)
Players.PlayerRemoving:Connect(saveData)
