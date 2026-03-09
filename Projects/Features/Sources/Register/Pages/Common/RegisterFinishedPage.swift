//
//  RegisterFinishedPage.swift
//  Features
//
//  Created by 임영택 on 3/2/26.
//

import Domain
import PhotosUI
import SwiftUI

struct RegisterFinishedPage: View {
  let userNickname: String

  // MARK: - Spacings
  let titleTopSpacing: CGFloat = 66
  let titleBottomSpacing: CGFloat = 30

  var body: some View {
    VStack(spacing: 0) {
      Text("안녕하세요 \(userNickname)님!")
        .typo(.pTitle)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, titleTopSpacing)
        .padding(.bottom, titleBottomSpacing)

      Image(.registrationCompleted)
      .padding(.bottom, 70)

      Text("가입을 축하드려요.\n함께 사진 촬영하러 가볼까요?")
        .typo(.pTitle)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity, alignment: .center)

      Spacer()

      Button1(title: "시작하기") {
        //
      }
    }
    .padding(.horizontal)
    .navigationTitle("프로필 이미지 업로드")
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  RegisterFinishedPage(userNickname: "유가영")
}
