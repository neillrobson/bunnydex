// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro that implements `LosslessStringConvertible` for enums
/// based on the enum labels.
///
/// For example,
///
///     @enumStringConvertible
///     enum Deck {
///         case blue, yellow, twilightWhite
///     }
///
/// produces the corresponding `init` and `description` fields in that enum:
///
///     enum Deck {
///         case blue, yellow, twilightWhite
///
///         init?(_ description: String) {
///             switch description {
///             case "BLUE":
///                 self = .blue
///             case "YELLOW":
///                 self = .yellow
///             case "TWILIGHT_WHITE":
///                 self = .twilightWhite
///             default:
///                 return nil
///             }
///         }
///
///         var description: String {
///             switch self {
///             case .blue:
///                 return "BLUE"
///             case .yellow:
///                 return "YELLOW"
///             case .twilightWhite:
///                 return "TWILIGHT_WHITE"
///             }
///         }
///     }
@attached(member, names: named(init), named(description))
public macro enumStringConvertible() = #externalMacro(module: "EnumStringConvertibleMacros", type: "EnumStringConvertibleMacro")
