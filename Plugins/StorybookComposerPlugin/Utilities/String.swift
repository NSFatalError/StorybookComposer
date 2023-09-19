//
//  String.swift
//
//
//  Created by Kamil Strzelecki on 10/09/2023.
//

import Foundation

extension String {
    func indented() -> String {
        let indentation = String(repeating: " ", count: 4)
        return indentation + split(separator: "\n").joined(separator: "\n" + indentation)
    }
}
