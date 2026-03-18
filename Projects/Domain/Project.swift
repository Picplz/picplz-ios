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
  hasResources: false,
  dependencies: [],
  externalPackages: [.composableArchitecture],
  name: "Domain"
)
