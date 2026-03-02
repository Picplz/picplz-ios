//
//  OnboardingData.swift
//  Features
//
//  Created by 임영택 on 2/3/26.
//

import SwiftUI

struct OnboardingData {
  let guideImage: ImageResource
  let guideMessage: LocalizedStringKey

  static var defaultData: [OnboardingData] {
    [
      OnboardingData(
        guideImage: .onboarding0,
        guideMessage: "내 인생샷 찍어줄\n작가님과 위치기반 매칭!"
      ),
      OnboardingData(
        guideImage: .onboarding1,
        guideMessage: "작가와 고객 모두 걱정 없는\n정찰제, 안전 결제 시스템!"
      ),
      OnboardingData(
        guideImage: .onboarding2,
        guideMessage: "나의 인생 프사,\n이젠 픽플즈가 함께"
      ),
    ]
  }
}
