local function mergeTables(playerData, DefaultStores)
	for index, value in pairs(DefaultStores) do
		if not playerData[index] then
			playerData[index] = value
		end
	end
	return playerData
end

return mergeTables
