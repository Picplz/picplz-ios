//
//  AddNewPhonePage.swift
//  Features
//
//  Created by 임영택 on 3/3/26.
//

import SwiftUI

struct AddNewPhonePage: View {
  @State private var selectedBrand: String?
  @State private var selectedModel: String?

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
          "애플",
          "삼성",
        ],
        selectedOption: $selectedBrand
      )
      .padding(.bottom, sectionSpacing)

      Text("모델명")
        .typo(.pSmallTitle)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.bottom, subtitleBottomSpacing)

      // TODO: 옵션 리스트
      SelectEquipmentOptionButton(
        placeholder: "선택",
        options: [
          "아이폰 17 Pro Max",
          "아이폰 17 Pro",
          "아이폰 17",
        ],
        selectedOption: $selectedModel
      )
      .allowManualInput()
      .disabled(selectedBrand == nil)
      .padding(.bottom, 30)

      Spacer()

      Button1(title: "추가하기") {

      }
      .disabled(selectedBrand == nil || selectedModel == nil)
    }
    .padding(.horizontal)
    .padding(.top, topSpacing)
  }
}

#Preview {
  AddNewPhonePage()
}
