// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "KeepTheReceipt",
    platforms: [
        .iOS(.v15)
    ],
    dependencies: [
        .package(url: "https://github.com/googleapis/google-cloud-swift.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "KeepTheReceipt",
            dependencies: [
                .product(name: "GoogleCloudVision", package: "google-cloud-swift")
            ]
        )
    ]
) 