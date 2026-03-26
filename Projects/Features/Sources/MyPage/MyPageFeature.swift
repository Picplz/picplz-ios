//
//  MyPageFeature.swift
//  Features
//
//  Created by wonsik on 3/26/26.
//

import ComposableArchitecture
import Domain
import Foundation

@Reducer
public struct MyPageFeature {
    // MARK: - Placeholder Model (추후 Domain 모델로 교체)
    public struct ActiveShooting: Equatable, Identifiable, Hashable {
        public let id: String
        public let photographerName: String       // 작가 이름
        public let photographerImageURL: String?  // 작가 프로필 이미지 URL
        public let status: String                 // 예약 상태 (예: "예약 확정")
        public let title: String                  // 촬영명
        public let dateTime: String               // 촬영 일시
        public let location: String               // 촬영 장소
    }

    @ObservableState
    public struct State: Equatable {
        var hasPhotographerInfo: Bool = false      // 작가 정보 존재 여부
        var isPhotographerMode: Bool = false       // 작가 모드 토글 상태
        var nickname: String = ""
        var profileImageURL: String? = nil
        var activeShootings: [ActiveShooting] = [] // 진행중인 촬영 목록

        public init(
            hasPhotographerInfo: Bool = false,
            nickname: String = "",
            activeShootings: [ActiveShooting] = []
        ) {
            self.hasPhotographerInfo = hasPhotographerInfo
            self.nickname = nickname
            self.activeShootings = activeShootings
        }
    }

    public enum Action: Hashable {
        case togglePhotographerMode(Bool)       // 작가 모드 토글 변경
        case navigateToPhotographerRegister     // 작가 등록 화면으로 이동
        case profileEditTapped                  // 프로필 수정 화면으로 이동
        case navigateToSearch                   // 촬영지 검색 화면으로 이동
        case shootingCardTapped(String)         // 촬영 카드 탭 → 예약 정보 화면 (id)
        case followedArtistsTapped              // 팔로우 작가 목록으로 이동
        case myReviewsTapped                    // 내 리뷰 목록으로 이동
        case termsOfServiceTapped               // 이용 약관 화면으로 이동
        case settingsTapped                     // 설정 화면으로 이동
        case pastShootingsTapped                // 지난 촬영 내역으로 이동
    }

    public init() { }

    public var body: some ReducerOf<MyPageFeature> {
        Reduce { state, action in
            switch action {
            case let .togglePhotographerMode(isOn):
                state.isPhotographerMode = isOn
                return .none

            // TODO: 각 화면 네비게이션 연결 (탭 구조 구현 후)
            case .navigateToPhotographerRegister:
                return .none
            case .profileEditTapped:
                return .none
            case .navigateToSearch:
                return .none
            case .shootingCardTapped:
                return .none
            case .followedArtistsTapped:
                return .none
            case .myReviewsTapped:
                return .none
            case .termsOfServiceTapped:
                return .none
            case .settingsTapped:
                return .none
            case .pastShootingsTapped:
                return .none
            }
        }
    }
}
