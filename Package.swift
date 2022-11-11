// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SFImagePicker",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "SFImagePicker",
                 targets: ["SFImagePicker"])
    ],
    targets: [
        .target(name: "SFImagePicker",
                path: "SFImagePicker/Classes")
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
