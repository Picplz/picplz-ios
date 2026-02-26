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
  @Bindable var store: StoreOf<MainFeature>

  public init(store: StoreOf<MainFeature>) {
    self.store = store
  }

  public var body: some View {
    Group {
      if store.isLogin {
        Text("Main View")
      } else {
        OnboardingView { signInProvider in
          store.send(.loginStart(provider: signInProvider))
        }
      }
    }
    .alert($store.scope(state: \.alert, action: \.alert))
  }
}

#Preview {
  MainView(
    store: Store(initialState: MainFeature.State()) {
      MainFeature()
    }
  )
}
