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
    @ObservableState
    public struct State: Equatable, Hashable {
        public init() {}
    }

    public enum Action: Hashable {
        case backButtonTapped
    }

    public init() {}

    public var body: some ReducerOf<PastShootingsFeature> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .none
            }
        }
    }
}
