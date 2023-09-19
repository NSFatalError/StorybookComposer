//
//  StorybookComposerGenerator.swift
//
//
//  Created by Kamil Strzelecki on 08/09/2023.
//

import ArgumentParser
import Foundation

@main
struct StorybookComposerGenerator: ParsableCommand {

    @Option
    var inputSourcesListPath: String

    @Option
    var outputSourceFilePath: String

    @Option
    var additionalImports: [String]

    func run() throws {
        let inputSourcesData = try Data(contentsOf: URL(filePath: inputSourcesListPath))
        let inputSourceFiles = try JSONDecoder().decode([InputSourceFile].self, from: inputSourcesData)
        let context = CodeGenerationContext(additionalImports: additionalImports)

        for file in inputSourceFiles {
            try file.parse(codeGenerationContext: context)
        }

        let outputSourceFile = OutputSourceFile(path: outputSourceFilePath)
        try outputSourceFile.save(codeGenerationContext: context)
    }
}
