//
//  PastShootingsView.swift
//  Features
//
//  Created by wonsik on 4/2/26.
//

import SwiftUI
import ComposableArchitecture

struct PastShootingsView: View {
    let store: StoreOf<PastShootingsFeature>

    var body: some View {
        VStack {
            SubNavigationBar(title: "지난 촬영 내역") {
                store.send(.backButtonTapped)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .navigationBarHidden(true)
    }
}

#Preview {
    PastShootingsView(
        store: Store(initialState: PastShootingsFeature.State()) {
            PastShootingsFeature()
        }
    )
}
