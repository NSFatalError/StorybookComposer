//
//  StorybookComposerMacrosPlugin.swift
//
//
//  Created by Kamil Strzelecki on 08/09/2023.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import StorybookComposerMacros

@main
struct StorybookComposerMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        StorybookComponentMacro.self
    ]
}

struct StorybookComponentMacro: MemberMacro {
    static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        try StorybookComposerMacros
            .StorybookComponentMacro
            .expansion(of: node, providingMembersOf: declaration, in: context)
    }
}
