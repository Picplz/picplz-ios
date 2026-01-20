//
//  Project.swift
//  Packages
//
//  Created by 임영택 on 12/18/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.create(
  isAppProject: true,
  hasUnitTests: false,
  infoPlist: InfoPlist.extendingDefault(
    with: [
        "UILaunchScreen": [
            "UIColorName": "",
            "UIImageName": "",
        ],
    ]
  ),
  hasResources: false,
  dependencies: [.presentation, .domain, .network, .storage, .sharedSupports],
  name: "PicplzApp"
)
