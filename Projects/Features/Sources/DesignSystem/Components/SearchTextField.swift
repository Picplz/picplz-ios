//
//  SearchTextField.swift
//  Features
//
//  Created by 임영택 on 3/2/26.
//

import SwiftUI

struct SearchTextFieldModifier: ViewModifier {
  let submitButtonTapped: () -> Void
  
  func body(content: Content) -> some View {
    HStack(spacing: 0) {
      content
        .typo(.pParagraph)

      Button(action: submitButtonTapped) {
        Image(.search)
          .padding(1)
      }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 10)
    .background(.pWhite)
    .cornerRadius(50)
    .overlay(
      RoundedRectangle(cornerRadius: 50)
        .inset(by: 0.5)
        .stroke(.pGrey6, lineWidth: 1)
    )
  }
}

extension View {
  func pSearchTextField(submitButtonTapped: @escaping () -> Void) -> some View {
    modifier(SearchTextFieldModifier(submitButtonTapped: submitButtonTapped))
  }
}

#Preview {
  @Previewable @State var query = ""

  VStack {
    TextField(
      "검색하기",
      text: $query,
      prompt: Text("검색하기").foregroundStyle(.pGrey3)
    )
    .pSearchTextField {
      print(query)
    }
  }
  .padding()
}
