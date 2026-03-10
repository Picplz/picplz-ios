//
//  RegisterFinishedPage.swift
//  Features
//
//  Created by 임영택 on 3/2/26.
//

import ComposableArchitecture
import Domain
import PhotosUI
import SwiftUI

struct RegisterFinishedPage: View {
  let store: StoreOf<RegisterFinishedFeature>

  // MARK: - Spacings
  let titleTopSpacing: CGFloat = 66
  let titleBottomSpacing: CGFloat = 30

  var body: some View {
    VStack(spacing: 0) {
      Text("안녕하세요 \(store.userNickname)님!")
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
        store.send(.nextButtonTapped)
      }
    }
    .padding(.horizontal)
  }
}

#Preview {
  RegisterFinishedPage(
    store: Store(
      initialState: RegisterFinishedFeature.State(userNickname: "유가영"),
      reducer: {
        RegisterFinishedFeature()
      }
    )
  )
}
