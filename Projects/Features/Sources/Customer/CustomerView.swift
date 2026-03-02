//
//  CustomerView.swift
//  Features
//
//  Created by 임영택 on 2/28/26.
//

import SwiftUI
import ComposableArchitecture

struct CustomerView: View {
  let store: StoreOf<CustomerFeature>
  
  var body: some View {
    Text("CustomerView")
  }
}

#Preview {
  CustomerView(
    store: Store(initialState: CustomerFeature.State()) {
      CustomerFeature()
    }
  )
}
