//
//  PTextField.swift
//  Features
//
//  Created by 임영택 on 3/2/26.
//

import SwiftUI

struct PTextFieldModifier: ViewModifier {
  let isFocused: Bool

  func body(content: Content) -> some View {
    content
      .typo(.pParagraph)
      .foregroundStyle(.pBlack)
      .padding(.horizontal)
      .frame(height: 42)
      .background(
        RoundedRectangle(cornerRadius: 5)
          .stroke(isFocused ? .pBlack : .pGrey2, lineWidth: 1)
          .fill(.pGrey1)
      )
  }
}

extension View {
  func pTextField(isFocused: Bool = false) -> some View {
    modifier(PTextFieldModifier(isFocused: isFocused))
  }
}

#Preview {
  struct PreviewContainer: View {
    @State var username = ""
    @State var nickname = ""
    @FocusState var focusedField: Field?
    
    enum Field {
      case username
      case password
    }

    var body: some View {
      VStack {
        TextField(
          "아이디",
          text: $username,
          prompt: Text("아이디").foregroundStyle(.pGrey3)
        )
        .pTextField(isFocused: focusedField == .username)
        .focused($focusedField, equals: .username)

        TextField(
          "닉네임",
          text: $nickname,
          prompt: Text("닉네임").foregroundStyle(.pGrey3)
        )
        .pTextField(isFocused: focusedField == .password)
        .focused($focusedField, equals: .password)
        Text(username)
        Text(nickname)
      }
      .onTapGesture {
        focusedField = nil
      }
      .padding()
    }
  }
  
  return PreviewContainer()
}
