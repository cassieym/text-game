import Foundation

enum Direction: String {
    case north, south, east, west
}


protocol Describable {
    var name: String { get }
    var description: String { get }
}

struct Item: Describable {
    let name: String
    let description : String
}

struct Location: Describable {
    let name: String
    let description: String
    var item: Item?    // ? means optional, can be nil
    let exits: [Direction : String]
}


/// Declare your game's behavior and state in this struct.
///
/// This struct will be re-created when the game resets. All game state should
/// be stored in this struct.
struct YourGame: AdventureGame {
    /// Returns a title to be displayed at the top of the game.
    
    /// You can generate this dynamically based on your game's state.
    var title: String {
        return "Crossroads Game"
    }
    
    
    var locations: [String: Location] = [
        "Crossroads": Location(
            name: "Crossroads",
            description: "You stand where four dirt roads meet. Smoke rises to the north, fields stretch south, dry land lies east, and waves crash to the west.",
            item: nil,
            exits: [.north: "Factory", .south: "Farm", .east: "Wasteland", .west: "Sea"]
          ),
        "Factory": Location(
            name: "Factory",
            description: "A noisy factory full of tired workers. Tools hang on the wall.",
            item: Item(name: "shovel", description: "A worn wooden shovel."),
            exits: [.south: "Crossroads"]
           ),
        "Farm": Location(
            name: "Farm",
            description: "Green fields and a small farmhouse. A farmer waves at you.",
            item: Item(name: "shovel", description: "A worn wooden shovel."),
            exits: [.north: "Crossroads"]
           ),
        "Wasteland": Location(
            name: "Wasteland",
            description: "Empty, dusty land. A few homeless travelers huddle by a fire. A path leads south.",
            item: nil,
            exits: [.west: "Crossroads", .south: "Goldfields"]
        ),
        "Goldfields": Location(
            name: "Goldfields",
            description: "Yellow hills glitter in the sun. Something might be buried here.",
            item: nil,
            exits: [.north: "Wasteland"]
        ),
        "Sea": Location(
            name: "Sea",
            description: "Cold waves pull you under.",
            item: nil,
            exits: [:]
        )
    ]
    var currentLocation: String = "Crossroads"
    var inventory: [Item] = []
    
    /// Runs at the start of every game.
    ///
    /// Use this function to introduce the game to the player.
    ///
    /// - Parameter context: The object you use to write output and end the game.
    mutating func start(context: AdventureGameContext) {
        context.write("Welcome to Crossroads Game!")
        if let here = locations[currentLocation] {
            context.write(here.description)
        }
        
    }
    
    /// Runs when the user enters a line of input.
    ///
    /// Generally, you parse the user's command, update game state as necessary, then
    /// write output.
    ///
    /// To display a line to the user, use the `context.write(_)` function and pass in
    /// a ``String``, like this:
    ///
    /// ```swift
    /// context.write("You have been eaten by a grue.")
    /// ```
    ///
    /// If you'd like to end the game (say, if the player dies), call context.endGame().
    /// Note that this does *not* display a game over message - it merely disables
    /// the buttons and forces the user to reset.
    ///
    /// - Parameters:
    ///   - input: The line the user typed.
    ///   - context: The object you use to write output and end the game.
    mutating func handle(input: String, context: AdventureGameContext) {
        let arguments = input.split(separator: " ")
        if arguments.isEmpty {
            context.write("Please enter a command.")
            return
        }
        switch String(arguments[0]) {
            case "help":
                helpCommand(context: context)
            
            case "north", "south", "east", "west":
                let direction = Direction(rawValue: String(arguments[0]))!
                
                if let here = locations[currentLocation],
                   let nextName = here.exits[direction] {
                    currentLocation = nextName
                    context.write("You moved \(direction.rawValue)...")
                    if let newRoom = locations[currentLocation] {
                        context.write(newRoom.description)
                        
                        if newRoom.name == "Sea" {
                            context.write("You don't have a boat and can't swim...")
                            context.write("Drowning...")
                            context.write("🥀 Game Over 🥀")
                            context.endGame()
                        }
                    }
                    
    
                } else {
                    context.write("You can't go that way.")
                }
            
            case "look":
                // describe location
                if let here = locations[currentLocation] {
                    describe(here, context: context)
                    
                    // describe item
                    if let item = here.item {
                        context.write("Oh, look there's an item.")
                        describe(item, context: context)
                    }
                }
            
            case "dig":
                if currentLocation == "Goldfields" {
                    if inventory.contains(where: { $0.name == "shovel" }) {
                        context.write("Digging...")
                        context.write("Your shovel hit something hard.")
                        context.write("You found gold!")
                        context.write("✨ Congrats! You've won! ✨")
                        context.endGame()
                    } else {
                        context.write("You start digging with your bare hands")
                        context.write("The ground is too hard to dig through...")
                        context.write("Try acquiring some tools to help you out.")
                    }
                } else {
                    context.write("Digging...")
                    context.write("There's nothing here.")
                    context.write("Try somewhere else.")
                }
            
            case "pickup":
                if let item = locations[currentLocation]?.item {
                    inventory.append(item)
                    locations[currentLocation]?.item = nil
                    context.write("You picked up the \(item.name). It is now in your inventory.")
                } else {
                    context.write("There is no item to pick up.")
                }
            
            case "inventory":
                if inventory.isEmpty {
                    context.write("Your inventory is empty. Womp womp.")
                } else {
                    context.write(inventory.map(\.name).joined(separator: ", "))
                }

            default:
                context.write("Invalid command.")
        }
        
    }
    
    func helpCommand(context: AdventureGameContext) {
        context.write("Available commands:")
        context.write("- help: show this list of available commands")
        context.write("- north, south, east, west: Move between locations")
        context.write("- inventory: list the tools in your inventory")
        context.write("- look: describe your current location and any item in it")
        context.write("- dig: dig at your current location")
        context.write("- pickup: pickup current location's tool")

        
    }
    
    // Purpose: it shows the name and description of a room or an item on screen.
    // Outputs: two lines, the name and then the description.
    func describe(_ thing: Describable, context: AdventureGameContext) {
        context.write(thing.description)
    }
}

// Leave this line in - this line sets up the UI you see on the right.
// Update this if you rename your AdventureGame implementation.
YourGame.run()
