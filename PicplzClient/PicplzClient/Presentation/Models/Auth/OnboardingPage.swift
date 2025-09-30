//
//  OnboardingModel.swift
//  PicplzClient
//
//  Created by 임영택 on 2/9/25.
//

import Foundation
import UIKit

struct OnboardingPage: Hashable {
    let onboardingMessage: String
    let onboardingImage: ImageResource?

    static let pages: [OnboardingPage] = [
        .init(onboardingMessage: "내 인생샷 찍어줄\n픽플과 위치기반 매칭!", onboardingImage: .intro1),
        .init(onboardingMessage: "인생샷 맛집\n핫플레이스 추천", onboardingImage: .intro2),
        .init(onboardingMessage: "나의 인생 프사,\n이젠 픽플즈가 함께", onboardingImage: .intro3)
    ]
}
