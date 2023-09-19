//
//  StorybookComponentMacro.swift
//
//
//  Created by Kamil Strzelecki on 19/09/2023.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct StorybookComponentMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let typeName = declaration.typeName
        else { throw StorybookComponentMacroError.unknownComponentType }

        guard let location = context.location(of: node)
        else { throw StorybookComponentMacroError.unknownSourceLocation }

        let componentName = typeName
            .split { !$0.isLetter }
            .joined(separator: " -")
            .slice { $0.isUppercase }
            .map { $0.capitalized }
            .joined(separator: " ")

        let decl: DeclSyntax = """
        public static var _storybookComponentProvider: some StorybookComposer.StorybookComponentProviding {
            StorybookComposer.StorybookComponentProvider(
                name: \(StringLiteralExprSyntax(content: componentName)),
                sourceLocation: .init(
                    path: \(location.file),
                    line: \(location.line)
                ),
                preview: Self.init
            )
        }
        """

        return [decl]
    }
}

fileprivate enum StorybookComponentMacroError: Error {
    case unknownComponentType
    case unknownSourceLocation
}
