//
//  SettingsFeature.swift
//  Features
//
//  Created by wonsik on 4/2/26.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct SettingsFeature {
    @ObservableState
    public struct State: Equatable, Hashable {
        var appVersion: String = "1.0.0"
        var isLatestVersion: Bool = true
    }
    
    public enum Action {
        case backButtonTapped
        case notificationSettingTapped
        case accountManagementTapped
        case authorApplicationTapped
        case inquiryTapped
        case noticeTapped
        case termsAndPoliciesTapped
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .none
            case .notificationSettingTapped:
                return .none
            case .accountManagementTapped:
                return .none
            case .authorApplicationTapped:
                return .none
            case .inquiryTapped:
                return .none
            case .noticeTapped:
                return .none
            case .termsAndPoliciesTapped:
                return .none
            }
        }
    }
}
