//
//  FollowedArtistsFeature.swift
//  Features
//
//  Created by wonsik on 4/2/26.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct FollowedArtistsFeature {
        public struct FollowedArtist: Equatable, Hashable, Identifiable {
        public let id: String
        public let name: String
        public let profileImageURL: String?
        public let areas: [String]
        public let concepts: [String]
        public let isAvailableNow: Bool
    }

    @ObservableState
    public struct State: Equatable, Hashable {
        var artists: [FollowedArtist] = []

        public init(artists: [FollowedArtist] = []) {
            self.artists = artists
        }
    }

    public enum Action: Hashable {
        case backButtonTapped
        case artistTapped(FollowedArtist)
        // TODO: 팔로우 작가 목록 API 연동
        case onAppear
        case artistsLoaded([FollowedArtist])
    }

    public init() {}

    public var body: some ReducerOf<FollowedArtistsFeature> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .none
            case .artistTapped:
                return .none
            case .onAppear:
                // TODO: 팔로우 작가 목록 API 호출
                return .none
            case let .artistsLoaded(artists):
                state.artists = artists
                return .none
            }
        }
    }
}
