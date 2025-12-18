import ProjectDescription

let project = Project(
    name: "picplz-ios",
    targets: [
        .target(
            name: "picplz-ios",
            destinations: .iOS,
            product: .app,
            bundleId: "dev.tuist.picplz-ios",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["picplz-ios/Sources/**"],
            resources: ["picplz-ios/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "picplz-iosTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "dev.tuist.picplz-iosTests",
            infoPlist: .default,
            sources: ["picplz-ios/Tests/**"],
            resources: [],
            dependencies: [.target(name: "picplz-ios")]
        ),
    ]
)
