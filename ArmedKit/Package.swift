// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

extension Target.Dependency {
    static let ui: Self = "UI"
    static let shared: Self = "Shared"
    static let assets: Self = "Assets"

    static let batteryClient: Self = "BatteryClient"
    static let cameraClient: Self = "CameraClient"
    static let playerClient: Self = "PlayerClient"

    static let swiftLocation: Self = .product(name: "SwiftLocation", package: "SwiftLocation")
    static let swiftDependenciesMacros: Self = .product(name: "DependenciesMacros", package: "swift-dependencies")
    static let swiftDependencies: Self = .product(name: "Dependencies", package: "swift-dependencies")
    static let defaults: Self = .product(name: "Defaults", package: "Defaults")
    static let asyncAlgorithms: Self = .product(name: "AsyncAlgorithms", package: "swift-async-algorithms")

    static let macControlCenterUI: Self = .product(name: "MacControlCenterUI", package: "MacControlCenterUI")
}

let package = Package(
    name: "ArmedKit",
    platforms: [.iOS(.v13), .macOS(.v13)],
    products: [
        .library(name: "UI", targets: ["UI"]),
        .library(name: "Shared", targets: ["Shared"]),
        .library(name: "Assets", targets: ["Assets"]),
        .library(name: "BatteryClient", targets: ["BatteryClient"]),
        .library(name: "CameraClient", targets: ["CameraClient"]),
        .library(name: "PlayerClient", targets: ["PlayerClient"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-async-algorithms", from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.3.1"),
        .package(url: "https://github.com/sindresorhus/Defaults", from: "8.2.0"),
        .package(url: "https://github.com/orchetect/MenuBarExtraAccess", from: "1.0.3"),
        .package(url: "https://github.com/orchetect/MacControlCenterUI", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "UI",
            dependencies: [
                .shared,
                .macControlCenterUI,
            ]
        ),
        .target(
            name: "Shared",
            dependencies: [
                .defaults,
            ]
        ),
        .target(
            name: "Assets"
        ),
        .target(
            name: "BatteryClient",
            dependencies: [
                .swiftDependencies,
                .swiftDependenciesMacros,
            ]
        ),
        .target(
            name: "CameraClient",
            dependencies: [
                .swiftDependencies,
                .swiftDependenciesMacros,
            ]
        ),
        .target(
            name: "PlayerClient",
            dependencies: [
                .swiftDependencies,
                .swiftDependenciesMacros,
            ]
        ),
    ]
)
