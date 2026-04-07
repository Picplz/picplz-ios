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
        VStack(spacing: 0) {
            SubNavigationBar(title: "팔로우 작가") {
                store.send(.backButtonTapped)
            }
            .padding(.horizontal, 16)

            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(store.artists) { artist in
                        FollowedArtistCardView(artist: artist) {
                            store.send(.artistTapped(artist))
                        }
                        .padding(.horizontal, 16)

                        Rectangle()
                            .fill(Color(.pGrey2))
                            .frame(height: 1)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    FollowedArtistsView(
        store: Store(
            initialState: FollowedArtistsFeature.State(
                artists: [
                    .init(
                        id: "1",
                        name: "유가영 작가",
                        profileImageURL: nil,
                        areas: ["마포구", "서대문구"],
                        concepts: ["을지로 감성", "MZ 감성", "MZ 감성", "MZ 감성", "MZ 감성"],
                        isAvailableNow: true
                    ),
                    .init(
                        id: "2",
                        name: "유가영 작가",
                        profileImageURL: nil,
                        areas: ["동작구", "영등포구"],
                        concepts: ["을지로 감성", "MZ 감성", "MZ 감성"],
                        isAvailableNow: false
                    ),
                    .init(
                        id: "3",
                        name: "유가영 작가",
                        profileImageURL: nil,
                        areas: ["마포구", "맹구"],
                        concepts: ["을지로 감성", "MZ 감성", "MZ 감성"],
                        isAvailableNow: false
                    ),
                    .init(
                        id: "4",
                        name: "유가영 작가",
                        profileImageURL: nil,
                        areas: ["강남구", "강북구", "동대문구 외 3개"],
                        concepts: ["을지로 감성", "MZ 감성", "MZ 감성"],
                        isAvailableNow: false
                    ),
                    .init(
                        id: "5",
                        name: "유가영 작가",
                        profileImageURL: nil,
                        areas: ["강동구"],
                        concepts: ["을지로 감성", "MZ 감성", "MZ 감성"],
                        isAvailableNow: false
                    ),
                ]
            )
        ) {
            FollowedArtistsFeature()
        }
    )
}
