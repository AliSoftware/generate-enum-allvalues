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
