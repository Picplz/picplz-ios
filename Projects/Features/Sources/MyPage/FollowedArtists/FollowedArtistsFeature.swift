//
//  FollowedArtistsFeature.swift
//  Features
//
//  Created by wonsik on 4/2/26.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct FollowedArtistsFeature {
    @ObservableState
    public struct State: Equatable, Hashable {
        public init() {}
    }

    public enum Action: Hashable {
        case backButtonTapped
    }

    public init() {}

    public var body: some ReducerOf<FollowedArtistsFeature> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .none
            }
        }
    }
}
