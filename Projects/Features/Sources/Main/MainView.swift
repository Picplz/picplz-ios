//
//  MainView.swift
//  Features
//
//  Created by 임영택 on 2/3/26.
//

import SwiftUI
import ComposableArchitecture

public struct MainView: View {
  let store: StoreOf<MainFeature>
  
  public init(store: StoreOf<MainFeature>) {
    self.store = store
  }
  
  public var body: some View {
    Text("Main View")
  }
}

#Preview {
  MainView(store: Store(initialState: MainFeature.State()) {
    MainFeature()
  })
}
