//
//  LocationManagerProtocol.swift
//  Domain
//
//  Created by 임영택 on 3/15/26.
//

import CoreLocation
import Dependencies

public protocol LocationManagerProtocol {
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

struct UnimplementedLocationManager: LocationManagerProtocol {
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

public enum LocationManagerKey: TestDependencyKey {
  public static var testValue: LocationManagerProtocol = UnimplementedLocationManager()
}

public extension DependencyValues {
  var locationManagerService: LocationManagerProtocol {
    get { self[LocationManagerKey.self] }
    set { self[LocationManagerKey.self] = newValue }
  }
}
