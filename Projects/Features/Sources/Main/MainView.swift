//
//  MainView.swift
//  Features
//
//  Created by 임영택 on 2/3/26.
//

import ComposableArchitecture
import KakaoSDKUser
import SwiftUI

public struct MainView: View {
  let store: StoreOf<MainFeature>

  public init(store: StoreOf<MainFeature>) {
    self.store = store
  }

  public var body: some View {
    Group {
      switch store.state {
      case .onboarding:
        if let onboardingStore = store.scope(state: \.onboarding, action: \.onboarding) {
          OnboardingView(store: onboardingStore)
        }
      case .register:
        if let registerStore = store.scope(state: \.register, action: \.register) {
          RegisterView(store: registerStore)
        }
      case .customer:
        if let customerStore = store.scope(state: \.customer, action: \.customer) {
          CustomerView(store: customerStore)
        }
      case .photographer:
        if let photographerStore = store.scope(state: \.photographer, action: \.photographer) {
          PhotographerView(store: photographerStore)
        }
      }
    }
  }
}

#Preview {
  MainView(
    store: Store(initialState: MainFeature.State()) {
      MainFeature()
    }
  )
}
