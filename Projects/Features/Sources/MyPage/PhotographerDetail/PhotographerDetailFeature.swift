//
//  PhotographerDetailFeature.swift
//  Features
//

import ComposableArchitecture
import Foundation

@Reducer
public struct PhotographerDetailFeature {

    @ObservableState
    public struct State: Equatable, Hashable {
        let nickname: String
        let profileImageURL: String?
        let instagramUsername: String?
        let photographerBio: String
        let followerCount: Int
        let activeRegions: [String]
        let keywords: [String]
        let equipments: [String]
        let satisfactionRating: Double
        let reviews: [MyReviewsFeature.MyReview]
        let portfolios: [MyPageFeature.Portfolio]
        let packages: [MyPageFeature.ShootingPackage]
        var isFollowing: Bool
        let isAcceptingReservation: Bool

        var representativeReview: MyReviewsFeature.MyReview? { reviews.first }
        var displayedPortfolios: [MyPageFeature.Portfolio] { Array(portfolios.prefix(9)) }
        var hasMorePortfolios: Bool { portfolios.count > 9 }

        public init(
            nickname: String,
            profileImageURL: String? = nil,
            instagramUsername: String? = nil,
            photographerBio: String = "",
            followerCount: Int = 0,
            activeRegions: [String] = [],
            keywords: [String] = [],
            equipments: [String] = [],
            satisfactionRating: Double = 0.0,
            reviews: [MyReviewsFeature.MyReview] = [],
            portfolios: [MyPageFeature.Portfolio] = [],
            packages: [MyPageFeature.ShootingPackage] = [],
            isFollowing: Bool = false,
            isAcceptingReservation: Bool = true
        ) {
            self.nickname = nickname
            self.profileImageURL = profileImageURL
            self.instagramUsername = instagramUsername
            self.photographerBio = photographerBio
            self.followerCount = followerCount
            self.activeRegions = activeRegions
            self.keywords = keywords
            self.equipments = equipments
            self.satisfactionRating = satisfactionRating
            self.reviews = reviews
            self.portfolios = portfolios
            self.packages = packages
            self.isFollowing = isFollowing
            self.isAcceptingReservation = isAcceptingReservation
        }
    }

    public enum Action {
        case backButtonTapped
        case kebabMenuTapped
        case followTapped
        case instagramLinkTapped
        case viewAllReviewsTapped
        case viewAllPortfoliosTapped
        case portfolioTapped(String)
        case packageTapped(String)
        case reservationTapped
    }

    public init() {}

    public var body: some ReducerOf<PhotographerDetailFeature> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped,
                 .kebabMenuTapped,
                 .instagramLinkTapped,
                 .viewAllReviewsTapped,
                 .viewAllPortfoliosTapped,
                 .portfolioTapped,
                 .packageTapped,
                 .reservationTapped:
                // TODO: 후속 단계에서 동작 연결
                return .none
            case .followTapped:
                state.isFollowing.toggle()
                return .none
            }
        }
    }
}
