//
//  NoticeDetailView.swift
//  Features
//
//  Created by giwan jo on 7/14/26.
//

import SwiftUI
import ComposableArchitecture

struct NoticeDetailView: View {
    let store: StoreOf<NoticeDetailFeature>

    var body: some View {
        VStack(spacing: 0) {
            SubNavigationBar(title: "공지사항") {
                store.send(.backButtonTapped)
            }
            .padding(.horizontal, 16)

            PicWebView(url: store.url)
        }
        .background(.pWhite)
        .navigationBarHidden(true)
    }
}

#Preview {
    NoticeDetailView(
        store: Store(initialState: NoticeDetailFeature.State()) {
            NoticeDetailFeature()
        }
    )
}
