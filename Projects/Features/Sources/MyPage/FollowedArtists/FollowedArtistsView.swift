//
//  FollowedArtistsView.swift
//  Features
//
//  Created by wonsik on 4/2/26.
//

import SwiftUI
import ComposableArchitecture

struct FollowedArtistsView: View {
    let store: StoreOf<FollowedArtistsFeature>

    var body: some View {
        VStack {
            SubNavigationBar(title: "팔로우 작가") {
                store.send(.backButtonTapped)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .navigationBarHidden(true)
    }
}

#Preview {
    FollowedArtistsView(
        store: Store(initialState: FollowedArtistsFeature.State()) {
            FollowedArtistsFeature()
        }
    )
}
