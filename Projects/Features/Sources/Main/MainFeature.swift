//
//  MainFeature.swift
//  Features
//
//  Created by 임영택 on 2/3/26.
//

import Common
import ComposableArchitecture
import Domain

@Reducer
public struct MainFeature {
  @ObservableState
  public enum State: Equatable {
    case onboarding(OnboardingFeature.State)
    case register(RegisterFeature.State)
    case customer(CustomerFeature.State)
    case photographer(PhotographerFeature.State)
    
    public init() {
      self = .onboarding(OnboardingFeature.State())
    }
  }

  public enum Action: Hashable {
    case onboarding(OnboardingFeature.Action)
    case register(RegisterFeature.Action)
    case customer(CustomerFeature.Action)
    case photographer(PhotographerFeature.Action)
    
    public enum Alert: Hashable {
    }
  }

  public enum LoginProvider {
    case kakao
    case apple
  }

  public init() {}

  public var body: some ReducerOf<MainFeature> {
    Reduce { state, action in
      switch action {
      case let .onboarding(.delegate(.loginCompleted(loginType))):
        switch loginType {
        case .customer:
          state = .customer(CustomerFeature.State())
        case .photographer:
          state = .photographer(PhotographerFeature.State())
        case .notRegistered:
          state = .register(RegisterFeature.State())
        }
        return .none
      case .onboarding:
        return .none
      case .register:
        return .none
      case .customer:
        return .none
      case .photographer:
        return .none
      }
    }
    .ifCaseLet(\.onboarding, action: \.onboarding) {
      OnboardingFeature()
    }
    .ifCaseLet(\.register, action: \.register) {
      RegisterFeature()
    }
    .ifCaseLet(\.customer, action: \.customer) {
      CustomerFeature()
    }
    .ifCaseLet(\.photographer, action: \.photographer) {
      PhotographerFeature()
    }
  }
}
