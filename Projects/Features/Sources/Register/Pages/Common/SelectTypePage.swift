//
//  SelectTypePage.swift
//  Features
//
//  Created by 임영택 on 3/2/26.
//

import ComposableArchitecture
import Domain
import SwiftUI

struct SelectTypePage: View {
  @Bindable var store: StoreOf<SelectTypeFeature>

  // MARK: - Spacings
  let titleTopSpacing: CGFloat = 66
  var titleBottomSpacing: CGFloat = 38
  let buttonsSpacing: CGFloat = 21

  var body: some View {
    VStack {
      Spacer()
        .frame(height: titleTopSpacing)
      Text("가입하실 회원 타입을\n선택해주세요.")
        .typo(.pTitle)
        .multilineTextAlignment(.center)
      Spacer()
        .frame(height: titleBottomSpacing)
      HStack(alignment: .bottom, spacing: buttonsSpacing) {
        TypeSelectButton(role: .photographer, selectedRole: $store.selectedRole.sending(\.roleChanged))
        TypeSelectButton(role: .customer, selectedRole: $store.selectedRole.sending(\.roleChanged))
      }
      
      Spacer()
      
      Button1(title: "다음") {
        store.send(.nextButtonTapped)
      }
      .disabled(store.selectedRole == nil)
    }
    .padding(.horizontal)
    .navigationTitle("회원 타입 선택")
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  SelectTypePage(store: Store(initialState: SelectTypeFeature.State()) {
    SelectTypeFeature()
      ._printChanges()
  })
}
