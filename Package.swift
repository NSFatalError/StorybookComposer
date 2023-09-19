// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "StorybookComposer",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
        .macCatalyst(.v16)
    ],
    products: [
        .library(
            name: "StorybookComposer",
            targets: ["StorybookComposer"]
        ),
        .plugin(
            name: "StorybookComposerPlugin",
            targets: ["StorybookComposerPlugin"]
        ),
        .executable(
            name: "StorybookComposerGenerator",
            targets: ["StorybookComposerGenerator"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-syntax.git",
            from: "509.0.0-swift-5.9-DEVELOPMENT-SNAPSHOT-2023-09-05-a"
        ),
        .package(
            url: "https://github.com/apple/swift-argument-parser",
            from: "1.2.0"
        )
    ],
    targets: [
        .target(
            name: "StorybookComposer",
            dependencies: [
                "StorybookComposerMacrosPlugin"
            ]
        ),

        // ---

        .target(
            name: "StorybookComposerMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .macro(
            name: "StorybookComposerMacrosPlugin",
            dependencies: [
                "StorybookComposerMacros"
            ]
        ),
        .testTarget(
            name: "StorybookComposerMacrosTests",
            dependencies: [
                "StorybookComposerMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax")
            ]
        ),

        // ---

        .executableTarget(
            name: "StorybookComposerGenerator",
            dependencies: [
                "StorybookComposerMacros",
                .product(name: "SwiftSyntaxMacroExpansion", package: "swift-syntax"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .binaryTarget(
            name: "StorybookComposerGeneratorTool",
            path: "Tools/StorybookComposerGenerator.artifactbundle"
        ),
        .testTarget(
            name: "StorybookComposerGeneratorTests",
            dependencies: [
                "StorybookComposerGenerator",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax")
            ]
        ),

        // ---

        .plugin(
            name: "StorybookComposerPlugin",
            capability: .buildTool(),
            dependencies: [
                .target(
                    name: "StorybookComposerGeneratorTool",
                    condition: .when(platforms: [.macOS])
                )
            ]
        )
    ]
)
