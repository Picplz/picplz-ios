//
//  ProfileEditFeature.swift
//  Features
//
//  Created by wonsik on 4/2/26.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct ProfileEditFeature {
    @ObservableState
    public struct State: Equatable, Hashable {
        var nickname: String = ""
        public init() {}
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case backButtonTapped
        case profileImageTapped // TODO: 갤러리 연동
        case completeButtonTapped // TODO: 프로필 수정 API 연동
    }

    public init() {}

    public var body: some ReducerOf<ProfileEditFeature> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .backButtonTapped:
                return .none
            case .profileImageTapped:
                // TODO: 갤러리 연동
                return .none
            case .completeButtonTapped:
                // TODO: 프로필 수정 API 연동
                return .none
            }
        }
    }
}
