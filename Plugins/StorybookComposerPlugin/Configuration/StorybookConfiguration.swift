//
//  StorybookConfiguration.swift
//
//
//  Created by Kamil Strzelecki on 10/09/2023.
//

import Foundation
import XcodeProjectPlugin

struct StorybookConfiguration: Codable {
    let excludedRemotePackageDependencies: [String]
    let excludedProjectSources: [String]
    let additionalLocalSources: [String]
    let additionalImports: [String]

    static let `default` = StorybookConfiguration(
        excludedRemotePackageDependencies: [],
        excludedProjectSources: [],
        additionalLocalSources: [],
        additionalImports: []
    )

    private init(
        excludedRemotePackageDependencies: [String],
        excludedProjectSources: [String],
        additionalLocalSources: [String],
        additionalImports: [String]
    ) {
        self.excludedRemotePackageDependencies = excludedRemotePackageDependencies
        self.excludedProjectSources = excludedProjectSources
        self.additionalLocalSources = additionalLocalSources
        self.additionalImports = additionalImports
    }

    init(target: XcodeTarget) throws {
        let file = target.inputFiles.first { file in
            file.path.lastComponent == "StorybookConfiguration.json"
        }

        guard let file else {
            print("Configuration: No file named StorybookConfiguration.json found. Using default configuraiton.")
            self = .default
            return
        }

        do {
            print("Configuration: Using file at \(file.path.string).")
            let url = URL(filePath: file.path.string)
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            self = try decoder.decode(StorybookConfiguration.self, from: data)
        } catch {
            throw StorybookComposerPluginError.unableToDecodeConfiguration
        }
    }
}
