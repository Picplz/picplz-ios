//
//  AddNewPhonePage.swift
//  Features
//
//  Created by 임영택 on 3/3/26.
//

import SwiftUI
import ComposableArchitecture

struct AddNewPhonePage: View {
  @Bindable var store: StoreOf<AddNewPhoneFeature>

  // MARK: - Spacings
  let topSpacing: CGFloat = 16
  let subtitleBottomSpacing: CGFloat = 10
  let sectionSpacing: CGFloat = 30
  
  var phoneBrands: [String] {
    Array(Set(store.defaultEquipments.filter { $0.type == .phone }.map { $0.brand })).sorted()
  }
  
  var phoneModels: [String] {
    Array(Set(store.defaultEquipments.filter { $0.type == .phone && $0.brand == store.selectedBrand }.compactMap { $0.name })).sorted()
  }

  var body: some View {
    VStack(spacing: 0) {
      Text("브랜드")
        .typo(.pSmallTitle)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.bottom, subtitleBottomSpacing)

      SelectEquipmentOptionButton(
        placeholder: "선택",
        options: phoneBrands,
        selectedOption: $store.selectedBrand.sending(\.brandSelected)
      )
      .padding(.bottom, sectionSpacing)

      Text("모델명")
        .typo(.pSmallTitle)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.bottom, subtitleBottomSpacing)

      SelectEquipmentOptionButton(
        placeholder: "선택",
        options: phoneModels,
        selectedOption: $store.selectedModel.sending(\.modelSelected)
      )
      .allowManualInput()
      .disabled(store.selectedBrand == nil)
      .padding(.bottom, 30)

      Spacer()

      Button1(title: "추가하기") {
        store.send(.addButtonTapped)
      }
      .disabled(store.selectedBrand == nil || store.selectedModel == nil)
    }
    .padding(.horizontal)
    .padding(.top, topSpacing)
    .navigationTitle("핸드폰 추가")
    .navigationBarTitleDisplayMode(.inline)
    .onAppear {
      store.send(.onAppear)
    }
  }
}

#Preview {
  AddNewPhonePage(
    store: Store(initialState: AddNewPhoneFeature.State()) {
      AddNewPhoneFeature()
    }
  )
}
