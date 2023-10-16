local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataModule = ReplicatedStorage:WaitForChild("DataModule")

-- Require conductor
require(DataModule.Conductor)()
