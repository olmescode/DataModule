local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CachedData = require(script.Components.CachedData)

local remoteEvent = script.Remotes.RemoteEvent

remoteEvent.OnClientEvent:Connect(function(playerData)
	-- Handle received playerData here
	CachedData.data = playerData
end)
