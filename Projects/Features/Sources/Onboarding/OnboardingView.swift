//
//  OnboardingView.swift
//  Features
//
//  Created by 임영택 on 2/28/26.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingView: View {
  @Bindable var store: StoreOf<OnboardingFeature>
  
  var body: some View {
    OnboardingPages { provider in
      store.send(.loginStart(provider: provider))
    }
    .alert($store.scope(state: \.alert, action: \.alert))
  }
}

#Preview {
  OnboardingView(
    store: Store(initialState: OnboardingFeature.State()) {
      OnboardingFeature()
    }
  )
}
