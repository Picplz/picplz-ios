//
//  TargetDependency+ExternalDependencies.swift
//  ProjectDescriptionHelpers
//
//  Created by 임영택 on 12/18/25.
//

import ProjectDescription

public extension TargetDependency {
  static let moya: TargetDependency = .external(name: "Moya")
  static let composableArchitecture: TargetDependency = .external(name: "ComposableArchitecture")
  static let kakaoSDK: TargetDependency = .external(name: "KakaoSDK")
  static let kakaoSDKAuth: TargetDependency = .external(name: "KakaoSDKAuth")
  static let kakaoSDKUser: TargetDependency = .external(name: "KakaoSDKUser")
}
