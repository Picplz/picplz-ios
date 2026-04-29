//
//  SettingsView.swift
//  Features
//
//  Created by wonsik on 4/2/26.
//

import SwiftUI
import ComposableArchitecture

struct SettingsView: View {
    let store: StoreOf<SettingsFeature>

    var body: some View {
        VStack {
            SubNavigationBar(title: "설정") {
                store.send(.backButtonTapped)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .navigationBarHidden(true)
    }
}

#Preview {
    SettingsView(
        store: Store(initialState: SettingsFeature.State()) {
            SettingsFeature()
        }
    )
}
