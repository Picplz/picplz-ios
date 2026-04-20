//
//  PackageAddFeature.swift
//  Features
//
//  Created by wonsik on 4/21/26.
//

import ComposableArchitecture

@Reducer
public struct PackageAddFeature {
    public static let maxNameLength: Int = 15
    public static let maxDetailLength: Int = 300

    public enum ShootingDuration: String, CaseIterable, Equatable, Hashable {
        case under15 = "15분 이내"
        case between15and30 = "15~30분"
        case between30and60 = "30분~1시간"
        case over60 = "1시간 이상"

        public var price: Int {
            switch self {
            case .under15: return 12_900
            case .between15and30: return 18_900
            case .between30and60: return 22_900
            case .over60: return 29_900
            }
        }
    }

    @ObservableState
    public struct State: Equatable, Hashable {
        var packageName: String = ""
        var coverImageURL: String? = nil
        var selectedDuration: ShootingDuration? = nil
        var detail: String = ""

        var isFormValid: Bool {
            !packageName.trimmingCharacters(in: .whitespaces).isEmpty
                && selectedDuration != nil
        }

        public init(
            packageName: String = "",
            coverImageURL: String? = nil,
            selectedDuration: ShootingDuration? = nil,
            detail: String = ""
        ) {
            self.packageName = packageName
            self.coverImageURL = coverImageURL
            self.selectedDuration = selectedDuration
            self.detail = detail
        }
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case backButtonTapped
        case bannerImageTapped
        case durationSelected(ShootingDuration)
        case saveButtonTapped
    }

    public init() {}

    public var body: some ReducerOf<PackageAddFeature> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.packageName):
                if state.packageName.count > Self.maxNameLength {
                    state.packageName = String(state.packageName.prefix(Self.maxNameLength))
                }
                return .none
            case .binding(\.detail):
                if state.detail.count > Self.maxDetailLength {
                    state.detail = String(state.detail.prefix(Self.maxDetailLength))
                }
                return .none
            case .binding:
                return .none
            case .backButtonTapped:
                return .none
            case .bannerImageTapped:
                return .none
            case let .durationSelected(duration):
                state.selectedDuration = duration
                return .none
            case .saveButtonTapped:
                return .none
            }
        }
    }
}
