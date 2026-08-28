// swift-tools-version: 6.2

import PackageDescription

// The floor is Swift 6.2, which is current minus one. Apple ships the toolchain
// with Xcode and adoption is fast, so a tight floor costs less here than it does
// in Dart. Span and RawSpan are load-bearing for the zero-copy row surface and
// neither exists before 6.2.
//
// Language mode 6 only. There is no Swift 5 mode and there will not be one: the
// whole point of the Sendable annotations on the handle types is that the
// compiler checks them, and mode 5 downgrades those checks to warnings.

let package = Package(
    name: "yodb",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .tvOS(.v17),
        .watchOS(.v10),
        .visionOS(.v1),
    ],
    products: [
        .library(name: "Yodb", targets: ["Yodb"])
    ],
    targets: [
        // No binaryTarget yet. libyo.xcframework is built by the release train
        // in tamnd/yo and pinned here by URL and checksum once M1 lands a
        // record plane worth linking against. Until then this target is pure
        // Swift: the error surface, the code table and the version constants,
        // which are the parts that do not need the engine to exist.
        .target(
            name: "Yodb",
            swiftSettings: [
                .swiftLanguageMode(.v6),
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("InternalImportsByDefault"),
            ]
        ),
        .testTarget(
            name: "YodbTests",
            dependencies: ["Yodb"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
    ]
)
