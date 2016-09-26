# generate-enum-values

This tiny Swift script allows to generate an implementation for `static let allValues: [Self]` on all `enum` that are marked as conforming to `CasesEnumerable`

## Requirements

* Install [SourceKitten](https://github.com/jpsim/SourceKitten)
* Download the `generate-enum-allValues` Swift script
* Ensure the script has executable flag (`chmod +x generate-enum-allValues`)

## Usage

* Declare an empty protocol `protocol CasesEnumerable {}` in your source code somewhere
* For every `enum` for which you want an `allValues` implementation, mark them as conforming to this `CasesEnumerable` protocol
* Run `sourcekitten structure` on your source code and pipe the result to the `generate-enum-allValues` Swift script to generate the implementation

The Swift script will use the AST analysis from SourceKitten to find all the `enum` in your code that conform to `CasesEnumerable`, go over all the `case` declarations they contain, and generate the appropriate implementation for the `static let allValues` property in an `extension`.

## Example

Imagine you have the following source code:

```swift
protocol CasesEnumerable {}

enum Boolish: Int, CasesEnumerable {
  case Yeah = 1
  case Nah = 0
  case Meh = 2
}

struct Deep {
  enum Nested {
    enum Keys: CasesEnumerable {
      case `public`
      case `private`
    }
  }
}

//: FooClass
class Foo {

  enum Directions: CasesEnumerable {
    case north, south
    case east
    case west
  }

  enum Silent {
    case does, not, conform, to, magic, proto
    case so, wont, be, extended
  }

  func bar(value: String) -> Int {
    return 42
  }
}
```

Then running the command:

```sh
sourcekitten structure --file model.swift | path/to/generate-enum-allValues >allValues.generated.swift
```

Will generate the following `allValues.generate.swift` content:

```
extension Boolish {
  static let allValues: [Boolish] = [.Yeah, .Nah, .Meh]
}
extension Deep.Nested.Keys {
  static let allValues: [Deep.Nested.Keys] = [.public, .private]
}
extension Foo.Directions {
  static let allValues: [Foo.Directions] = [.north, .south, .east, .west]
}
```

And thus you could then do some stuff like:

```swift
print("Boolish values: \(Boolish.allValues.map { $0.rawValue })")
print("Deep.Nested.Keys values: \(Deep.Nested.Keys.allValues)")
print("Foo.Directions = \(Foo.Directions.allValues)")
```
