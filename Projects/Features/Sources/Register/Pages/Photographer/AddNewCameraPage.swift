//
//  AddNewCameraPage.swift
//  Features
//
//  Created by 임영택 on 3/3/26.
//

import SwiftUI
import Domain
import ComposableArchitecture

struct AddNewCameraPage: View {
  @Bindable var store: StoreOf<AddNewCameraFeature>
  @FocusState private var focusToModelInput: Bool

  // MARK: - Spacings
  let topSpacing: CGFloat = 16
  let subtitleBottomSpacing: CGFloat = 10
  let sectionSpacing: CGFloat = 30
  
  var cameraBrands: [String] {
    Array(Set(store.defaultEquipments.compactMap { equipment -> String? in
      if case .camera = equipment.type { return equipment.brand }
      return nil
    })).sorted()
  }

  var body: some View {
    VStack(spacing: 0) {
      Text("브랜드")
        .typo(.pSmallTitle)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.bottom, subtitleBottomSpacing)

      SelectEquipmentOptionButton(
        placeholder: "선택",
        options: cameraBrands,
        selectedOption: $store.selectedBrand.sending(\.brandSelected)
      )
      .allowManualInput()
      .padding(.bottom, sectionSpacing)

      Text("카메라 종류")
        .typo(.pSmallTitle)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.bottom, subtitleBottomSpacing)

      SelectEquipmentOptionButton(
        placeholder: "선택",
        options: PhotographerEquipment.EquipmentType.CameraType.allCases.filter { $0 != .unknown }.map({ $0.displayName }),
        selectedOption: $store.selectedTypeDisplayName.sending(\.typeSelected)
      )
      .disabled(store.selectedBrand == nil)
      .padding(.bottom, 30)
      
      Text("모델명")
        .typo(.pSmallTitle)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.bottom, subtitleBottomSpacing)

      TextField(
        "상세 모델명을 입력해주세요 (ex, A0000)",
        text: $store.selectedModel.sending(\.modelChanged),
        prompt: Text("상세 모델명을 입력해주세요 (ex, A0000)").foregroundStyle(.pGrey3)
      )
      .pTextField(isFocused: focusToModelInput)
      .focused($focusToModelInput)

      Spacer()

      Button1(title: "추가하기") {
        store.send(.addButtonTapped)
      }
      .disabled(store.selectedBrand == nil || store.selectedTypeDisplayName == nil || store.selectedModel.isEmpty)
    }
    .background(Color.pWhite)
    .onTapGesture {
      focusToModelInput = false
    }
    .padding(.horizontal)
    .padding(.top, topSpacing)
    .navigationTitle("카메라 추가")
    .navigationBarTitleDisplayMode(.inline)
    .onAppear {
      store.send(.onAppear)
    }
  }
}

#Preview {
  AddNewCameraPage(
    store: Store(initialState: AddNewCameraFeature.State()) {
      AddNewCameraFeature()
    }
  )
}
