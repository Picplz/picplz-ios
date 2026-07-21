//
//  AccountManageFeature.swift
//  Features
//
//  Created by giwan jo on 7/13/26.
//

import ComposableArchitecture
import Domain
import Foundation

@Reducer
public struct AccountManageFeature {
    @ObservableState
    public struct State: Equatable, Hashable {
        var name: String = "주은강"
        var phoneNumber: String = "010-1234-5678"
        var signInProvider: SignInProvider = .kakao
        var isIdentityVerified: Bool = true
    }

    public enum Action {
        case backButtonTapped
        case identityVerificationTapped
        case logoutTapped
        case withdrawTapped
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .none
            case .identityVerificationTapped:
                return .none
            case .logoutTapped:
                return .none
            case .withdrawTapped:
                return .none
            }
        }
    }
}
