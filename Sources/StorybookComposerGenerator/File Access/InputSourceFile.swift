//
//  InputSourceFile.swift
//
//
//  Created by Kamil Strzelecki on 16/09/2023.
//

import Foundation
import SwiftParser
import SwiftSyntax
import SwiftSyntaxMacroExpansion
import StorybookComposerMacros

protocol InputSourceFileProvider {
    var path: String { get }
    func load() throws -> String
}

struct DiskInputSourceFileProvider: InputSourceFileProvider {
    let path: String

    func load() throws -> String {
        try String(contentsOfFile: path)
    }
}

struct InputSourceFile: Decodable {
    let provider: InputSourceFileProvider

    init(provider: InputSourceFileProvider) {
        self.provider = provider
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let path = try container.decode(String.self)
        let provider = DiskInputSourceFileProvider(path: path)
        self.init(provider: provider)
    }

    func parse(codeGenerationContext: CodeGenerationContext) throws {
        let originalSource = try SwiftParser.Parser
            .parse(source: provider.load())

        let expansionContext = BasicMacroExpansionContext(
            sourceFiles: [originalSource: .init(moduleName: "Unknown", fullFilePath: provider.path)]
        )
        let expandedSource = originalSource.expand(
            macros: ["StorybookComponent": StorybookComponentMacro.self],
            in: expansionContext
        )

        findStorybookComponentProviders(
            in: expandedSource,
            codeGenerationContext: codeGenerationContext
        )
    }

    private func findStorybookComponentProviders(
        in expandedSource: Syntax,
        codeGenerationContext: CodeGenerationContext
    ) {
        let finder = StorybookComponentProviderFinder(viewMode: .sourceAccurate)
        guard finder.shouldWalk(expandedSource) else { return }

        finder.walk(expandedSource)
        codeGenerationContext
            .storybookComponentProvidersAccessPaths
            .append(contentsOf: finder.visitedAccessPaths)
    }
}
