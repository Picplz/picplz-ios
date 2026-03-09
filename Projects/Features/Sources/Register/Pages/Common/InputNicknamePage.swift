//
//  InputNicknamePage.swift
//  Features
//
//  Created by 임영택 on 3/2/26.
//

import ComposableArchitecture
import Domain
import SwiftUI
import Dependencies

struct InputNicknamePage: View {
  @Bindable var store: StoreOf<InputNicknameFeature>

  // MARK: - Spacings
  let titleTopSpacing: CGFloat = 144
  let titleBottomSpacing: CGFloat = 12
  var textFieldVerticalPadding: CGFloat = 8
  var validationRuleTopSpacing: CGFloat = 6
  var errorMessageTopSpacing: CGFloat = 14
  
  var body: some View {
    VStack(spacing: 0) {
      Text("닉네임을 입력해주세요")
        .typo(.pTitle)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, titleTopSpacing)
        .padding(.bottom, titleBottomSpacing)
      
      TextField(
        "닉네임 입력",
        text: $store.inputNickname.sending(\.textChanged),
        prompt: Text("닉네임 입력").foregroundStyle(.pGrey3)
      )
      .pTextField()
      .padding(.vertical, textFieldVerticalPadding)

      if !store.isValid {
        Text(store.errorMessage)
          .typo(.pCaption)
          .padding(.vertical, 4)
          .foregroundStyle(.pRed)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      
      Text("""
           ·  한글, 영문, 숫자만 입력 가능 (2~15자)
           ·  중복 닉네임은 불가
           ·  공백 사용 불가
        """)
      .typo(.pCaption)
      .foregroundStyle(.pGrey3)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.top, validationRuleTopSpacing)

      Spacer()

      Button1(title: "다음") {
        store.send(.nextButtonTapped)
      }
      .disabled(store.inputNickname.isEmpty || !store.isValid)
    }
    .padding(.horizontal)
    .navigationTitle("닉네임 설정")
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  struct PreviewMembersRepository: MembersRepositoryProtocol {
    func checkAllowable(nickname: String) async throws -> IsAllowableNickname {
      if nickname == "TEST" {
        return false
      }
      
      if nickname == "SERVERERROR" {
        throw NSError(domain: "", code: -1)
      }
      return true
    }
  }
  MembersRepositoryKey.liveValue = PreviewMembersRepository()
  
  return InputNicknamePage(
    store: Store(
      initialState: InputNicknameFeature.State(),
      reducer: {
        InputNicknameFeature()
          ._printChanges()
      }
    )
  )
}
