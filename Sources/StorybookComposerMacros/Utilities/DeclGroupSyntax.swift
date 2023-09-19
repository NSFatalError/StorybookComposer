//
//  DeclGroupSyntax.swift
//
//
//  Created by Kamil Strzelecki on 19/09/2023.
//

import SwiftSyntax

extension DeclGroupSyntax {
    var typeName: String? {
        self.as(StructDeclSyntax.self)?.name.trimmedDescription
        ?? self.as(EnumDeclSyntax.self)?.name.trimmedDescription
        ?? self.as(ClassDeclSyntax.self)?.name.trimmedDescription
        ?? self.as(ExtensionDeclSyntax.self)?.extendedType.trimmedDescription
    }
}
