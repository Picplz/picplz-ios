//
//  PastShootingsFeature.swift
//  Features
//
//  Created by wonsik on 4/2/26.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct PastShootingsFeature {
    // MARK: - Placeholder Model (추후 Domain 모델로 교체)
    public struct PastShooting: Equatable, Identifiable, Hashable {
        public let id: String
        public let photographerName: String
        public let photographerImageURL: String?
        public let title: String                // 촬영명
        public let price: Int                   // 가격
        public let status: ShootingStatus       // 촬영 상태
        public let dateTime: String             // 촬영 일시
        public let location: String             // 촬영 장소
        public let paymentDate: String          // 결제 날짜
    }

    public enum ShootingStatus: String, Equatable, Hashable {
        case completed = "촬영 완료"
        case cancelled = "촬영 취소"
    }

    @ObservableState
    public struct State: Equatable, Hashable {
        var pastShootings: [PastShooting] = []
        public init() {}
    }

    public enum Action: Hashable {
        case backButtonTapped
        case chatButtonTapped(String)           // TODO: 채팅 화면 연동
        case reviewButtonTapped(String)         // TODO: 리뷰 작성 화면 연동
        case orderDetailTapped(String)          // TODO: 주문 상세 화면 연동
    }

    public init() {}

    public var body: some ReducerOf<PastShootingsFeature> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .none
            case .chatButtonTapped:
                // TODO: 채팅 화면 연동
                return .none
            case .reviewButtonTapped:
                // TODO: 리뷰 작성 화면 연동
                return .none
            case .orderDetailTapped:
                // TODO: 주문 상세 화면 연동
                return .none
            }
        }
    }
}
