// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "MVISwift",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "MVISwift",
            targets: ["MVISwift"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/iosheadhunter/OpenCombine.git",
            .branch("master")
        )
    ],
    targets: [
        .target(
            name: "MVISwift",
            path: "Sources"
        ),
        .testTarget(
            name: "MVISwiftTests",
            dependencies: ["MVISwift"],
            path: "Tests"
        )
    ],
    swiftLanguageVersions: [.v5]
)