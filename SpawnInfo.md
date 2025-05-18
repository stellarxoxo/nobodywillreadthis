## API Documentation: `SpawnInfo`

Used inside of `FireClient` and `FireAllClients`. Represents data that would be inside of a ghost spawn trigger a player's client will run.

Note: All properties default to 0, false, or nil, as appropriate.

### Constructors
```lua
new(
    GroupID: number,
    Delay: number,              -- optional
    DelayRandomness: number,    -- optional
    SpawnOrdered: boolean,      -- optional
    Remaps: string              -- optional
)             
```

### Properties
- **`GroupID`** (`number`)
The Group ID to spawn
- **`Delay`** (`number`)
The base delay (in seconds) after the client receives the event before spawning the GroupID.
- **`DelayRandomness`** (`number`)
A random delay added to the set delay. For example if you had the `Delay` set to 0.5 and `DelayRandomness` set to 0.1 you would have a range of 0.4 - 0.6
- **`SpawnOrdered`** (`boolean`)
Spawns the triggers in order from left to right.
- **`Remaps`** (`string`)
Period seperated list of remaps.
For example, to remap value 2 → 4 and 5 → 10 you would write "2.4.5.10" in this value.

Example code:
```lua
local function start_game()
    -- Do not start game if no players are in lobby
    if #GAME.Players == 0 then return end

    -- Choose a random player to be the imposter
    local imposter_account_id = GAME.Players[math.random(#GAME.Players)].AccountID

    -- Loop through all players
    for account_id in pairs(GAME.Players) do
        local spawn_group = 12

        -- Spawn a different group for the imposter than everyone else
        if account_id == imposter_account_id then
            spawn_group = 56 -- imposter spawn group
        end

        -- Alternatively, you could do:
        -- local spawn_group = (account_id == imposter_account_id) and 56 or 12

        -- Create SpawnInfo and alert the client that the game is starting
        local spawn_info = SpawnInfo.new(
            spawn_group,    -- GroupID
            0.0,            -- Delay
            0.0,            -- DelayRandomness
            false,          -- SpawnOrdered
            nil             -- Remaps
        )

        FireClient(account_id, spawn_info) -- no ItemInfo needed (set to nil)
    end
end
```