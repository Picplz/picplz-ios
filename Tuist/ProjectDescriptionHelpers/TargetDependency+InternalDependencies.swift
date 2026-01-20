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
  static let presentation: Self = .project(target: "Presentation", path: .presentationPath)
  static let storage: Self = .project(target: "Storage", path: .storagePath)
  static let network: Self = .project(target: "Network", path: .networkPath)
  static let common: Self = .project(target: "Common", path: .commonPath)
  static let sharedSupports: Self = .project(target: "SharedSupports", path: .sharedSupportsPath)
}

public extension Path {
  static let appPath: Self = .relativeToRoot("Projects/PicplzApp")
  static let domainPath: Self = .relativeToRoot("Projects/Domain")
  static let presentationPath: Self = .relativeToRoot("Projects/Presentation")
  static let storagePath: Self = .relativeToRoot("Projects/Storage")
  static let networkPath: Self = .relativeToRoot("Projects/Network")
  static let commonPath: Self = .relativeToRoot("Projects/Common")
  static let sharedSupportsPath: Self = .relativeToRoot("Projects/SharedSupports")
}
