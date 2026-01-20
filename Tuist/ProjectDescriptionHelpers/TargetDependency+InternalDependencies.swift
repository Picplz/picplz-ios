//
//  TargetDependency+ReservedDependencies.swift
//  ProjectDescriptionHelpers
//
//  Created by 임영택 on 12/18/25.
//

import ProjectDescription

public extension TargetDependency {
  static let app: Self = .project(target: "PicplzApp", path: .appPath)
  static let domain: Self = .project(target: "Domain", path: .domainPath)
  static let features: Self = .project(target: "Features", path: .featuresPath)
  static let storage: Self = .project(target: "Storage", path: .storagePath)
  static let networking: Self = .project(target: "Networking", path: .networkingPath)
  static let common: Self = .project(target: "Common", path: .commonPath)
  static let sharedSupports: Self = .project(target: "SharedSupports", path: .sharedSupportsPath)
}

public extension Path {
  static let appPath: Self = .relativeToRoot("Projects/PicplzApp")
  static let domainPath: Self = .relativeToRoot("Projects/Domain")
  static let featuresPath: Self = .relativeToRoot("Projects/Features")
  static let storagePath: Self = .relativeToRoot("Projects/Storage")
  static let networkingPath: Self = .relativeToRoot("Projects/Networking")
  static let commonPath: Self = .relativeToRoot("Projects/Common")
  static let sharedSupportsPath: Self = .relativeToRoot("Projects/SharedSupports")
}
