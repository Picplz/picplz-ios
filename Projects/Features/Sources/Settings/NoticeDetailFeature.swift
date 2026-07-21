//
//  NoticeDetailFeature.swift
//  Features
//
//  Created by giwan jo on 7/14/26.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct NoticeDetailFeature {
    @ObservableState
    public struct State: Equatable, Hashable {
        // TODO: 실제 공지사항 페이지 URL로 교체
        var url: URL = URL(string: "https://www.naver.com")!
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
