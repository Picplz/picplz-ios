//
//  TermsDetailFeature.swift
//  Features
//
//  Created by giwan jo on 7/14/26.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct TermsDetailFeature {
    @ObservableState
    public struct State: Equatable, Hashable {
        let item: TermsFeature.TermsItem
    }

    public enum Action {
        case backButtonTapped
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .none
            }
        }
    }
}
