//
//  SplashView.swift
//  Features
//
//  Created by 임영택 on 1/20/26.
//

import SwiftUI
import ComposableArchitecture

public struct SplashView: View {
  let store: StoreOf<SplashFeature>
  
  public init(store: StoreOf<SplashFeature>) {
    self.store = store
  }
  
  public var body: some View {
    VStack {
      Image(.splash)
    }
    .onAppear {
      store.send(.onAppear)
    }
  }
}

#Preview {
  SplashView(store: Store(initialState: SplashFeature.State()) {
    SplashFeature()
  })
}
