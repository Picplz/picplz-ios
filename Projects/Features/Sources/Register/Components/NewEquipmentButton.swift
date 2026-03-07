//
//  NewEquipmentButton.swift
//  Features
//
//  Created by 임영택 on 3/7/26.
//

import SwiftUI

extension InputEquipmentsPage {
  struct NewEquipmentButton: View {
    let placeholder: String
    let didNewButtonTap: () -> Void
    
    let backgroundColor = Color.pWhite
    let labelColor = Color.pGrey5
    let borderColor = Color.pGrey3
    let height = CGFloat(42)
    
    var body: some View {
      Button(action: didNewButtonTap) {
        RoundedRectangle(cornerRadius: 5, style: .circular)
          .fill(backgroundColor)
          .stroke(borderColor, lineWidth: 1)
          .frame(height: height)
          .overlay {
            Text(placeholder)
              .typo(.pParagraph)
              .foregroundStyle(labelColor)
          }
      }
    }
  }
}

#Preview {
  InputEquipmentsPage.NewEquipmentButton(placeholder: "추가하기 +") {
    //
  }
  .padding()
}
