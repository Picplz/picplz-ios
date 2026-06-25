//
//  PortfolioListFeature.swift
//  Features
//

import ComposableArchitecture
import Foundation

@Reducer
public struct PortfolioListFeature {

    @ObservableState
    public struct State: Equatable, Hashable {
        var portfolios: [MyPageFeature.Portfolio] = []
        var pendingDeleteId: String? = nil
        var isDeleteAlertPresented: Bool = false
        var toast: ToastItem? = nil

        public init(
            portfolios: [MyPageFeature.Portfolio] = [],
            toast: ToastItem? = nil
        ) {
            self.portfolios = portfolios
            self.toast = toast
        }
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case backButtonTapped
        case addButtonTapped
        case editTapped(MyPageFeature.Portfolio)
        case deleteRequested(String)
        case confirmDelete
        case dismissDeleteAlert
    }

    public init() {}

    public var body: some ReducerOf<PortfolioListFeature> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .backButtonTapped, .addButtonTapped, .editTapped:
                return .none
            case let .deleteRequested(id):
                state.pendingDeleteId = id
                state.isDeleteAlertPresented = true
                return .none
            case .confirmDelete:
                if let id = state.pendingDeleteId {
                    state.portfolios.removeAll { $0.id == id }
                    state.toast = ToastItem(message: "포트폴리오가 삭제되었습니다.")
                }
                state.pendingDeleteId = nil
                state.isDeleteAlertPresented = false
                return .none
            case .dismissDeleteAlert:
                state.pendingDeleteId = nil
                state.isDeleteAlertPresented = false
                return .none
            }
        }
    }
}
