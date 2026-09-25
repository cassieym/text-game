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
    let canDig: Bool
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
            item: Item(name: "shovel", description: "A worn wooden shovel.", canDig: true),
            exits: [.south: "Crossroads"]
           ),
        "Farm": Location(
            name: "Farm",
            description: "Green fields and a small farmhouse. A farmer waves at you.",
            item: Item(name: "shovel", description: "A worn wooden shovel.", canDig: true),
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
        // TODO: Remove this and implement logic to start your game!
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
                    context.write("You moved \(direction.rawValue)")
                    if let newRoom = locations[currentLocation] {
                        context.write(newRoom.description)
                    }
                } else {
                    context.write("You can't go that way.")
                }
            
            default:
                context.write("Invalid command.")
        }
        
    }
    
    func helpCommand(context: AdventureGameContext) {
        context.write("Available commands:")
        context.write("- north, south, east, west: Move between locations")
        context.write("- help: Show this list of available commands")
    }
}

// Leave this line in - this line sets up the UI you see on the right.
// Update this if you rename your AdventureGame implementation.
YourGame.run()
