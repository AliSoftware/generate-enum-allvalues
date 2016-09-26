// Some demo code that will be analyzed by SourceKitten + the genum Swift script

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
