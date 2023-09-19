//
//  FileManager.swift
//
//
//  Created by Kamil Strzelecki on 10/09/2023.
//

import Foundation

extension FileManager {
    func directoryExists(atPath path: String) -> Bool {
        var isDirectory: ObjCBool = false
        return fileExists(atPath: path, isDirectory: &isDirectory) && isDirectory.boolValue
    }
}
