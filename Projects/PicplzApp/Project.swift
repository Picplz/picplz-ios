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
    ]
  ),
  hasResources: false,
  dependencies: [.common, .features, .domain, .networking, .storage],
  name: "PicplzApp"
)
