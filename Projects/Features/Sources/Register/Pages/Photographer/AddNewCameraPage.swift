//
//  AddNewCameraPage.swift
//  Features
//
//  Created by 임영택 on 3/3/26.
//

import SwiftUI

struct AddNewCameraPage: View {
  @State private var selectedBrand: String?
  @State private var selectedType: String?
  @State private var selectedModel: String = ""
  @FocusState private var focusToModelInput: Bool

  // MARK: - Spacings
  let topSpacing: CGFloat = 16
  let subtitleBottomSpacing: CGFloat = 10
  let sectionSpacing: CGFloat = 30

  var body: some View {
    VStack(spacing: 0) {
      Text("브랜드")
        .typo(.pSmallTitle)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.bottom, subtitleBottomSpacing)

      // TODO: 옵션 리스트
      SelectEquipmentOptionButton(
        placeholder: "선택",
        options: [
          "소니",
          "캐논",
          "니콘",
          "후지필름",
          "파나소닉",
          "라이카",
          "올림푸스",
        ],
        selectedOption: $selectedBrand
      )
      .allowManualInput()
      .padding(.bottom, sectionSpacing)

      Text("카메라 종류")
        .typo(.pSmallTitle)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.bottom, subtitleBottomSpacing)

      // TODO: 옵션 리스트
      SelectEquipmentOptionButton(
        placeholder: "선택",
        options: PhotographerEquipment.EquipmentType.CameraType.allCases.map({ $0.displayName }),
        selectedOption: $selectedType
      )
      .disabled(selectedBrand == nil)
      .padding(.bottom, 30)
      
      Text("모델명")
        .typo(.pSmallTitle)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.bottom, subtitleBottomSpacing)

      // TODO: 옵션 리스트
      TextField(
        "상세 모델명을 입력해주세요 (ex, A0000)",
        text: $selectedModel,
        prompt: Text("상세 모델명을 입력해주세요 (ex, A0000)").foregroundStyle(.pGrey3)
      )
      .pTextField(isFocused: focusToModelInput)
      .focused($focusToModelInput)

      Spacer()

      Button1(title: "추가하기") {

      }
      .disabled(selectedBrand == nil || selectedType == nil || selectedModel.isEmpty)
    }
    .padding(.horizontal)
    .padding(.top, topSpacing)
  }
}

extension PhotographerEquipment.EquipmentType.CameraType {
  var displayName: String {
    switch self {
    case .campactCamera:
      "디지털 카메라"
    case .mirrorlessCamera:
      "미러리스 카메라"
    case .dslrCamera:
      "DSLR 카메라"
    case .filmCamera:
      "필름 카메라"
    }
  }
}

#Preview {
  AddNewCameraPage()
}
