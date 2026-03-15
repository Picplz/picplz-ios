//
//  RegisterView.swift
//  Features
//
//  Created by 임영택 on 2/28/26.
//

import ComposableArchitecture
import Domain
import SwiftUI

struct RegisterView: View {
  @Bindable var store: StoreOf<RegisterFeature>

  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      if store.registerFinished == nil {
        SelectTypePage(
          store: store.scope(state: \.selectType, action: \.selectType)
        )
      } else if let store = store.scope(
        state: \.registerFinished,
        action: \.registerFinished
      ) {
        RegisterFinishedPage(store: store)
      }
    } destination: { store in
      switch store.state {
      case .inputNickname:
        if let store = store.scope(
          state: \.inputNickname,
          action: \.inputNickname
        ) {
          InputNicknamePage(store: store)
        }
      case .uploadProfileImage:
        if let store = store.scope(
          state: \.uploadProfileImage,
          action: \.uploadProfileImage
        ) {
          UploadProfilePhotoPage(store: store)
        }
      case .requestLocationPermission:
        if let store = store.scope(
          state: \.requestLocationPermission,
          action: \.requestLocationPermission
        ) {
          RequestLocationPermissionPage(store: store)
        }
      }
    }
    .toast(item: $store.toastItem.sending(\.toastItemChanged))
  }
}

#Preview {
  RegisterView(
    store: Store(
      initialState: RegisterFeature.State(
        socialInfo: SocialInfo(
          socialEmail: "abc@def.com",
          socialProvider: .kakao,
          socialCode: ""
        )
      )
    ) {
      RegisterFeature()
        ._printChanges()
    }
  )
}
