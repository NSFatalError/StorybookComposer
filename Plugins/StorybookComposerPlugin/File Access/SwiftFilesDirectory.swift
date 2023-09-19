//
//  SwiftFilesDirectory.swift
//  
//
//  Created by Kamil Strzelecki on 10/09/2023.
//

import Foundation

struct SwiftFilesDirectory: CustomStringConvertible {
    let url: URL
    let files: [SwiftFile]

    var description: String {
        files.map { "- \($0)" }
            .joined(separator: "\n")
    }

    init(contentsOf url: URL) throws {
        let fileManager = FileManager.default
        var files = [SwiftFile]()

        if fileManager.directoryExists(atPath: url.path(percentEncoded: false)) {
            let resourceKeys = [.isDirectoryKey] as Set<URLResourceKey>
            let enumerator = fileManager.enumerator(at: url, includingPropertiesForKeys: Array(resourceKeys))

            guard let enumerator else {
                throw StorybookComposerPluginError.fileIsUnreachable(url)
            }

            for case let fileURL as URL in enumerator {
                guard let resourceValues = try? fileURL.resourceValues(forKeys: resourceKeys),
                      let isDirectory = resourceValues.isDirectory
                else { throw StorybookComposerPluginError.fileIsUnreachable(url) }

                if !isDirectory, let file = try SwiftFile(url: fileURL) {
                    files.append(file)
                }
            }
        } else if let file = try SwiftFile(url: url) {
            files.append(file)
        } else {
            throw StorybookComposerPluginError.fileDoesNotExist(url)
        }

        self.url = url
        self.files = files
    }
}
