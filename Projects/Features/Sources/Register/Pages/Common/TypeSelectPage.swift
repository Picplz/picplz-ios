//
//  TypeSelectPage.swift
//  Features
//
//  Created by 임영택 on 3/2/26.
//
import Domain
import SwiftUI

struct TypeSelectPage: View {
  @State var selectedRole: Role?

  // MARK: - Spacings
  let titleTopSpacing: CGFloat = 66
  var titleBottomSpacing: CGFloat = 38
  let buttonsSpacing: CGFloat = 21

  var body: some View {
    VStack {
      Spacer()
        .frame(height: titleTopSpacing)
      Text("가입하실 회원 타입을\n선택해주세요.")
        .typo(.pTitle)
        .multilineTextAlignment(.center)
      Spacer()
        .frame(height: titleBottomSpacing)
      HStack(alignment: .bottom, spacing: buttonsSpacing) {
        TypeSelectButton(role: .photographer, selectedRole: $selectedRole)
        TypeSelectButton(role: .model, selectedRole: $selectedRole)
      }
      
      Spacer()
      
      Button1(title: "다음") {
        //
      }
      .disabled(selectedRole == nil)
    }
    .padding(.horizontal)
  }
}

#Preview {
  TypeSelectPage()
}
