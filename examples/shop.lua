local player_data = {}

local shop_items = {
	{ name = "Health Potion", price = 50, spawngroup = 80 },
	{ name = "Mana Potion", price = 40, spawngroup = 106 },
	{ name = "Iron Sword", price = 150, spawngroup = 20 },
	{ name = "Steel Shield", price = 120, spawngroup = 120 },
	{ name = "Estrogen Undecylate", price = 200, spawngroup = 122 },
}

server_callback("PurchaseItem", function(account_id, item_index)
	if item_index < 1 or item_index > #shop_items then return end

	local item = shop_items[item_index]
	local player = player_data[account_id]

	if not player then return end -- Just in case client sends weird data

	if player.gold < item.price then -- GD wont let you buy if you are broke
		return
	end

	player.gold = player.gold - item.price

	local spawn_info = SpawnInfo.new(
		item.spawngroup,    -- GroupID
		0.0,                -- Delay
		0.0,                -- DelayRandomness
		false,              -- SpawnOrdered
		nil                 -- Remaps
	)

	-- Notify client
	FireClient(account_id, spawn_info)
end)

-- Give the player gold when they first connect
server_callback("PlayerJoin", function(account_id)
	player_data[account_id] = {
		gold = 1000
	}
end)

-- Prevent players taking up potentially infinite memory
server_callback("PlayerLeave", function(account_id)
	player_data[account_id] = nil
end)
