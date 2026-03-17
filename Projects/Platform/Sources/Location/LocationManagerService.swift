//
//  LocationManagerService.swift
//  Platform
//
//  Created by 임영택 on 3/15/26.
//

import CoreLocation
import Domain

extension LocationAuthStatus {
  static func from(_ status: CLAuthorizationStatus) -> LocationAuthStatus {
    switch status {
    case .authorizedAlways:
      return .always
    case .authorizedWhenInUse:
      return .whenInUse
    default:
      return .restricted
    }
  }
}

public final class LocationManagerService: NSObject, LocationManagerServiceProtocol {
  public var authStatus: LocationAuthStatus
  
  // MARK: - Private Properties

  private let manager: CLLocationManager
  private var locationContinuation: CheckedContinuation<CLLocation, Error>?
  private var locationStreamContinuation: AsyncStream<CLLocation>.Continuation?

  public override init() {
    manager = CLLocationManager()
    authStatus = .from(manager.authorizationStatus)
    super.init()
    manager.delegate = self
  }

  // MARK: - Public Methods
  
  public func requestAuthorization() {
    manager.requestWhenInUseAuthorization()
  }

  /// 현재 위치 한 번만 요청
  public func requestCurrentLocation() async throws -> CLLocation {
    return try await withCheckedThrowingContinuation { continuation in
      self.locationContinuation = continuation
      manager.requestLocation()
    }
  }

  /// 실시간 위치 업데이트 스트림
  public func startUpdatingLocation() -> AsyncStream<CLLocation> {
    AsyncStream { continuation in
      self.locationStreamContinuation = continuation
      manager.startUpdatingLocation()

      continuation.onTermination = { [weak self] _ in
        self?.manager.stopUpdatingLocation()
        self?.locationStreamContinuation = nil
      }
    }
  }

  /// 실시간 위치 업데이트 중단
  public func stopUpdatingLocation() {
    manager.stopUpdatingLocation()
    locationStreamContinuation?.finish()
    locationStreamContinuation = nil
  }
}

// MARK: - CLLocationManagerDelegate

extension LocationManagerService: CLLocationManagerDelegate {
  public func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]
  ) {
    guard let location = locations.last else { return }

    // 단발성 요청 처리
    if let continuation = locationContinuation {
      continuation.resume(returning: location)
      locationContinuation = nil
    }

    // 스트림 요청 처리
    locationStreamContinuation?.yield(location)
  }

  public func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error
  ) {
    // 단발성 요청 에러 처리
    if let continuation = locationContinuation {
      continuation.resume(throwing: error)
      locationContinuation = nil
    }

    // 스트림에는 무시
  }
}
