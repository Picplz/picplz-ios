//
//  ReviewDetailFeature.swift
//  Features
//
//  Created by wonsik on 4/7/26.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct ReviewDetailFeature {
    @ObservableState
    public struct State: Equatable, Hashable {
        var review: MyReviewsFeature.MyReview
        var currentImageIndex: Int = 0
        var showDeleteAlert: Bool = false

        public init(review: MyReviewsFeature.MyReview) {
            self.review = review
        }
    }

    public enum Action: Hashable {
        case backButtonTapped
        case deleteTapped
        case dismissDeleteAlert
        case confirmDelete
        case photographerTapped
        case likeTapped
        case imageIndexChanged(Int)
    }

    public init() {}

    public var body: some ReducerOf<ReviewDetailFeature> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .none
            case .deleteTapped:
                state.showDeleteAlert = true
                return .none
            case .dismissDeleteAlert:
                state.showDeleteAlert = false
                return .none
            case .confirmDelete:
                // TODO: 리뷰 삭제 API 호출
                return .none
            case .photographerTapped:
                // TODO: 작가 상세 화면 이동
                return .none
            case .likeTapped:
                // TODO: 좋아요 API 호출
                return .none
            case let .imageIndexChanged(index):
                state.currentImageIndex = index
                return .none
            }
        }
    }
}
