# Crossroads Game

## Explanations

**What locations/rooms does your game have?**

1. Crossroads (starting location)
2. Factory
3. Farm
4. Wasteland
5. Goldfields
6. Sea

**What items does your game have?**

1. Shovel (one in the Factory and one on the Farm). You need it to dig for gold in the Goldfields.

**Explain how your code is designed. In particular, describe how you used structs or enums, as well as protocols.**

The `Direction` enum represents the four directions. Its `String` raw values let the player's typed command be converted directly into a direction. The `Item` struct stores an item's name, description, and whether it can dig. The `Location` struct stores a room's name, description, an optional item, and a dictionary of exits that maps each `Direction` to the name of the neighboring location.

The game struct stores all state: a dictionary of every location keyed by name, the player's current location, and an inventory array. Both `Item` and `Location` conform to the `Describable` protocol, which requires a `name` and a `description`. The `describe(_:context:)` function takes any `Describable`, and the `look` command uses it to show both the current room and any item in it.

**How do you use optionals in your program?**

- Each `Location` has an `item: Item?`. It is `nil` when a room has no item, and it becomes `nil` after the player picks the item up.
- Looking up `exits[direction]` returns `nil` when there is no exit in that direction, which shows "You can't go that way."
- Looking up `locations[currentLocation]` returns an optional, which is unwrapped with `if let`.

**Did you implement any extra features you're proud of and want to show off?**

## Endings

### Ending 1 (Lose: drown in the sea)

```
west
```

### Ending 2 (Win: dig up gold)

```
north
pickup
south
east
south
dig
```
