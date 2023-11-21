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
	if DataModule.hasLoadingErrored(player) then
		local errorType = DataModule.getLoadError(player)
		print(errorType)
	else
		textLabel.Text = value
	end
end

-- Register a callback for updates to the "Cash" data
DataModule.onUpdate("Cash", function(player, valueName, value)
	print(string.format("Hey, player %s just got a Cash update! New value: %s", player.Name, value))

	updateTextLabel(value)
end)

-- Retrieve the current cash value for the player from the DataModule
local initialCash = DataModule.retrieveData(player, "Cash")
updateTextLabel(initialCash) -- Update the TextLabel with the initial value
