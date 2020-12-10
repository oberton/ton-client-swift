// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

#if os(iOS)
var targets: [PackageDescription.Target] = [
    .systemLibrary(name: "CTonSDK"),
    .target(
        name: "TonClientSwift",
        dependencies: [
            .systemLibrary(name: "CTonSDK"),
            .product(name: "SwiftRegularExpression", package: "SwiftRegularExpression"),
        ]
    ),
    .testTarget(
        name: "TonClientSwiftTests",
        dependencies: [
            .byName(name: "TonClientSwift")
        ]
    ),
]
#else
var targets: [PackageDescription.Target] = [
    .systemLibrary(name: "CTonSDK"),
    .target(
        name: "TonClientSwift",
        dependencies: [
            .byName(name: "CTonSDK"),
            .product(name: "SwiftRegularExpression", package: "SwiftRegularExpression"),
        ]
        , cxxSettings: [
            .headerSearchPath("dependencies/include")
        ],
        linkerSettings: [
            .unsafeFlags(["-Ldependencies/ton-sdk/lib", "-lton_client"])
        ]
    ),
    .testTarget(
        name: "TonClientSwiftTests",
        dependencies: [
            .byName(name: "TonClientSwift")
        ]
    ),
]
#endif



let package = Package(
    name: "TonClientSwift",
    platforms: [
        .macOS(SupportedPlatform.MacOSVersion.v10_12),
        .iOS(SupportedPlatform.IOSVersion.v10)
    ],
    products: [
        .library(name: "TonClientSwift", targets: ["TonClientSwift"])
    ],
    dependencies: [
        .package(name: "SwiftRegularExpression", url: "https://github.com/nerzh/swift-regular-expression.git", .upToNextMajor(from: "0.2.3")),
    ],
    targets: targets,
    swiftLanguageVersions: [
        SwiftVersion.v5
    ]
)
