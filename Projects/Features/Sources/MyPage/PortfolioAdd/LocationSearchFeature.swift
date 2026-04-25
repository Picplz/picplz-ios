//
//  LocationSearchFeature.swift
//  Features
//
//  Created by wonsik on 4/25/26.
//

import ComposableArchitecture
import Domain
import Foundation

@Reducer
public struct LocationSearchFeature {

    @ObservableState
    public struct State: Equatable, Hashable {
        var query: String = ""
        var results: [Area] = []

        var isShowNotFound: Bool {
            !query.trimmingCharacters(in: .whitespaces).isEmpty && results.isEmpty
        }

        public init(query: String = "", results: [Area] = []) {
            self.query = query
            self.results = results
        }
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case locationSelected(Area)
    }

    public init() {}

    public var body: some ReducerOf<LocationSearchFeature> {
        BindingReducer()
            .onChange(of: \.query) { _, newValue in
                Reduce { state, _ in
                    let query = newValue.trimmingCharacters(in: .whitespaces)
                    guard !query.isEmpty else {
                        state.results = []
                        return .none
                    }
                    // TODO: API 연동 시 searchAreasUseCase 호출로 교체
                    state.results = []
                    return .none
                }
            }
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .locationSelected:
                return .none
            }
        }
    }
}
