//
//  GetLocationPermissionUseCase.swift
//  Domain
//
//  Created by 임영택 on 3/15/26.
//

import Dependencies

public struct GetLocationPermissionUseCase {
  public var execute: () -> Void
}

public enum GetLocationPermissionUseCaseKey: DependencyKey {
  public static var liveValue: GetLocationPermissionUseCase {
    @Dependency(\.locationManagerService) var locationManagerService

    return GetLocationPermissionUseCase {
      locationManagerService.requestAuthorization()
    }
  }
}

extension DependencyValues {
  public var getLocationPermissionUseCase: GetLocationPermissionUseCase {
    get { self[GetLocationPermissionUseCaseKey.self] }
    set { self[GetLocationPermissionUseCaseKey.self] = newValue }
  }
}
