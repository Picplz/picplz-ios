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
        case navigateToSearch                    // 촬영지 검색으로 이동
        case followedArtistsTapped               // 팔로우 작가
        case myReviewsTapped                     // 내 리뷰
        case termsOfServiceTapped                // 이용 약관
        case settingsTapped                      // 설정
        case pastShootingsTapped                  // 지난 촬영 내역
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
            case .navigateToSearch:
                return .none
            case .followedArtistsTapped:
                return .none
            case .myReviewsTapped:
                return .none
            case .termsOfServiceTapped:
                return .none
            case .settingsTapped:
                return .none
            case .pastShootingsTapped:
                return .none
            }
        }
    }
}
