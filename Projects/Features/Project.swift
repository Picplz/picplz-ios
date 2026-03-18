//
//  Project.swift
//  Packages
//
//  Created by 임영택 on 12/18/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.create(
  isAppProject: false,
  hasUnitTests: true,
  infoPlist: .default,
  hasResources: true,
  dependencies: [.domain, .sharedSupports, .common],
  extraBuildSettings: [
    "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES", // Generate Swift Asset Symbol Extensions = YES
  ],
  name: "Features"
)
