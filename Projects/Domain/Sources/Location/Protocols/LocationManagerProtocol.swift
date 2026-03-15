//
//  LocationManagerProtocol.swift
//  Domain
//
//  Created by 임영택 on 3/15/26.
//

import CoreLocation
import Dependencies

public protocol LocationManagerServiceProtocol {
  func requestAuthorization()
  func requestCurrentLocation() async throws -> CLLocation
  func startUpdatingLocation() -> AsyncStream<CLLocation>
  func stopUpdatingLocation()
}

struct UnimplementedLocationManagerService: LocationManagerServiceProtocol {
  func requestAuthorization() {
    fatalError("구현되지 않은 메서드를 호출했습니다")
  }
  
  func requestCurrentLocation() async throws -> CLLocation {
    fatalError("구현되지 않은 메서드를 호출했습니다")
  }
  
  func startUpdatingLocation() -> AsyncStream<CLLocation> {
    fatalError("구현되지 않은 메서드를 호출했습니다")
  }
  
  func stopUpdatingLocation() {
    fatalError("구현되지 않은 메서드를 호출했습니다")
  }
}

public enum LocationManagerServiceKey: DependencyKey {
  public static var liveValue: LocationManagerServiceProtocol = UnimplementedLocationManagerService()
}

public extension DependencyValues {
  var locationManagerService: LocationManagerServiceProtocol {
    get { self[LocationManagerServiceKey.self] }
    set { self[LocationManagerServiceKey.self] = newValue }
  }
}
