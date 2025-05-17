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

To communicate from the client to the server, you use the `FireServer` function on the client side, and then listen for those events on the server side using the same event name.


### `FireServer`
Send a custom event to the server. This only works on the client-side.

#### Parameters

- **`EventName`** (`string`)
The name of the event that the server will listen for
- **`Data`** (`any`)
The data sent to the server. **The server will automatically have the Account ID of the user who sends the event.**

Example code:
```lua
-- Client-side code

FireServer("MyCustomEvent", 12) -- 12 is just for demonstration
```

Then, on the server you can use the same event name to detect this.

Example code:
```lua
-- Server-side code

local function my_function(account_id, data)
    print("Recieved data " .. data) -- prints "12"
end

server_callback("MyCustomEvent", my_function)
-- Notice how the first argument uses the same event name as the client-side code
```

## Server To Client Communication

There are 2 ways to communicate with client(s) from the server, being `FireClient` and `FireAllClients`

### `FireClient`
Send a custom event to the client. This only works server-side.

#### Parameters

- **`AccountID`** (`number`)
The Account ID of the user to send the data to.
- **`EventName`** (`string`)
The name of the event that the client will listen for
- **`Data`** (`any`)
The data sent to the client.

This is code that would generate a random number and comunicate it to a random player. The player would then print it out on their client.
```lua
-- Server-side code

local function send_rng()
    -- Get the account ID of a random player in the lobby
    local random_account_id = GAME.Players[math.random(#GAME.Players).AccountID

    -- Generate a random number between 1 - 10
    number = math.random(10)

    -- Communicate it to the chosen player.
    FireClient(random_account_id, "RNG", number)
end
```

To detect it on the client side, you must use the **`client_callback`** function insted of `server_callback`. Here is code that would detect the number from the server's `send_rng` function.
```lua
-- Client-side code

local function recieve_rng(number)
    print("Recieved value " .. number .. " from server.")
end

client_callback("RNG", recieve_rng)
```

If you would like to send some data to all clients, you can use the `FireAllClients` function.


### `FireAllClients`
Send a custom event to every connected client. This only works server-side.

#### Parameters

- **`EventName`** (`string`)
The name of the event that the client will listen for
- **`Data`** (`any`)
The data sent to the client.

The following is code that would tell all players that a game is starting.

```lua
-- Server-side code

local function start_game()
    FireAllClients("StartGame") -- no second parameter needed
end
```

The clientside code to detect this would look like this:

```lua
-- Client-side code

local function clientside_start_game()
    -- do things to start the game here..
    return
end

client_callback("StartGame", clientside_start_game)
```