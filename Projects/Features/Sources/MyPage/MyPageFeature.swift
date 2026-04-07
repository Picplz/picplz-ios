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
        var path = StackState<Path.State>()

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

    public enum Action {
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
        case path(StackAction<Path.State, Path.Action>)
    }

    public init() { }

    public var body: some ReducerOf<MyPageFeature> {
        Reduce { state, action in
            switch action {
            case let .togglePhotographerMode(isOn):
                state.isPhotographerMode = isOn
                return .none

            case .navigateToPhotographerRegister:
                // TODO: 작가 등록 화면 네비게이션 연결
                return .none
            case .profileEditTapped:
                state.path.append(.profileEdit(ProfileEditFeature.State()))
                return .none
            case .navigateToSearch:
                // TODO: 촬영지 검색 화면 네비게이션 연결
                return .none
            case .shootingCardTapped:
                // TODO: 예약 정보 화면 네비게이션 연결
                return .none
            case .followedArtistsTapped:
                state.path.append(.followedArtists(FollowedArtistsFeature.State()))
                return .none
            case .myReviewsTapped:
                state.path.append(.myReviews(MyReviewsFeature.State()))
                return .none
            case .termsOfServiceTapped:
                // TODO: 이용 약관 화면 네비게이션 연결
                return .none
            case .settingsTapped:
                state.path.append(.settings(SettingsFeature.State()))
                return .none
            case .pastShootingsTapped:
                state.path.append(.pastShootings(PastShootingsFeature.State()))
                return .none
            case .path(.element(id: _, action: .myReviews(.reviewTapped(let review)))):
                state.path.append(.reviewDetail(ReviewDetailFeature.State(review: review)))
                return .none
            case .path(.element(id: _, action: .reviewDetail(.confirmDelete))):
                _ = state.path.popLast()
                return .none
            case .path(.element(id: _, action: .profileEdit(.backButtonTapped))),
             .path(.element(id: _, action: .pastShootings(.backButtonTapped))),
             .path(.element(id: _, action: .settings(.backButtonTapped))),
             .path(.element(id: _, action: .followedArtists(.backButtonTapped))),
             .path(.element(id: _, action: .myReviews(.backButtonTapped))),
             .path(.element(id: _, action: .reviewDetail(.backButtonTapped))):
                _ = state.path.popLast()
                return .none
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
    }

    @Reducer
    public struct Path {
        @ObservableState
        public enum State: Equatable, Hashable {
            case profileEdit(ProfileEditFeature.State)
            case pastShootings(PastShootingsFeature.State)
            case settings(SettingsFeature.State)
            case followedArtists(FollowedArtistsFeature.State)
            case myReviews(MyReviewsFeature.State)
            case reviewDetail(ReviewDetailFeature.State)
        }

        public enum Action {
            case profileEdit(ProfileEditFeature.Action)
            case pastShootings(PastShootingsFeature.Action)
            case settings(SettingsFeature.Action)
            case followedArtists(FollowedArtistsFeature.Action)
            case myReviews(MyReviewsFeature.Action)
            case reviewDetail(ReviewDetailFeature.Action)
        }

        public init() {}

        public var body: some ReducerOf<Path> {
            Scope(state: \.profileEdit, action: \.profileEdit) {
                ProfileEditFeature()
            }
            Scope(state: \.pastShootings, action: \.pastShootings) {
                PastShootingsFeature()
            }
            Scope(state: \.settings, action: \.settings) {
                SettingsFeature()
            }
            Scope(state: \.followedArtists, action: \.followedArtists) {
                FollowedArtistsFeature()
            }
            Scope(state: \.myReviews, action: \.myReviews) {
                MyReviewsFeature()
            }
            Scope(state: \.reviewDetail, action: \.reviewDetail) {
                ReviewDetailFeature()
            }
        }
    }
}
