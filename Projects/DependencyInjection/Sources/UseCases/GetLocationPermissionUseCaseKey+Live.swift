//
//  GetLocationPermissionUseCaseKey+Live.swift
//  DependencyInjection
//
//  Created by 임영택 on 3/18/26.
//

import Domain
import Dependencies

extension GetLocationPermissionUseCaseKey: @retroactive DependencyKey {
  public static var liveValue: GetLocationPermissionUseCase {
    @Dependency(\.locationManagerService) var locationManagerService
    return .live(locationManagerService: locationManagerService)
  }
}
