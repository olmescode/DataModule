local initialValues = {
	-- The name of the datastore used by the Data Store to store the data
	-- that players have collected
	-- [Format for setup Data]
	ExampleDataStore1 = {
		Playtime = 0,
		HalloweenCandies = 0
	},
	ExampleDataStore2 = {
		Event = "HalloweenEvent",
		Banned = true,
		Items = {
			4343758,  -- ColdFyre Armor
			28521575  -- Slime Shield
		},
		Powers = {
			WalkSpeed = 100,
			JumpPower = 2000
		}
	},

	-- When set to true the ModuleData will no longer track the data that
	-- have been changed. This can be used when testing instead of having 
	-- to manually delete the entries in the DataStore.
	resetOnPlayerRemoving = true,
}

return initialValues
