//
//  PhotoLibraryPermissionManagerProtocol.swift
//  Domain
//
//  Created by wonsik on 4/11/26.
//

import Dependencies
import Foundation

public protocol PhotoLibraryPermissionManagerProtocol {
  /// 현재 읽기/쓰기 권한 상태를 반환합니다.
  func currentStatus() -> PhotoLibraryAuthStatus

  /// 권한을 요청하고 결과 상태를 반환합니다.
  /// `.notDetermined` 상태일 때만 시스템 프롬프트가 노출되며,
  /// 이미 결정된 경우에는 현재 상태를 그대로 반환합니다.
  func requestAuthorization() async -> PhotoLibraryAuthStatus
}

public enum PhotoLibraryAuthStatus: Equatable {
  case notDetermined
  case authorized
  case limited
  case denied
  case restricted

  /// 사진을 가져올 수 있는 권한(전체 허용 또는 제한 허용)인지 여부
  public var isAccessible: Bool {
    switch self {
    case .authorized, .limited:
      return true
    case .notDetermined, .denied, .restricted:
      return false
    }
  }
}

struct UnimplementedPhotoLibraryPermissionManager: PhotoLibraryPermissionManagerProtocol {
  func currentStatus() -> PhotoLibraryAuthStatus {
    fatalError("구현되지 않은 메서드를 호출했습니다")
  }

  func requestAuthorization() async -> PhotoLibraryAuthStatus {
    fatalError("구현되지 않은 메서드를 호출했습니다")
  }
}

public enum PhotoLibraryPermissionManagerKey: TestDependencyKey {
  public static var testValue: PhotoLibraryPermissionManagerProtocol = UnimplementedPhotoLibraryPermissionManager()
}

public extension DependencyValues {
  var photoLibraryPermissionManagerService: PhotoLibraryPermissionManagerProtocol {
    get { self[PhotoLibraryPermissionManagerKey.self] }
    set { self[PhotoLibraryPermissionManagerKey.self] = newValue }
  }
}
