local function hasLoaded(CachedData)
	--[[
		Returns true if the server has finished loading the player's data. 
		This should be called before reading or writing to a player's data. 
		If this returns false, waitForDataLoadAsync can be used to yield until 
		the data has loaded

		Parameters:
		player: The player to check if data has loaded for
	]]
	return function(player: Player)
		local hasData = CachedData.data[player.UserId] and true or false

		return hasData
	end
end

return hasLoaded
