//
//  RegisterView.swift
//  Features
//
//  Created by 임영택 on 2/28/26.
//

import SwiftUI
import ComposableArchitecture

struct RegisterView: View {
  let store: StoreOf<RegisterFeature>
  
  var body: some View {
    Text("RegisterView")
  }
}

#Preview {
  RegisterView(
    store: Store(initialState: RegisterFeature.State()) {
      RegisterFeature()
    }
  )
}
