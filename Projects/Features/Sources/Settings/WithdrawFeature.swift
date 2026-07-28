//
//  WithdrawFeature.swift
//  Features
//
//  Created by giwan jo on 7/14/26.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct WithdrawFeature {
    @ObservableState
    public struct State: Equatable, Hashable {
        var isAgreed: Bool = false
    }
    
    public enum Action {
        case backButtonTapped
        case agreementToggled
        case withdrawButtonTapped
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .none
            case .agreementToggled:
                state.isAgreed.toggle()
                return .none
            case .withdrawButtonTapped:
                // TODO: 회원 탈퇴 연동
                return .none
            }
        }
    }
}
