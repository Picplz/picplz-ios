//
//  RegisterView.swift
//  Features
//
//  Created by 임영택 on 2/28/26.
//

import ComposableArchitecture
import SwiftUI

struct RegisterView: View {
  @Bindable var store: StoreOf<RegisterFeature>
  
  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      SelectTypePage(store: store.scope(state: \.selectType, action: \.selectType))
    } destination: { store in
      switch store.state {
      case .inputNickname:
        if let store = store.scope(state: \.inputNickname, action: \.inputNickname) {
          InputNicknamePage(store: store)
        }
      case .uploadProfileImage:
        if let store = store.scope(state: \.uploadProfileImage, action: \.uploadProfileImage) {
          UploadProfilePhotoPage(store: store)
        }
      }
    }
  }
}

#Preview {
  RegisterView(
    store: Store(initialState: RegisterFeature.State()) {
      RegisterFeature()
        ._printChanges()
    }
  )
}
