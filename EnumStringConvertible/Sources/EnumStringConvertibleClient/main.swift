import EnumStringConvertible

@enumStringConvertible
enum Deck: Int {
    case blue, yellow, twilightWhite, black, red
}

print(Deck(rawValue: 1)?.description ?? "Not found")

print(Deck("TWILIGHT_WHITE")?.description ?? "Not found")

print(Deck.black.description)
