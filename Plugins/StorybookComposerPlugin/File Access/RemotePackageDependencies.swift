//
//  RemotePackageDependencies.swift
//
//
//  Created by Kamil Strzelecki on 10/09/2023.
//

import Foundation
import XcodeProjectPlugin

struct RemotePackageDependencies: CustomStringConvertible {
    let checkouts: [RemotePackageCheckout]

    var description: String {
        "Remote Package Dependencies (\(checkouts.count) checkout(s) included):\n"
        + checkouts
            .map { $0.description.indented() }
            .joined(separator: "\n")
    }

    init(
        context: XcodePluginContext,
        configuration: StorybookConfiguration
    ) throws {
        let fileManager = FileManager.default
        let pluginPath = context.pluginWorkDirectory.string
        print("Remote Package Dependencies: Attempting to locate SourcePackages directory in plugin work directory at \(pluginPath).")

        let pluginURLComponents = URL(filePath: pluginPath, directoryHint: .isDirectory)
            .pathComponents

        guard let sourcePackagesComponentIndex = pluginURLComponents.lastIndex(of: "SourcePackages")
        else { throw StorybookComposerPluginError.unableToFindSourcePackagesDirectory }

        let checkoutsPath = "/"
        + pluginURLComponents[1...sourcePackagesComponentIndex].joined(separator: "/")
        + "/checkouts/"

        guard fileManager.fileExists(atPath: checkoutsPath) else {
            print("Remote Package Dependencies: No checkouts found in \(checkoutsPath).")
            self.checkouts = []
            return
        }

        print("Remote Package Dependencies: Using checkouts in \(checkoutsPath).")
        let checkoutsURL = URL(filePath: checkoutsPath, directoryHint: .isDirectory)

        guard let packages = try? fileManager.contentsOfDirectory(atPath: checkoutsPath)
        else { throw StorybookComposerPluginError.fileIsUnreachable(checkoutsURL) }

        self.checkouts = try packages
            .filter { package in
                !configuration.excludedRemotePackageDependencies.contains(package)
            }
            .map { package in
                try RemotePackageCheckout(name: package, checkoutsURL: checkoutsURL)
            }
    }
}

struct RemotePackageCheckout: CustomStringConvertible {
    let name: String
    let directory: SwiftFilesDirectory

    var description: String {
        "\"\(name)\" Package Checkout:\n"
        + directory.description.indented()
    }

    init(
        name: String,
        checkoutsURL: URL
    ) throws {
        let url = URL(filePath: name, directoryHint: .isDirectory, relativeTo: checkoutsURL)
        self.directory = try SwiftFilesDirectory(contentsOf: url.absoluteURL)
        self.name = name
    }
}
