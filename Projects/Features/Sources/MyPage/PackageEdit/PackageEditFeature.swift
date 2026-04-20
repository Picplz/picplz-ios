//
//  PackageEditFeature.swift
//  Features
//
//  Created by wonsik on 4/20/26.
//

import ComposableArchitecture

@Reducer
public struct PackageEditFeature {
    @ObservableState
    public struct State: Equatable, Hashable {
        var packages: [MyPageFeature.ShootingPackage] = []
        var hasPackages: Bool { !packages.isEmpty }
        var selectedPackageID: String?
        var isMenuPresented: Bool = false

        public init(
            packages: [MyPageFeature.ShootingPackage] = [],
            selectedPackageID: String? = nil,
            isMenuPresented: Bool = false
        ) {
            self.packages = packages
            self.selectedPackageID = selectedPackageID
            self.isMenuPresented = isMenuPresented
        }
    }

    public enum Action: Hashable {
        case backButtonTapped
        case addPackageTapped
        case packageMenuTapped(String)
        case menuDismissed
        case editPackageTapped
        case deletePackageTapped
    }

    public init() {}

    public var body: some ReducerOf<PackageEditFeature> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .none
            case .addPackageTapped:
                return .none
            case let .packageMenuTapped(id):
                state.selectedPackageID = id
                state.isMenuPresented = true
                return .none
            case .menuDismissed:
                state.isMenuPresented = false
                state.selectedPackageID = nil
                return .none
            case .editPackageTapped:
                state.isMenuPresented = false
                return .none
            case .deletePackageTapped:
                if let id = state.selectedPackageID {
                    state.packages.removeAll { $0.id == id }
                }
                state.isMenuPresented = false
                state.selectedPackageID = nil
                return .none
            }
        }
    }
}
