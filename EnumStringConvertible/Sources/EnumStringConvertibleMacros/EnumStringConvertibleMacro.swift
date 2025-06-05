import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension String {
    func upperCamelCase() -> String {
        self
            .replacingOccurrences(of: "(.)([A-Z][a-z]+)", with: "$1_$2", options: .regularExpression)
            .replacingOccurrences(of: "([a-z0-9])([A-Z])", with: "$1_$2", options: .regularExpression)
            .uppercased()
    }
}

/// Implementation of the `CardField` macro,
/// which implements `LosslessStringConvertible` for enums
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
public struct EnumStringConvertibleMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            // TODO: Throw an error here
            fatalError()
        }

        let members = enumDecl.memberBlock.members
        let caseDecls = members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self ) }
        let elements = caseDecls.flatMap { $0.elements }

        let initializer = try InitializerDeclSyntax("init?(_ description: String)") {
            try SwitchExprSyntax("switch description") {
                for element in elements {
                    SwitchCaseSyntax(
                        """
                        case "\(raw: element.name.text.upperCamelCase())": self = .\(element.name)
                        """
                    )
                }
                SwitchCaseSyntax("default: return nil")
            }
        }

        let description = try VariableDeclSyntax("var description: String") {
            try SwitchExprSyntax("switch self") {
                for element in elements {
                    SwitchCaseSyntax("case .\(element.name): return \"\(raw: element.name.text.upperCamelCase())\"")
                }
            }
        }

        return [DeclSyntax(initializer), DeclSyntax(description)]
    }
}

@main
struct EnumStringConvertiblePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        EnumStringConvertibleMacro.self,
    ]
}
