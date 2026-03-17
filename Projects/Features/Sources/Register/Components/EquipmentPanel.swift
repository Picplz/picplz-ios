//
//  EquipmentPanel.swift
//  Features
//
//  Created by 임영택 on 3/7/26.
//

import SwiftUI
import Domain

extension InputEquipmentsPage {
  struct EquipmentPanel: View {
    var equipment: PhotographerEquipment
    let didDeleteButtonTap: () -> Void

    let backgroundColor = Color.pGrey1
    let labelColor = Color.pBlack
    let borderColor = Color.pBlack
    let height = CGFloat(42)

    var body: some View {
      RoundedRectangle(cornerRadius: 5, style: .circular)
        .fill(backgroundColor)
        .stroke(borderColor, lineWidth: 1)
        .frame(height: height)
        .overlay {
          HStack(spacing: 10) {
            Text(equipment.brand)
              .typo(.pParagraph)
              .foregroundStyle(.pGrey4)
            Text(equipment.name ?? "알 수 없음")
              .typo(.pBoldParagraph)
              .foregroundStyle(.pGrey5)
            Spacer()
            Button(action: didDeleteButtonTap) {
              Image(.xCircle)
            }
          }
          .padding(.horizontal, 15)
        }

    }
  }
}

#Preview {
  VStack {
    Text("촬영 기기 정보")
      .typo(.pBigTitle)
    Spacer()
      .frame(height: 60)

    InputEquipmentsPage.EquipmentPanel(
      equipment: PhotographerEquipment(
        type: .phone,
        brand: "애플",
        name: "iPhone 17 Pro Max"
      )
    ) {
      //
    }

    Spacer()
  }
  .padding()
}
