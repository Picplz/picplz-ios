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
    extraBuildSettings: SettingsDictionary = [:],
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
      let configurations: [Configuration] = [
        .release(name: "Release", xcconfig: .relativeToRoot("Configs/release.xcconfig")),
        .release(name: "Debug", xcconfig: .relativeToRoot("Configs/debug.xcconfig")),
      ]
      
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
          settings: .settings(base: extraBuildSettings, configurations: configurations)
        )
    }
    
    return Project(
        name: name,
        targets: targets,
        schemes: [
          .scheme(
            name: "\(name)-Release",
            buildAction: .buildAction(
              targets: targets.map({ TargetReference.target($0.name) })
            ),
            runAction: .runAction(configuration: .configuration("Release"))
          ),
          .scheme(
            name: "\(name)-Debug",
            buildAction: .buildAction(
              targets: targets.map({ TargetReference.target($0.name) })
            ),
            runAction: .runAction(configuration: .configuration("Debug"))
          )
        ]
    )
  }
}

private enum TargetCase {
  case main
  case unitTests
}
