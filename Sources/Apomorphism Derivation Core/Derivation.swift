import Corecursive_Derivation_Core
public import SwiftSyntax
import SwiftSyntaxBuilder

public enum Derivation {
    public static func expansion(of declaration: EnumDeclSyntax) -> [DeclSyntax] {
        Corecursive_Derivation_Core.Derivation.expansion(of: declaration)
            + operation(of: declaration)
    }

    public static func operation(of declaration: EnumDeclSyntax) -> [DeclSyntax] {
        let access = declaration.modifiers.contains { $0.name.tokenKind == .keyword(.public) }
            ? "public " : ""
        return ["""
            \(raw: access)static func apomorphism<Seed>(
                _ seed: Seed,
                _ coalgebra: (Seed) -> Base<Either<Self, Seed>>
            ) -> Self {
                embed(coalgebra(seed).map { branch in
                    switch branch {
                    case let .left(recursive): return recursive
                    case let .right(seed): return apomorphism(seed, coalgebra)
                    }
                })
            }
            """]
    }
}
