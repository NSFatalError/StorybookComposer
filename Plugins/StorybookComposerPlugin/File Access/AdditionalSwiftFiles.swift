//
//  AdditionalSwiftFiles.swift
//
//
//  Created by Kamil Strzelecki on 10/09/2023.
//

import Foundation
import XcodeProjectPlugin

struct AdditionalSwiftFiles: CustomStringConvertible {
    let directories: [SwiftFilesDirectory]

    var description: String {
        "Additional Swift Files (\(directories.count) location(s) specified):\n"
        + directories
            .map { $0.description.indented() }
            .joined(separator: "\n")
    }

    init(
        context: XcodePluginContext, 
        configuration: StorybookConfiguration
    ) throws {
        let projectURL = URL(
            filePath: context.xcodeProject.directory.string,
            directoryHint: .isDirectory
        )

        self.directories = try configuration
            .additionalLocalSources
            .map { path in
                let url = URL(filePath: path, directoryHint: .checkFileSystem, relativeTo: projectURL)
                return try SwiftFilesDirectory(contentsOf: url.absoluteURL)
            }
    }
}
