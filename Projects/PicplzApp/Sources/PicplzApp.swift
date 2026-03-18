//
//  PicplzApp.swift
//  ProjectDescriptionHelpers
//
//  Created by 임영택 on 12/18/25.
//

import Common
import ComposableArchitecture
import DependencyInjection
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import SwiftUI

@main
struct PicplzApp: App {
  static let store = Store(
    initialState: AppFeature.State()
  ) {
    AppFeature()
      ._printChanges()
  }

  private let logger = PicLogger(category: "PicplzApp")

  init() {
    if let kakaoAppKey = BundleInfos.kakaoAppKey.value {
      KakaoSDK.initSDK(appKey: kakaoAppKey)
      logger.info("Kakao SDK 초기화 완료")
    } else {
      logger.error("Kakao SDK 초기화 실패: KakaoAppKey가 설정되지 않았습니다.")
    }
  }

  var body: some Scene {
    WindowGroup {
      AppView(store: PicplzApp.store)
        .onOpenURL(perform: { url in
          if AuthApi.isKakaoTalkLoginUrl(url) {
            let result = AuthController.handleOpenUrl(url: url)
            logger.info("카카오톡으로부터의 콜백 - 카카오 로그인 결과=\(result)")
          }
        })
    }
  }
}
