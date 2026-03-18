//
//  AreaTagButton.swift
//  Features
//
//  Created by 임영택 on 3/3/26.
//

import SwiftUI

struct AreaTagButton: View {
  let areaName: String
  let didSelectTap: () -> Void
  let didDeleteTap: () -> Void
  
  var body: some View {
    HStack(alignment: .center, spacing: 8) {
      Text(areaName)
        .typo(.pBoldParagraph)
        .foregroundStyle(.pBlack)
      
      Button(action: didDeleteTap) {
        Image(.xButton)
      }
    }
    .padding(.horizontal, 12)
    .padding(.vertical, 4)
    .background(.pWhite)
    .cornerRadius(5)
    .overlay(
      RoundedRectangle(cornerRadius: 5)
        .inset(by: 0.5)
        .stroke(.pBlack)
    )
    .onTapGesture(perform: didSelectTap)
  }
}

#Preview {
  AreaTagButton(areaName: "서울 서대문구") {
    print("Select")
  } didDeleteTap: {
    print("Delete")
  }
}
