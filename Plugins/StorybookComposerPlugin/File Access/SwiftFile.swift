//
//  SwiftFile.swift
//  
//
//  Created by Kamil Strzelecki on 10/09/2023.
//

import Foundation

struct SwiftFile: CustomStringConvertible {
    let url: URL

    var description: String {
        url.description
    }

    init?(url: URL) throws {
        guard FileManager.default.fileExists(atPath: url.path(percentEncoded: false))
        else { throw StorybookComposerPluginError.fileDoesNotExist(url) }

        if url.pathExtension == "swift" {
            self.url = url
        } else {
            return nil
        }
    }
}
