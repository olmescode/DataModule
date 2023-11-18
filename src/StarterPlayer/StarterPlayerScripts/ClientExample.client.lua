local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataModule = require(ReplicatedStorage:WaitForChild("DataModule"))

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local playerGui = player:WaitForChild("PlayerGui")
local mainGui = playerGui:WaitForChild("GameGui")

local textLabel = mainGui.ShowStats.Money.Background.Amount

-- Wait for data to be loaded if it hasn't been loaded yet
if not DataModule.hasLoaded(player) then
	DataModule.loadedData:Wait()
end

local function updateTextLabel(value)
	textLabel.Text = value
end

-- Register a callback for updates to the "Playtime" data
DataModule.onUpdate("Cash", function(userId, dataKey, dataValue)
	print(string.format("You got +%d! %s for player %s has been updated", dataValue, dataKey, userId))

	updateTextLabel(dataValue)
end)

-- Retrieve the current cash value for the player from the DataModule
local initialCash = DataModule.retrieveData(player.UserId, "Cash")
updateTextLabel(initialCash) -- Update the TextLabel with the initial value
