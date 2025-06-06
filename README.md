# Bunnydex

> A digital reference for the card game Killer Bunnies.

## Goals

-   Learn iOS development with Swift, SwiftUI, and SwiftData
-   Publish an offline, searchable reference of Killer Bunnies cards and rules

## Development

The iOS application itself is in the aptly-named `App` directory.
Open `App/Bunnydex.xcodeproj` in Xcode to develop.

A Swift macro, used for building the enumerations in the Card model,
is packaged in the `EnumStringConvertible` directory.
The Xcode project should automatically detect and import that dependency.

> [!NOTE]
> This project organization strategy isn't particularly robust.
> It is merely the result of my learning and hacking together a bare-bones iOS application.
>
> In the future, I may adjust and modularize the structure further.

### Data

At the moment, all text and images are simply stored as JSON and `.xcasset` files
within the `App/Bunnydex` directory.
Although inefficient from a source-control perspective,
the size of the data did not warrant a more robust system (at least for an initial prototype).

## Attributions

> [!IMPORTANT]
> Only the `.swift` source code files in this repository are my (Neill Robson's) intellectual property.
> All assets and inspiration are borrowed with much gratitude from the following talented people!

- Jeff Bellinger: creator of the Killer Bunnies card game
- Jonathan Young: Killer Bunnies card illustrator
- Josh Friend: creator of [Bunnypedia](https://github.com/joshfriend/bunnypedia), a Killer Bunnies card browser app for Android. The JSON card data came from his app.
- Jennifer Robson: graphic designer for the Bunnydex app logo
