# Bunnydex

> A digital reference for the card game Killer Bunnies.

## Goals

-   Learn iOS development with Swift, SwiftUI, and SwiftData
-   Publish an offline, searchable reference of Killer Bunnies cards and rules

## Development

### Seeding the Database

Card data is assumed to exist in JSON files withing the `Bunnydex/data` directory.
The JSON is expected to look like the following:

```
[
    {
        "type": "RUN",
        "deck": "BLUE",
        "id": "0001",
        "bunnyRequirement": "NO",
        "rules": [
            {
                "title": "Card Text",
                "text": "Players that have three bunnies in The Bunny Circle of the same color or kind may play two cards per turn."
            }
        ],
        "title": "Blue Congenial Bunny"
    }
]
```

Currently, the decks found in the [Bunnypedia repository](https://github.com/joshfriend/bunnypedia/blob/81e13219ebf8a38d85ce688c9f88acd4cf7c1cd6/database/deck01_blue.json)
are used for reference.
They are not committed into this repository for the time being.

Right now, a persistent SwiftData database is checked on app startup.
If it is empty, it is seeded with the contents of the JSON files.
A more robust solution certainly exists, but for now, this setup will suffice for a proof-of-concept.
