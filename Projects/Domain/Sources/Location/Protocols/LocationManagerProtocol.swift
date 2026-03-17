//
//  LocationManagerProtocol.swift
//  Domain
//
//  Created by 임영택 on 3/15/26.
//

import CoreLocation
import Dependencies

public protocol LocationManagerServiceProtocol {
  var authStatus: LocationAuthStatus { get }
  func requestAuthorization()
  func requestCurrentLocation() async throws -> CLLocation
  func startUpdatingLocation() -> AsyncStream<CLLocation>
  func stopUpdatingLocation()
}

public enum LocationAuthStatus {
  case always
  case whenInUse
  case restricted
}

struct UnimplementedLocationManagerService: LocationManagerServiceProtocol {
  var authStatus = LocationAuthStatus.restricted
  
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
