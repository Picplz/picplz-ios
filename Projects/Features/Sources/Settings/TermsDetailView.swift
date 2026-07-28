//
//  TermsDetailView.swift
//  Features
//
//  Created by giwan jo on 7/14/26.
//

import SwiftUI
import ComposableArchitecture

struct TermsDetailView: View {
    let store: StoreOf<TermsDetailFeature>

    var body: some View {
        VStack(spacing: 0) {
            SubNavigationBar(title: store.item.title) {
                store.send(.backButtonTapped)
            }
            .padding(.horizontal, 16)

            PicWebView(url: store.item.url)
        }
        .background(.pWhite)
        .navigationBarHidden(true)
    }
}

#Preview {
    TermsDetailView(
        store: Store(initialState: TermsDetailFeature.State(item: .serviceTerms)) {
            TermsDetailFeature()
        }
    )
}
