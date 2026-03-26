//
//  MyPageView.swift
//  Features
//
//  Created by wonsik on 3/26/26.
//

import SwiftUI
import ComposableArchitecture

struct MyPageView: View {
    let store: StoreOf<MyPageFeature>
    
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
        }
        // 기존 네비바 숨김
        .navigationBarHidden(true)
        .padding(.horizontal, 16)
    }
}

#Preview {
    MyPageView(
        store: Store(
            initialState: MyPageFeature.State()
        ) {
            MyPageFeature()
        }
    )
}
