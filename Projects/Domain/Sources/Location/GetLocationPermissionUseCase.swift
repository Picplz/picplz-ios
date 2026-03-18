//
//  GetLocationPermissionUseCase.swift
//  Domain
//
//  Created by 임영택 on 3/15/26.
//

import Dependencies

public struct GetLocationPermissionUseCase {
  public var execute: () -> Void

  public static func live(locationManagerService: any LocationManagerProtocol) -> Self {
    Self {
      locationManagerService.requestAuthorization()
    }
  }

  public static var test: Self {
    Self { }
  }
}

public enum GetLocationPermissionUseCaseKey: TestDependencyKey {
  public static var testValue: GetLocationPermissionUseCase = .test
}

extension DependencyValues {
  public var getLocationPermissionUseCase: GetLocationPermissionUseCase {
    get { self[GetLocationPermissionUseCaseKey.self] }
    set { self[GetLocationPermissionUseCaseKey.self] = newValue }
  }
}
