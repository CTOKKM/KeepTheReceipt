// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "KeepTheReceipt",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "KeepTheReceipt",
            targets: ["KeepTheReceipt"]),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.0.0")
    ],
    targets: [
        .target(
            name: "KeepTheReceipt",
            dependencies: [
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk")
            ]),
    ]
) 