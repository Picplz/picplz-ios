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
        }
        // 기존 네비바 숨김
        .navigationBarHidden(true)
    }
}

#Preview {
    MyPageView(
        store: Store(
            initialState: MyPageFeature.State(hasPhotographerInfo: true)
        ) {
            MyPageFeature()
        }
    )
}
