//
//  RequestLocationPermissionFeature.swift
//  Features
//
//  Created by 임영택 on 3/15/26.
//

import ComposableArchitecture
import CoreLocation
import Foundation

@Reducer
public struct RequestLocationPermissionFeature {
  @ObservableState
  public struct State: Equatable, Hashable {
    public init() {}
  }

  public enum Action: Hashable {
    case nextButtonTapped
    case delegate(Delegate)

    public enum Delegate: Hashable {
      case completed
    }
  }

  public init() {}
  
  @Dependency(\.getLocationPermissionUseCase) private var getLocationPermissionUseCase

  public var body: some ReducerOf<RequestLocationPermissionFeature> {
    Reduce { state, action in
      switch action {
      case .nextButtonTapped:
        return .run { send in
          await MainActor.run {
            getLocationPermissionUseCase.execute()
          }
          await send(.delegate(.completed))
        }

      case .delegate:
        return .none
      }
    }
  }
}
