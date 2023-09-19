//
//  AccessPath.swift
//
//
//  Created by Kamil Strzelecki on 19/09/2023.
//

import Foundation
import SwiftSyntax

struct AccessPath: Hashable, CustomStringConvertible {
    private(set) var description = ""

    var isEmpty: Bool {
        description.isEmpty
    }

    private mutating func addTrailingPeriodIfNeeded() {
        guard !description.isEmpty else { return }
        description.append(".")
    }

    private mutating func removeTrailingPeriodIfNeeded() {
        guard description.last == "." else { return }
        description.removeLast()
    }

    mutating func push(_ string: String) {
        addTrailingPeriodIfNeeded()
        description.append(string)
    }

    mutating func push(_ decl: NamedDeclSyntax) {
        push(decl.name.trimmedDescription)
    }

    mutating func push(_ decl: ExtensionDeclSyntax) {
        push(decl.extendedType.trimmedDescription)
    }

    mutating func pop(_ string: String) {
        guard description.hasSuffix(string) else { return }
        description.removeLast(string.count)
        removeTrailingPeriodIfNeeded()
    }

    mutating func pop(_ decl: NamedDeclSyntax) {
        pop(decl.name.trimmedDescription)
    }

    mutating func pop(_ decl: ExtensionDeclSyntax) {
        pop(decl.extendedType.trimmedDescription)
    }
}
