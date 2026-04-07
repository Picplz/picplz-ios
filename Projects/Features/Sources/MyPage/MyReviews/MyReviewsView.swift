//
//  MyReviewsView.swift
//  Features
//
//  Created by wonsik on 4/2/26.
//

import SwiftUI
import ComposableArchitecture

struct MyReviewsView: View {
    let store: StoreOf<MyReviewsFeature>

    var body: some View {
        VStack {
            SubNavigationBar(title: "리뷰") {
                store.send(.backButtonTapped)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .navigationBarHidden(true)
    }
}

#Preview {
    MyReviewsView(
        store: Store(initialState: MyReviewsFeature.State()) {
            MyReviewsFeature()
        }
    )
}
