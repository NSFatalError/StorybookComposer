//
//  File.swift
//  
//
//  Created by Kamil Strzelecki on 19/09/2023.
//

import Foundation

extension Sequence where Element == String {
    func joined(indentationLevel: Int) -> String {
        let indentation = String(repeating: " ", count: 4)
        return joined(separator: "\n" + indentation)
    }
}
