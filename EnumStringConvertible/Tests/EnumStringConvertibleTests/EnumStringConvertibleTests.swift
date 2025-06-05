import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(EnumStringConvertibleMacros)
import EnumStringConvertibleMacros

let testMacros: [String: Macro.Type] = [
    "enumStringConvertible": EnumStringConvertibleMacro.self,
]
#endif

final class EnumStringConvertibleTests: XCTestCase {
    func testMacro() throws {
        #if canImport(EnumStringConvertibleMacros)
        assertMacroExpansion(
            """
            @enumStringConvertible
            enum Deck {
                case blue, yellow, twilightWhite, kinderSkyBlue, fourWordsOfWisdom
            }
            """,
            expandedSource: """
            enum Deck {
                case blue, yellow, twilightWhite, kinderSkyBlue, fourWordsOfWisdom
            
                init?(_ description: String) {
                    switch description {
                    case "BLUE":
                        self = .blue
                    case "YELLOW":
                        self = .yellow
                    case "TWILIGHT_WHITE":
                        self = .twilightWhite
                    case "KINDER_SKY_BLUE":
                        self = .kinderSkyBlue
                    case "FOUR_WORDS_OF_WISDOM":
                        self = .fourWordsOfWisdom
                    default:
                        return nil
                    }
                }

                var description: String {
                    switch self {
                    case .blue:
                        return "BLUE"
                    case .yellow:
                        return "YELLOW"
                    case .twilightWhite:
                        return "TWILIGHT_WHITE"
                    case .kinderSkyBlue:
                        return "KINDER_SKY_BLUE"
                    case .fourWordsOfWisdom:
                        return "FOUR_WORDS_OF_WISDOM"
                    }
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
