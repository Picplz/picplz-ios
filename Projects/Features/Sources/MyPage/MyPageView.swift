//
//  MyPageView.swift
//  Features
//
//  Created by wonsik on 3/26/26.
//

import SwiftUI
import ComposableArchitecture

struct MyPageView: View {
    @Bindable var store: StoreOf<MyPageFeature>
    
    var body: some View {
        VStack {
            // 네비게이션 바
            HStack {
                Text("마이 페이지")
                    .typo(.pBoldParagraph)
                Spacer()
                Button {
                    // TODO: 설정 화면 이동
                } label: {
                    Image(.settings)
                }
            }
            .padding(.horizontal, 16)
            
            // 작가 변경 바
            Group {
                  if store.hasPhotographerInfo {
                      HStack {
                          Text("작가로 전환")
                              .typo(.pBoldParagraph)
                              .foregroundStyle(Color(.white))
                          Spacer()
                          Toggle("", isOn: $store.isPhotographerMode.sending(\.togglePhotographerMode))
                              .labelsHidden()
                              .toggleStyle(PicToggleStyle())
                      }
                      .padding(.horizontal, 16)
                  } else {
                      HStack {
                          Text("작가로도 활동하기")
                              .typo(.pBoldParagraph)
                              .foregroundStyle(Color(.white))
                          Spacer()
                          Button {
                              store.send(.navigateToPhotographerRegister)
                          } label: {
                              Image(.goPhotographer)
                          }
                      }
                      .padding(.horizontal, 16)
                  }
              }
              .frame(height: 50)
              .background(Color(.pGreen120))

            // 프로필 섹션
            HStack(spacing: 8) {
                Image(.profileImagePlaceholder)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())

                Text(store.nickname)
                    .typo(.pBigParagraph)

                Spacer()

                Button {
                    store.send(.profileEditTapped)
                } label: {
                    Text("프로필 수정")
                        .typo(.pCaption)
                        .foregroundStyle(Color(.pGrey4))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color(.pGrey3), lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        // 기존 네비바 숨김
        .navigationBarHidden(true)
    }
}

#Preview {
    MyPageView(
        store: Store(
            initialState: MyPageFeature.State(
                hasPhotographerInfo: true,
                nickname: "양원식"
            )
        ) {
            MyPageFeature()
        }
    )
}
