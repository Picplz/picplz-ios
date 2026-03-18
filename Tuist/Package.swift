// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
        productTypes: [
            "ComposableArchitecture": .framework
            "ComposableArchitecture": .framework, // 여러 모듈에서 참조하는 모듈은 Dynamic Framework로
            "Alamofire": .framework,
            "KakaoSDKCommon": .framework,
            "KakaoSDKAuth": .framework,
            "KakaoSDKUser": .framework
        ]
    )
#endif

let package = Package(
    name: "picplz-ios",
    dependencies: [
      .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "15.0.0")),
      .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", exact: "1.23.1"),
      .package(url: "https://github.com/kakao/kakao-ios-sdk", exact: "2.27.2"),
    ]
)
