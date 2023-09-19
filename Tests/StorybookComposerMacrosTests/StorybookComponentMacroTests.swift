//
//  StorybookComponentMacroTests.swift
//
//
//  Created by Kamil Strzelecki on 08/09/2023.
//

@testable import StorybookComposerMacros
import SwiftSyntaxMacrosTestSupport
import SwiftSyntaxMacros
import XCTest

final class StorybookComponentMacroTests: XCTestCase {
    private let macros =  [
        "StorybookComponent": StorybookComponentMacro.self
    ]

    func testExpansion_whenAttachedToStructDecl() {
        let original = """
        @StorybookComponent
        struct MyButton: View {
            var body: some View {
                Color.red
            }
        }
        """

        let expanded = """
        struct MyButton: View {
            var body: some View {
                Color.red
            }

            public static var _storybookComponentProvider: some StorybookComposer.StorybookComponentProviding {
                StorybookComposer.StorybookComponentProvider(
                    name: "My Button",
                    sourceLocation: .init(
                        path: "TestModule/test.swift",
                        line: 1
                    ),
                    preview: Self.init
                )
            }
        }
        """

        assertMacroExpansion(
            original,
            expandedSource: expanded,
            macros: macros
        )
    }

    func testExpansion_whenAttachedToExtensionDecl() {
        let original = """
        @StorybookComponent
        extension MyButton.CustomStyle {
        }
        """

        let expanded = """
        extension MyButton.CustomStyle {
        
            public static var _storybookComponentProvider: some StorybookComposer.StorybookComponentProviding {
                StorybookComposer.StorybookComponentProvider(
                    name: "My Button - Custom Style",
                    sourceLocation: .init(
                        path: "TestModule/test.swift",
                        line: 1
                    ),
                    preview: Self.init
                )
            }
        }
        """

        assertMacroExpansion(
            original,
            expandedSource: expanded,
            macros: macros
        )
    }
}
