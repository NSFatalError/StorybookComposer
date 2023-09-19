//
//  StorybookComponentProvider.swift
//
//
//  Created by Kamil Strzelecki on 19/09/2023.
//

import SwiftUI

public protocol StorybookComponentProviding {
    associatedtype Preview: View

    var name: String { get }
    var sourceLocation: StorybookComponentSourceLocation { get }
    var preview: () -> Preview { get }
}

public struct StorybookComponentProvider<Preview: View>: StorybookComponentProviding {
    public let name: String
    public let sourceLocation: StorybookComponentSourceLocation
    public let preview: () -> Preview

    init(
        name: String,
        sourceLocation: StorybookComponentSourceLocation,
        @ViewBuilder preview: @escaping () -> Preview
    ) {
        self.name = name
        self.sourceLocation = sourceLocation
        self.preview = preview
    }
}

public struct StorybookComponentSourceLocation: Hashable {
    public let path: String
    public let line: Int

    public init(path: String, line: Int) {
        self.path = path
        self.line = line
    }
}

extension StorybookComponentProvider
where Preview == Color {
    static var mock: Self {
        StorybookComponentProvider(
            name: "My Component",
            sourceLocation: .init(
                path: "Module/File/File/File/File/File/File/File.swift",
                line: 123
            ),
            preview: {
                Color.red
            }
        )
    }
}
