## Getting Started
You are provided with data about the lobby in the 'GAME' variable.
For example, if you wanted to see how many players are in the lobby you could do this like so:
```lua
-- Assuming 2 players are in the lobby with the following account ID's

print(GAME.Players) -- output: [827562, 1582]
print(#GAME.Players) -- output: 2
-- The # gets the length of a list
```

If you would like to see everything in the 'GAME' variable, go [here](https://github.com/stellarxoxo/globed-docs/blob/main/game.md). Otherwise, here is a list of common parameters.

## Common Parameters

### `LastJoin`
Account ID of the user that last joined the level

### `LastLeave`
Account ID of the user that last left the level

### `Players`
A list of Account ID's in the level. The length of this list is how many players are in the level.

### `PlayerJoinCount`
Total amount of player joins

### `PlayerLeaveCount`
Total amount of player leaves

### `UnixTime`
Current unix timestamp in seconds

#### See the rest of the list [here](https://github.com/stellarxoxo/globed-docs/blob/main/game.md)

## Events

There are 2 parts to every event, the client side and the server side. This section will be how the server handles events. To use an event, use the `server_callback` function. The first argument to this function is the name of the event. The second argument is a pointer to the function you want to be connected to it.
For example, if you wanted to run some code when a player joins the lobby you could do this:

```lua
local function my_on_player_join(account_id, account_username)
    print(account_id)
end

server_callback("PlayerJoin", my_on_player_join)
```

Alternatively, you could skip the process of creating a function and instead do it in one line like so:

```lua
server_callback("PlayerJoin", function(account_id)
    print(account_id)
end) -- Both of these do the exact same thing
```

A very important event that you will almost certainly need is the `Heartbeat` function. This is ran every server "tick" (currently 30 times a second)
Example:

```lua
local beats = 0
local elapsedTime = 0
server_callback("Heartbeat", function(dt) -- dt is delta time
    beats = beats + 1
    elapsedTime = elapsedTime + dt

    print("Beats: " .. beats)
    print("Elapsed Time: " .. elapsedTime)
end)
```

If you would like to see a full list of events provided to you by Globed, go [here](https://github.com/stellarxoxo/globed-docs/blob/main/events.md). This link also has the documentation on client-server communication.
