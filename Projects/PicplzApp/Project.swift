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
        "LSApplicationQueriesSchemes": ["kakaokompassauth"],
        "CFBundleURLTypes": [
          [
            "CFBundleURLSchemes": ["kakao${KAKAO_APP_KEY}"]
          ]
        ],
        "NSAppTransportSecurity": [
          "NSAllowsArbitraryLoads": true, // 서버 TLS 지원 전까지 설정 적용
        ],
        "KakaoAppId": "$(KAKAO_APP_ID)",
        "KakaoAppKey": "$(KAKAO_APP_KEY)",
        "BaseURL": "$(BASE_URL)",
        "NSLocationAlwaysAndWhenInUseUsageDescription": "위치 기반 기능을 위해 기기 위치 정보를 활용합니다. 현재 위치를 토대로 근처 작가 또는 고객과의 매칭 서비스를 제공합니다.",
        "NSLocationWhenInUseUsageDescription": "위치 기반 기능을 위해 기기 위치 정보를 활용합니다. 현재 위치를 토대로 근처 작가 또는 고객과의 매칭 서비스를 제공합니다.",
        "NSLocationAlwaysUsageDescription": "위치 기반 기능을 위해 기기 위치 정보를 활용합니다. 현재 위치를 토대로 근처 작가 또는 고객과의 매칭 서비스를 제공합니다.",
    ]
  ),
  hasResources: false,
  dependencies: [.common, .features, .domain, .networking, .storage, .platform],
  name: "PicplzApp"
)
