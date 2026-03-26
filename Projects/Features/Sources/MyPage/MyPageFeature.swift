//
//  MyPageFeature.swift
//  Features
//
//  Created by wonsik on 3/26/26.
//

import ComposableArchitecture
import Domain
import Foundation

@Reducer
public struct MyPageFeature {
    @ObservableState
    public struct State: Equatable {
        var hasPhotographerInfo: Bool = false  // 작가 정보 존재 여부
        var isPhotographerMode: Bool = false   // 작가 모드 토글 상태
        var nickname: String = ""
        var profileImageURL: String? = nil

        public init(
            hasPhotographerInfo: Bool = false,
            nickname: String = ""
        ) {
            self.hasPhotographerInfo = hasPhotographerInfo
            self.nickname = nickname
        }
    }
    
    public enum Action: Hashable {
        case togglePhotographerMode(Bool)       // 토글 변경
        case navigateToPhotographerRegister     // 작가로도 활동하기 탭
        case profileEditTapped                  // 프로필 수정 탭
    }
    
    public init() { }
    
    public var body: some ReducerOf<MyPageFeature> {
        Reduce { state, action in
            switch action {
            case let .togglePhotographerMode(isOn):
                state.isPhotographerMode = isOn
                return .none
            case .navigateToPhotographerRegister:
                return .none
            case .profileEditTapped:
                return .none
            }
        }
    }
}
