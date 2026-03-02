//
//  Button1.swift
//  Features
//
//  Created by 임영택 on 3/2/26.
//

import SwiftUI

struct Button1: View {
  var title: String
  var isActive: Bool = true
  let action: () -> Void
  
  var backgroundColor: Color {
    isActive ? Self.activeBackgroundColor : Self.inactiveBackgroundColor
  }
  var labelColor: Color {
    isActive ? Self.activeLabelColor : Self.inactiveLabelColor
  }
  
  var body: some View {
    Button {
      //
    } label: {
      RoundedRectangle(cornerRadius: 5, style: .circular)
        .foregroundStyle(backgroundColor)
        .frame(height: Self.height)
        .overlay {
          Text(title)
            .typo(.pButtonNormalLabel)
            .foregroundStyle(labelColor)
        }
    }
    .disabled(!isActive)
  }
}

extension Button1 {
  func disabled(_ isDisabled: Bool) -> Self {
    var copy = self
    copy.isActive = !isDisabled
    return copy
  }
}

extension Button1 {
  static let activeBackgroundColor = Color.pBlack
  static let inactiveBackgroundColor = Color.pGrey3
  static let activeLabelColor = Color.pGrey2
  static let inactiveLabelColor = Color.pWhite
  
  static let height = CGFloat(50)
}

#Preview {
  VStack {
    Text("버튼 1")
      .typo(.pBigTitle)
    Spacer()
      .frame(height: 60)
    
    Button1(title: "안녕, 세계") {
      //
    }
    Button1(title: "잘가, 세계") {
      //
    }
    .disabled(true)
    
    Spacer()
  }
  .padding()
}
