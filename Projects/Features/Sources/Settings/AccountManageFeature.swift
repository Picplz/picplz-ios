//
//  AccountManageFeature.swift
//  Features
//
//  Created by giwan jo on 7/13/26.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct AccountManageFeature {
    @ObservableState
    public struct State: Equatable, Hashable {}
    
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
