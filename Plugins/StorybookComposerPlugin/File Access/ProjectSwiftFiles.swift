//
//  ProjectSwiftFiles.swift
//
//
//  Created by Kamil Strzelecki on 10/09/2023.
//

import Foundation
import XcodeProjectPlugin

struct ProjectSwiftFiles: CustomStringConvertible {
    let files: [SwiftFile]

    var description: String {
        "Project Swift Files:\n"
        + files.map { "- \($0)" }
            .joined(separator: "\n")
            .indented()
    }

    init(
        context: XcodePluginContext,
        configuration: StorybookConfiguration
    ) throws {
        let projectURL = URL(
            filePath: context.xcodeProject.directory.string,
            directoryHint: .isDirectory
        )

        let excludedProjectPaths = configuration.excludedProjectSources.map { path in
            URL(filePath: path, directoryHint: .checkFileSystem, relativeTo: projectURL).absoluteString
        }

        self.files = try context
            .xcodeProject
            .filePaths
            .compactMap { path in
                let url = URL(filePath: path.string, directoryHint: .notDirectory)
                return try SwiftFile(url: url)
            }
            .filter { file in
                !excludedProjectPaths.contains { excludedPath in
                    file.url.absoluteString.hasPrefix(excludedPath)
                }
            }
    }
}
