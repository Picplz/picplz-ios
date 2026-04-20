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
    @Dependency(\.openURL) var openURL

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

    public struct ShootingPackage: Equatable, Identifiable, Hashable {
        public let id: String
        public let title: String
        public let price: Int
        public let coverImageURL: String?
        public let shootingDuration: String
        public let detail: String
    }

    public struct PortfolioImage: Equatable, Identifiable, Hashable {
        public let id: String
        public let imageURL: String
    }

    @ObservableState
    public struct State: Equatable {
        var hasPhotographerInfo: Bool = false      // 작가 정보 존재 여부
        var isPhotographerMode: Bool = false       // 작가 모드 토글 상태
        var nickname: String = ""
        var profileImageURL: String? = nil
        var activeShootings: [ActiveShooting] = [] // 진행중인 촬영 목록
        var pastShootings: [PastShootingsFeature.PastShooting] = [] // 지난 촬영 내역

        // MARK: - 작가 모드 전용 필드
        var instagramUsername: String? = nil       // 인스타그램 아이디 (nil/빈 값 = 미등록)
        var photographerBio: String = ""           // 작가 소개 한 줄
        var followerCount: Int = 0                 // 팔로워 수
        var activeRegions: [String] = []           // 주 촬영지 목록
        var keywords: [String] = []                // 키워드 목록 (# 포함 저장)
        var equipments: [String] = []              // 장비 목록
        var packages: [ShootingPackage] = []        // 촬영 패키지 목록
        var hasPackages: Bool { !packages.isEmpty }
        var portfolios: [PortfolioImage] = []        // 포트폴리오 이미지 목록
        var hasPortfolios: Bool { !portfolios.isEmpty }
        var satisfactionRating: Double = 0.0       // 촬영 만족도 (0.0 ~ 5.0)

        var path = StackState<Path.State>()

        public init(
            hasPhotographerInfo: Bool = false,
            isPhotographerMode: Bool = false,
            nickname: String = "",
            activeShootings: [ActiveShooting] = [],
            pastShootings: [PastShootingsFeature.PastShooting] = [],
            instagramUsername: String? = nil,
            photographerBio: String = "",
            followerCount: Int = 0,
            activeRegions: [String] = [],
            keywords: [String] = [],
            equipments: [String] = [],
            packages: [ShootingPackage] = [],
            portfolios: [PortfolioImage] = [],
            satisfactionRating: Double = 0.0
        ) {
            self.hasPhotographerInfo = hasPhotographerInfo
            self.isPhotographerMode = isPhotographerMode
            self.nickname = nickname
            self.activeShootings = activeShootings
            self.pastShootings = pastShootings
            self.instagramUsername = instagramUsername
            self.photographerBio = photographerBio
            self.followerCount = followerCount
            self.activeRegions = activeRegions
            self.keywords = keywords
            self.equipments = equipments
            self.packages = packages
            self.portfolios = portfolios
            self.satisfactionRating = satisfactionRating
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

        // MARK: - 작가 모드 전용 액션
        case profilePreviewTapped               // 프로필 미리보기
        case instagramLinkTapped                // 인스타그램 프로필 열기
        case activeRegionsEditTapped            // 주 촬영지 편집
        case keywordsEditTapped                 // 키워드 편집
        case equipmentsEditTapped               // 장비 편집
        case settlementTapped                   // 정산 내역 화면으로 이동
        case packagesEditTapped                 // 촬영 패키지 편집
        case portfolioEditTapped                // 포트폴리오 편집

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
                state.path.append(.profileEdit(
                    ProfileEditFeature.State(
                        nickname: state.nickname,
                        isPhotographer: state.isPhotographerMode,
                        instagramUsername: state.instagramUsername ?? "",
                        bio: state.photographerBio
                    )
                ))
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
                state.path.append(.pastShootings(
                    PastShootingsFeature.State(pastShootings: state.pastShootings)
                ))
                return .none

            case .profilePreviewTapped:
                // TODO: 작가 프로필 미리보기 화면 네비게이션 연결
                return .none
            case .instagramLinkTapped:
                guard let username = state.instagramUsername?.trimmingCharacters(in: .whitespaces),
                      !username.isEmpty,
                      let url = URL(string: "https://instagram.com/\(username)") else {
                    return .none
                }
                return .run { _ in
                    await openURL(url)
                }
            case .activeRegionsEditTapped:
                // TODO: 주 촬영지 편집 화면 네비게이션 연결
                return .none
            case .keywordsEditTapped:
                // TODO: 키워드 편집 화면 네비게이션 연결
                return .none
            case .equipmentsEditTapped:
                // TODO: 장비 편집 화면 네비게이션 연결
                return .none
            case .settlementTapped:
                // TODO: 정산 내역 화면 네비게이션 연결
                return .none
            case .packagesEditTapped:
                state.path.append(.packageEdit(
                    PackageEditFeature.State(packages: state.packages)
                ))
                return .none
            case .portfolioEditTapped:
                // TODO: 포트폴리오 편집 화면 네비게이션 연결
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
             .path(.element(id: _, action: .reviewDetail(.backButtonTapped))),
             .path(.element(id: _, action: .packageEdit(.backButtonTapped))):
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
            case packageEdit(PackageEditFeature.State)
        }

        public enum Action {
            case profileEdit(ProfileEditFeature.Action)
            case pastShootings(PastShootingsFeature.Action)
            case settings(SettingsFeature.Action)
            case followedArtists(FollowedArtistsFeature.Action)
            case myReviews(MyReviewsFeature.Action)
            case reviewDetail(ReviewDetailFeature.Action)
            case packageEdit(PackageEditFeature.Action)
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
            Scope(state: \.packageEdit, action: \.packageEdit) {
                PackageEditFeature()
            }
        }
    }
}
