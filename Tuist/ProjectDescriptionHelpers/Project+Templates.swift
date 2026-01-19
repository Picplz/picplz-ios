//
//  Project+Templates.swift
//  Packages
//
//  Created by 임영택 on 12/18/25.
//

import ProjectDescription

public extension Project {
  static let bundleIdBase: String = "com.hm.picplz"
  
  static let minimumOSVersion: String = "17.0"
  
  static func create(
    isAppProject: Bool,
    hasUnitTests: Bool,
    infoPlist: InfoPlist,
    hasResources: Bool,
    dependencies: [TargetDependency],
    settings: Settings? = nil,
    externalPackages: [TargetDependency] = [],
    name: String
  ) -> Self {
    let targetCases: [TargetCase] = hasUnitTests ? [.main, .unitTests] : [.main]
    
    let targets: [Target] = targetCases.map { targetCase in
      let currentName: String = targetCase == .main ? name : "\(name)Tests"
      let product: Product = targetCase == .unitTests ? .unitTests
                                                      : (isAppProject ? .app : .framework)
      let bundleId: String = "\(bundleIdBase).\(name)"
      let sources: SourceFilesList = targetCase == .main ? ["Sources/**"]
                                                         : ["Tests/Sources/**"]
      let resources: ResourceFileElements = targetCase == .main ? ["Resources/**"]
                                                                : ["Tests/Resources/**"]
      
      return .target(
          name: currentName,
          destinations: .iOS,
          product: product,
          bundleId: bundleId,
          deploymentTargets: .iOS(minimumOSVersion),
          infoPlist: infoPlist,
          sources: sources,
          resources: resources,
          dependencies: targetCase == .unitTests ? [.target(name: name)]
                                                 : dependencies + externalPackages,
          settings: settings
        )
    }
    
    return Project(
        name: name,
        targets: targets,
    )
  }
}

private enum TargetCase {
  case main
  case unitTests
}
