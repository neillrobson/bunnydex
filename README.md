# Bunnydex

> A digital reference for the card game Killer Bunnies.

## Goals

-   Learn iOS development with Swift, SwiftUI, and SwiftData
-   Publish an offline, searchable reference of Killer Bunnies cards and rules

## Development

### Building the Database

Card data is assumed to exist in a JSON file named `db/01_deck_blue.json`.
(Eventually, we'll support one file per deck.)
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

In the `db` directory, run the following command:

```
sqlite3 default.store < create.sql
```
