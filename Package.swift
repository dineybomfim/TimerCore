import PackageDescription

let package = Package(
    name: "TimerCore",
    products: [
        .library(
            name: "TimerCore",
            targets: ["TimerCore"]
        ),
    ],
    targets: [
        .target(
            name: "TimerCore",
            dependencies: []
        ),
        .testTarget(
            name: "TimerCoreTests",
            dependencies: ["TimerCore"]
        ),
    ]
)
