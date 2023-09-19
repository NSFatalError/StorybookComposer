//
//  StorybookComponentProviderFinder.swift
//
//
//  Created by Kamil Strzelecki on 19/09/2023.
//

import Foundation
import SwiftSyntax

final class StorybookComponentProviderFinder: SyntaxVisitor {
    private let variableName = "_storybookComponentProvider"
    private var currentAccessPath = AccessPath()
    private(set) var visitedAccessPaths = [AccessPath]()

    func shouldWalk(_ source: some SyntaxProtocol) -> Bool {
        source.description.contains(variableName)
    }

    override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        let identifier = node.bindings.first?
            .pattern.as(IdentifierPatternSyntax.self)?
            .identifier

        if identifier?.tokenKind == .identifier(variableName) {
            currentAccessPath.push(variableName)
            visitedAccessPaths.append(currentAccessPath)
            currentAccessPath.pop(variableName)
        }

        return .visitChildren
    }

    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        currentAccessPath.push(node)
        return .visitChildren
    }

    override func visitPost(_ node: StructDeclSyntax) {
        currentAccessPath.pop(node)
    }

    override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        currentAccessPath.push(node)
        return .visitChildren
    }

    override func visitPost(_ node: EnumDeclSyntax) {
        currentAccessPath.pop(node)
    }

    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        currentAccessPath.push(node)
        return .visitChildren
    }

    override func visitPost(_ node: ClassDeclSyntax) {
        currentAccessPath.pop(node)
    }

    override func visit(_ node: ExtensionDeclSyntax) -> SyntaxVisitorContinueKind {
        currentAccessPath.push(node)
        return .visitChildren
    }

    override func visitPost(_ node: ExtensionDeclSyntax) {
        currentAccessPath.pop(node)
    }
}
