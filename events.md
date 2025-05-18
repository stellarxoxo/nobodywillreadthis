## API Documentation: `Events`

**All client-server communication is done via Events.**

To detect an event on the server end, use the `server_callback` function. The first argument to this function is the name of the event. The second argument is a pointer to the function you want to be connected to it.

For example, if you wanted to run some code when a player joins the lobby you could do this:

```lua
local function my_on_player_join(account_id, account_username)
    print(account_id)
end

server_callback("PlayerJoin", my_on_player_join)
```

Provided to you are 3 events that can be used without any client-side code:

### `PlayerJoin`
Called when a player joins the game.

#### Parameters

- **`AccountID`** (`number`)
The unique identifier of the connecting player's account
- **`Username`** (`string`)
The username of the connecting player

Example code:
```lua
local function my_on_player_join(account_id, account_username)
    print(account_id)
end

server_callback("PlayerJoin", my_on_player_join)
```

### `PlayerLeave`
Called when a player leaves the game.

#### Parameters

- **`AccountID`** (`number`)
The unique identifier of the leaving player's account
- **`Username`** (`string`)
The username of the leaving player

Example code:
```lua
local function my_on_player_leave(account_id, account_username)
    print(account_id)
end

server_callback("PlayerLeave", my_on_player_leave)
```
### `Heartbeat`
Called every server tick. This is currently 30 times a second.

#### Parameters

- **`DeltaTime`** (`number`)
The time (in seconds) since the last heartbeat.

Example code:
```lua
local beats = 0
local elapsedTime = 0

local function my_heartbeat(dt)
    beats = beats + 1
    elapsedTime = elapsedTime + dt

    print("Beats: " .. beats)
    print("Elapsed Time: " .. elapsedTime)
end

server_callback("Heartbeat", my_heartbeat)
```

## Client To Server Communication

To communicate from the client to the server, you use the `FireServer` trigger inside of the GD editor, and then listen for those events on the server side using the same event name.

![a](/fireserver1.png)

- **ItemID:** This is the data that will be sent to the server. You can send up to two pieces of data per FireServer spawn. If you would like to send a constant you can leave the ItemID value as 0 and use the Mod1 value (much like the vanilla Item Triggers.)

- **Mod1:** This is a multiplier to the ItemID value. This works identically to the Item Edit/Item Compare trigger in vanilla GD.

- **Event Name**: This is the name of the event the server will be listening to. The event name can be used by multiple `Fire Server` triggers. Note that you cannot use the following names as your event name:
    - PlayerJoin
    - PlayerLeave
    - Heartbeat

On the server side you can use the same event name to detect this like so:

```lua
-- Server-side code

local function my_event_hook(account_id, data1, data2)
    print("Recieved data " .. data)
end

server_callback("MyEvent", my_event_hook)
-- Notice how the first argument uses the same event name as the client-side code
```

**The account ID of the client sending the FireServer request is automatically in the data that the server recieves.**

## Server To Client Communication

There are 2 ways to communicate with client(s) from the server, being `FireClient` and `FireAllClients`

### `FireClient`
This function is essentially a spawn trigger that you can force clients to spawn.

#### Parameters

- **`AccountID`** (`number`)
The Account ID of the user to send the data to.
- **`Spawn`** (`SpawnInfo`) 
[SpawnInfo]() contains all of the data that will be sent to a ghost **Spawn Trigger** that the client runs. See how to use it [here]().
- **`Item`** (`ItemInfo`) 
[ItemInfo]() contains all of the data that will be sent to a ghost **Item Edit** trigger that the client runs. See how to use it [here]().

This is code that would spawn a random group from 10 to 20
```lua
-- Server-side code

local function send_rng()
    -- Get the account ID of a random player in the lobby
    local random_account_id = GAME.Players[math.random(#GAME.Players)].AccountID

    -- Generate a random number between 11 - 20
    spawn_group = math.random(10) + 10

    -- Creaate SpawnInfo and spawn that group on the chosen player's client
    local spawn_info = SpawnInfo.new(
        spawn_group,    -- GroupID
        0.0,            -- Delay
        0.0,            -- DelayRandomness
        false,          -- SpawnOrdered
        nil             -- Remaps
    )

    FireClient(random_account_id, spawn_info)
end
```

If you would like to send some data to all clients, you can use the `FireAllClients` function.

### `FireAllClients`
This function is essentially a spawn trigger that you can force every client in the lobby to spawn.

#### Parameters

- **`Spawn`** (`SpawnInfo`) 
[SpawnInfo]() contains all of the data that will be sent to a ghost **Spawn Trigger** that the client runs. See how to use it [here]().
- **`Item`** (`ItemInfo`) 
[ItemInfo]() contains all of the data that will be sent to a ghost **Item Edit** trigger that the client runs. See how to use it [here]().

The following is code that would tell all players that a game is starting.

```lua
-- Server-side code

local function start_game()
    -- Create SpawnInfo that will be communicated to clients. Assume group 87 is the start game group in GD.
    local spawn_info = SpawnInfo.new(
        87,             -- GroupID
        0.0,            -- Delay
        0.0,            -- DelayRandomness
        false,          -- SpawnOrdered
        nil             -- Remaps
    )

    FireAllClients(spawn_info) -- No account ID's aneeded
end
```