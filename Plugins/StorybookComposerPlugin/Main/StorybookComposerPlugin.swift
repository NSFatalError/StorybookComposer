//
//  StorybookComposerPlugin.swift
//
//
//  Created by Kamil Strzelecki on 08/09/2023.
//

import Foundation
import PackagePlugin
import XcodeProjectPlugin

@main
struct StorybookComposerPlugin: BuildToolPlugin {
    func createBuildCommands(
        context: PluginContext,
        target: Target
    ) throws -> [Command] {
        throw StorybookComposerPluginError.buildToolRunOusideOfXcodeProject
    }
}

extension StorybookComposerPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(
        context: XcodePluginContext,
        target: XcodeTarget
    ) throws -> [Command] {
        let configuration = try StorybookConfiguration(target: target)
        dump(configuration)
        print()

        let remotePackageDependencies = try RemotePackageDependencies(context: context, configuration: configuration)
        print(remotePackageDependencies, "\n")

        let additionalSwiftFiles = try AdditionalSwiftFiles(context: context, configuration: configuration)
        print(additionalSwiftFiles, "\n")

        let projectSwiftFiles = try ProjectSwiftFiles(context: context, configuration: configuration)
        print(projectSwiftFiles, "\n")

        let tool = try context.tool(named: "StorybookComposerGenerator")
        let outputDirectory = context.pluginWorkDirectory.appending("Output")
        let outputSourceFilePath = outputDirectory.appending("Generated.swift")
        let inputSourcesListPath = context.pluginWorkDirectory.appending("Input.json")

        try FileManager.default.createDirectory(
            atPath: outputDirectory.string,
            withIntermediateDirectories: true
        )

        try saveInputSourcesList(
            atPath: inputSourcesListPath,
            remotePackageDependencies: remotePackageDependencies,
            additionalSwiftFiles: additionalSwiftFiles,
            projectSwiftFiles: projectSwiftFiles
        )

        return [
            .prebuildCommand(
                displayName: "Generate Storybook Sources",
                executable: tool.path,
                arguments: [
                    "--input-sources-list-path", inputSourcesListPath.string,
                    "--output-source-file-path", outputSourceFilePath.string,
                    "--additional-imports", configuration.additionalImports.joined(separator: " ")
                ],
                outputFilesDirectory: outputDirectory
            )
        ]
    }

    private func saveInputSourcesList(
        atPath path: Path,
        remotePackageDependencies: RemotePackageDependencies,
        additionalSwiftFiles: AdditionalSwiftFiles,
        projectSwiftFiles: ProjectSwiftFiles
    ) throws {
        let inputSources = remotePackageDependencies.checkouts.flatMap { $0.directory.files }
        + additionalSwiftFiles.directories.flatMap { $0.files }
        + projectSwiftFiles.files

        let inputSourcesList = inputSources.map { file in
            file.url.path(percentEncoded: false)
        }

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        let inputSourcesListURL = URL(filePath: path.string)
        let data = try encoder.encode(inputSourcesList)
        try data.write(to: inputSourcesListURL)
    }
}

enum StorybookComposerPluginError: Error {
    case buildToolRunOusideOfXcodeProject

    case unableToDecodeConfiguration
    case unableToFindSourcePackagesDirectory

    case fileDoesNotExist(URL)
    case fileIsUnreachable(URL)
}
