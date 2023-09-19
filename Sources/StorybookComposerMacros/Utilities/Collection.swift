//
//  Collection.swift
//
//
//  Created by Kamil Strzelecki on 17/09/2023.
//

import Foundation

extension Collection {
    public func slice(
        whereSeparator isSeparator: (Element) throws -> Bool
    ) rethrows -> [SubSequence] {
        var slices = [SubSequence]()
        var currentIndex = index(after: startIndex)

        func addSlice() {
            let startIndex = slices.last?.endIndex ?? startIndex
            let endIndex = currentIndex
            slices.append(self[startIndex..<endIndex])
        }

        while currentIndex < endIndex {
            let element = self[currentIndex]
            if try isSeparator(element) { addSlice() }
            currentIndex = index(after: currentIndex)
        }

        addSlice()
        return slices
    }
}
