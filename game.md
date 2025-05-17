## API Documentation: `GAME`

All of this data is inside of the `GAME` variable. Example:
```lua
print(GAME.Players) -- Prints a list of Players connected to the lobby.
```

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

