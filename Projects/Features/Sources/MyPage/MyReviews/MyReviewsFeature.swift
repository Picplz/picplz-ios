//
//  MyReviewsFeature.swift
//  Features
//
//  Created by wonsik on 4/2/26.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct MyReviewsFeature {
    public struct MyReview: Equatable, Hashable, Identifiable {
        public let id: String
        public let reviewerName: String             // 리뷰 작성자(유저) 이름
        public let reviewerImageURL: String?        // 리뷰 작성자 프로필 이미지
        public let photographerName: String         // 촬영 작가 이름
        public let photographerImageURL: String?    // 촬영 작가 프로필 이미지
        public let rating: Int
        public let date: String
        public let imageURLs: [String]
        public let option: String
        public let location: String
        public let content: String
        public var likeCount: Int = 0
    }

    @ObservableState
    public struct State: Equatable, Hashable {
        var reviews: [MyReview] = []
        var showDeleteAlert: Bool = false
        var reviewToDelete: MyReview?

        public init(reviews: [MyReview] = []) {
            self.reviews = reviews
        }
    }

    public enum Action: Hashable {
        case backButtonTapped
        case reviewTapped(MyReview)
        case deleteTapped(MyReview)
        case likeTapped(MyReview)
        case dismissDeleteAlert
        case confirmDelete
        // TODO: 내 리뷰 목록 API 연동
        case onAppear
        case reviewsLoaded([MyReview])
    }

    public init() {}

    public var body: some ReducerOf<MyReviewsFeature> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .none
            case .reviewTapped:
                return .none
            case let .deleteTapped(review):
                state.reviewToDelete = review
                state.showDeleteAlert = true
                return .none
            case .likeTapped:
                // TODO: 좋아요 API 호출
                return .none
            case .dismissDeleteAlert:
                state.showDeleteAlert = false
                state.reviewToDelete = nil
                return .none
            case .confirmDelete:
                if let review = state.reviewToDelete {
                    state.reviews.removeAll { $0.id == review.id }
                }
                state.showDeleteAlert = false
                state.reviewToDelete = nil
                // TODO: 리뷰 삭제 API 호출
                return .none
            case .onAppear:
                // TODO: 내 리뷰 목록 API 호출
                return .none
            case let .reviewsLoaded(reviews):
                state.reviews = reviews
                return .none
            }
        }
    }
}
