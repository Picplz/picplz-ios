//
//  TermsFeature.swift
//  Features
//
//  Created by giwan jo on 7/14/26.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct TermsFeature {
    public enum TermsItem: Equatable, Hashable, CaseIterable {
        case serviceTerms
        case privacyPolicy
        case locationServiceTerms
        
        var title: String {
            switch self {
            case .serviceTerms: return "서비스 이용약관"
            case .privacyPolicy: return "개인정보 처리방침"
            case .locationServiceTerms: return "위치기반 서비스 이용약관"
            }
        }
        
        // TODO: 실제 약관 페이지 URL로 교체
        var url: URL {
            switch self {
            case .serviceTerms: return URL(string: "https://www.naver.com")!
            case .privacyPolicy: return URL(string: "https://www.google.com")!
            case .locationServiceTerms: return URL(string: "https://www.youtube.com")!
            }
        }
    }
    
    @ObservableState
    public struct State: Equatable, Hashable {}
    
    public enum Action {
        case backButtonTapped
        case termsRowTapped(TermsItem)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .none
            case .termsRowTapped:
                return .none
            }
        }
    }
}
