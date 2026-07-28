//
//  InquiryFeature.swift
//  Features
//
//  Created by giwan jo on 7/21/26.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct InquiryFeature {
    @Dependency(\.openURL) var openURL
    
    // TODO: 실제 이메일 주소로 교체
    private static let inquiryEmail = ""
    
    @ObservableState
    public struct State: Equatable, Hashable {}
    
    public enum Action {
        case backButtonTapped
        case emailInquiryTapped
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .none
            case .emailInquiryTapped:
                guard let url = URL(string: "mailto:\(Self.inquiryEmail)") else {
                    return .none
                }
                return .run { _ in
                    await openURL(url)
                }
            }
        }
    }
}
