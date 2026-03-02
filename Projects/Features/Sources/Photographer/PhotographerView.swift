//
//  PhotographerView.swift
//  Features
//
//  Created by 임영택 on 2/28/26.
//

import SwiftUI
import ComposableArchitecture

struct PhotographerView: View {
  let store: StoreOf<PhotographerFeature>
  
  var body: some View {
    Text("PhotographerView")
  }
}

#Preview {
  PhotographerView(
    store: Store(initialState: PhotographerFeature.State()) {
      PhotographerFeature()
    }
  )
}
