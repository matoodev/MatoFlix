// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "MatoFlix",
    platforms: [
        .macOS(.v13)
    ],
    targets: [
        .executableTarget(
            name: "MatoFlix",
            dependencies: [],
            path: "Sources"
        )
    ]
)
