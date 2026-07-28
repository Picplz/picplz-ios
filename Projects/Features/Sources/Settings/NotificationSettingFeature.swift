//
//  NotificationSettingFeature.swift
//  Features
//
//  Created by giwanjo on 7/9/26.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct NotificationSettingFeature {
    @ObservableState
    public struct State: Equatable, Hashable {
        // MARK: - 서비스 알림
        var shootingNotificationEnabled: Bool = true   // 촬영 내역 알림
        var chatNotificationEnabled: Bool = true       // 채팅 알림
        
        // MARK: - 마케팅 알림
        var marketingAllEnabled: Bool = false          // 전체 알림 받기
        var marketingPushEnabled: Bool = false         // 푸시 알림
        var marketingSMSEnabled: Bool = false          // SMS
        
        public init() {}
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case backButtonTapped
        case marketingTermsTapped   // 약관 보기
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.marketingAllEnabled):
                if !state.marketingAllEnabled {
                    state.marketingPushEnabled = false
                    state.marketingSMSEnabled = false
                }
                return .none
                
            case .binding:
                return .none
                
            case .backButtonTapped:
                return .none
                
            case .marketingTermsTapped:
                return .none
            }
        }
    }
}
