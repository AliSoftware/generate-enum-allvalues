# generate-enum-allValues

This tiny Swift script allows to generate an implementation for `static let allValues: [Self]` on all `enum` that are marked as conforming to `CasesEnumerable`

This way if you declare:

```swift
enum Directons: CasesEnumerable { case north, south, east, west }
```

The script will be able to generate:

```swift
extension Directions {
  static let allValues: [Directions] = [.north, .south, .east, .west]
}
```

## Requirements / Installation

* Install [SourceKitten](https://github.com/jpsim/SourceKitten)
* Download the `generate-enum-allValues` Swift script
* Ensure the script has executable flag (`chmod +x generate-enum-allValues`)

## Usage

* Declare an empty protocol `protocol CasesEnumerable {}` in your source code somewhere
* For every `enum` for which you want an `allValues` implementation, mark them as conforming to this `CasesEnumerable` protocol
* Run `sourcekitten structure` on your source code and pipe the result to the `generate-enum-allValues` Swift script to generate the implementation

```sh
sourcekitten structure --file inputfile.swift | generate-enum-allValues
```

The Swift script will use the AST analysis from SourceKitten to find all the `enum` in your code that conform to `CasesEnumerable`, go over all the `case` declarations they contain, and generate the appropriate implementation for the `static let allValues` property in an `extension`.

## Example

Imagine you have the following `model.swift` source code:

```swift
// Some demo code that will be analyzed by SourceKitten + the genum Swift script

protocol CasesEnumerable {}

enum Boolish: Int, CasesEnumerable {
  case Yeah = 1
  case Nah = 0
  case Meh = 2
}

struct Deep {
  enum Nested {
    enum Key: CasesEnumerable {
      case `public`
      case `private`
    }
  }
}

//: FooClass
class Foo {

  enum Direction: CasesEnumerable {
    case north, south
    case east
    case west
  }

  enum Silent {
    case does, not, conform, to, magic, proto
    case so, wont, be, extended
  }

  enum CardSymbol: Character, CasesEnumerable {
    case hearts = "\u{2661}"
    case spades = "\u{2664}"
    case clubs = "\u{2667}"
    case diamonds = "\u{2662}"
  }

  func bar(value: String) -> Int {
    return 42
  }
}

```

Then running the command:

```sh
sourcekitten structure --file model.swift | generate-enum-allValues >allValues.generated.swift
```

Will generate the following `allValues.generate.swift` output content:

```swift
extension Boolish {
  static let allValues: [Boolish] = [.Yeah, .Nah, .Meh]
}
extension Deep.Nested.Key {
  static let allValues: [Deep.Nested.Key] = [.public, .private]
}
extension Foo.Direction {
  static let allValues: [Foo.Direction] = [.north, .south, .east, .west]
}
extension Foo.CardSymbol {
  static let allValues: [Foo.CardSymbol] = [.hearts, .spades, .clubs, .diamonds]
}
```

And thus you could then do some stuff like this elsewhere in your code:

```swift
print("- Boolish         :", Boolish.allValues.map { $0.rawValue })
print("- Deep.Nested.Key :", Deep.Nested.Key.allValues)
print("- Foo.Direction   :", Foo.Direction.allValues)
print("- Foo.CardSymbol  :", Foo.CardSymbol.allValues.map { $0.rawValue })
```

So that when you run your code, it will print:

```
- Boolish         : [1, 0, 2]
- Deep.Nested.Key : [main.Deep.Nested.Key.public, main.Deep.Nested.Key.private]
- Foo.Direction   : [main.Foo.Direction.north, main.Foo.Direction.south, main.Foo.Direction.east, main.Foo.Direction.west]
- Foo.CardSymbol  : ["♡", "♤", "♧", "♢"]
```

> You can find this example in the `./example` directory of that repo, and you can try it out using the `run_demo.sh` shell script (which invokes SourceKitten + the `generate-enum-allValues` Script, then `cat` everything in a single `swift` file to interpret and run it and print the values).


---

## Future Improvements ideas

1. I hoped at first that this script would be able to use `SourceKittenFramework` (which happen to be included in SwiftLint so you probably already have it on your machine already) to parse the AST instead of requiring the user to invoke `sourcekitten structure` on the command line themselves.
Unfortunately, I haven't succeeded in importing the Framework from the script as easily as I thought just yet.

2. For this first version, I've decided to make this `allValues` generation opt-in, by only generating the extension for enums that are explicitly marked as `CasesEnumerable` directly. This is a deliberate choice, to avoid the risk of generating too much useless code if you were to generate `allValues` for all your enums even for those for which you don't need it

  * I don't analyze the whole inheritance tree of the `enum`, just the list of its direct conformances, so `protocol Foo: CasesEnumerable` + `enum Bar: Foo` won't be matched
  * The script could easily changed if you don't want this filtering and instead generate the `allValues` for _all_ the `enums` in your code. That's just a design choice.
  * So in a future version maybe a command line flag or something could be added to allow the user to specify if they want to filter `enum` by a given protocol and even provide the protocol name themselves

3. Every other interesting idea is welcome, don't hesitate to contribute. The script is quite small and all written in Swift, so it should be fairly easy to understand and contribute 😉
