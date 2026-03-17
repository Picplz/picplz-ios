//
//  GetNearDongsUseCase.swift
//  Domain
//
//  Created by 임영택 on 3/15/26.
//

import Dependencies
import CoreLocation

public struct GetNearDongsUseCase {
  public var execute: () async throws -> [Area]
  
  public init(execute: @escaping () async throws -> [Area]) {
    self.execute = execute
  }
}

public enum GetNearDongsUseCaseKey: DependencyKey {
  private static let defaultRadius = 1000

  public static var liveValue: GetNearDongsUseCase {
    @Dependency(\.locationManagerService) var locationManagerService
    @Dependency(\.areasRepository) var areasRepository

    return GetNearDongsUseCase {
      guard locationManagerService.authStatus != .restricted else {
        return []
      }
      
      let location = try await locationManagerService.requestCurrentLocation()
      return try await areasRepository.getNearbyAreas(
        radius: defaultRadius,
        latitude: location.coordinate.latitude,
        longitude: location.coordinate.longitude
      )
    }
  }
}

extension DependencyValues {
  public var getNearDongsUseCase: GetNearDongsUseCase {
    get { self[GetNearDongsUseCaseKey.self] }
    set { self[GetNearDongsUseCaseKey.self] = newValue }
  }
}
