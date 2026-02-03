//
//  AppView.swift
//  PicplzApp
//
//  Created by 임영택 on 2/3/26.
//

import SwiftUI
import ComposableArchitecture
import Features

struct AppView: View {
  let store: StoreOf<AppFeature>
  
  var body: some View {
    switch store.state {
    case .splash:
      if let splashStore = store.scope(state: \.splash, action: \.splash) {
        SplashView(store: splashStore)
      }
    case .main:
      if let mainStore = store.scope(state: \.main, action: \.main) {
        MainView(store: mainStore)
      }
    }
  }
}

#Preview {
  AppView(store: Store(initialState: AppFeature.State()) {
    AppFeature()
  })
}
